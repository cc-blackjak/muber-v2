//
//  HomeController.swift
//  muber-v2
//
//  Created by LucySD on 2021/04/19.
//

import UIKit
import FirebaseAuth
import MapKit

protocol HomeControllerDelegate: class {
    func handleMenuToggle()
}
private let reuseIdentifier = "LocationCell"

private enum actionButtonConfiguration {
    case showMenu
    case dismissActionView
    
    init() {
        self = .showMenu
    }
    
}

class HomeController: UIViewController {
    

    // MARK: - Properties
    private let locationManager = LocationHandler.shared.locationManager
    private let mapView = MKMapView()
    private let inputActivationView = LocatationInputActivationView()
    private let rideActionView = RideActionView()
    private let calendarAndListView = CalendarAndListView()
    private let items = ItemsView()
    private let detailItem = DetailItemView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    private var searchResults = [MKPlacemark]()
    private final let locationInputViewHeight: CGFloat = 200
    private final let rideActionViewHeight: CGFloat = 300
    private final let calendarAndListViewHeight: CGFloat = 800

    private var actionButttonConfig = actionButtonConfiguration()
    private var route: MKRoute?
    
    var user: User? {
        didSet { locationInputView.user = user }
    }
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
    

    weak var delegate: HomeControllerDelegate?   
//     var user: User? {
//        didSet {
//            locationInputView.use = user
//
//            if user?.accountType == .passenger {
//                fetchDrivers()
//                configureLocationInputActivationView()
//                observeCurrentTrip()
//            }else{
//                observeTrips()
//            }
//        }
//    }

    // MARK: - Selectors
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        enableLocationservices()
//        signOut()
    }
    
    //MARK: - Selectors
    
    @objc func actionButtonPressed() {
        switch actionButttonConfig {
        case .showMenu:
            delegate?.handleMenuToggle()
        case .dismissActionView:
            removeAnnotationsAndOverlays()
            mapView.showAnnotations(mapView.annotations, animated: true)
            
                UIView.animate(withDuration: 0.3) {
                    self.inputActivationView.alpha = 1
                    self.configureActionButton(config: .showMenu)
                    self.animateRideActionView(shouldShow: false)
                    self.animateCalendarAndListView(shouldShow: false)
                    self.animateItemsView(shouldShow: false)
                    self.animateDetailItemView(shouldShow: false)
                }
            }
    }
    
    // MARK: - API
    
    func fetchUserData() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Service.shared.fetchUserData(uid: currentUid) { user in
            self.user = user
        }
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            configure()
        }
    }
    
    
    

    //MARK: - Helper Functions

    fileprivate func configureActionButton(config: actionButtonConfiguration) {
        switch config {
        case .showMenu:
            self.actionButton.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
            self.actionButttonConfig = .showMenu
        case .dismissActionView:
            actionButton.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp-1").withRenderingMode(.alwaysOriginal), for: .normal)
            actionButttonConfig = .dismissActionView
        }
    }

    
    func configure() {
        configureUI()
   

        fetchUserData()
//        fetchDrivers()

    }
    
    func configureUI(){
        configureMapView()
        configureRideActionView()
        configureCalendarAndListView()
        configureItemsView()
        configureDetailItemView()
        
        view.addSubview(actionButton)
        actionButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                            paddingTop: 16, paddingLeft:16, width:30, height: 30)

        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimentions(height: 50, width: view.frame.width - 64)
        inputActivationView.anchor(top: actionButton.bottomAnchor, paddingTop: 32)
        inputActivationView.alpha = 0
        inputActivationView.delegate = self  // Add delegate or else it wont work
        
        UIView.animate(withDuration: 2) {
            self.inputActivationView.alpha = 1
        }
        
        configureTableiew()
    }
    
    func configureRideActionView() {
        view.addSubview(rideActionView)
        rideActionView.delegate = self
        rideActionView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: rideActionViewHeight)
        print("DEBUG: test1")
    }
    
    func configureCalendarAndListView() {
        view.addSubview(calendarAndListView)
        calendarAndListView.delegate = self
        calendarAndListView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width , height: view.frame.height)
        print("DEBUG: test2")
    }

    func configureItemsView() {
        view.addSubview(items)
        items.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width , height: view.frame.height)
        print("DEBUG: test3")
    }
    
    func configureDetailItemView() {
        view.addSubview(detailItem)
        items.delegate = self
        detailItem.delegate = self
        detailItem.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width , height: view.frame.height)
        print("DEBUG: test4")
    }
    
    func configureMapView(){
        view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
    }
    
    func configureLocationInputView() {
        locationInputView.delegate = self
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: locationInputViewHeight)
        locationInputView.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {self.locationInputView.alpha = 1}) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.frame.origin.y = self.locationInputViewHeight
            })
        }
    }
    
    func configureTableiew() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        
        let height = view.frame.height - locationInputViewHeight
        tableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
        
        view.addSubview(tableView)
    }
    
    func dismissLocationView(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.view.frame.height //tableを畳んだ時に見えなくする
            self.locationInputView.removeFromSuperview()
        }, completion: completion)
    }
    
    func animateRideActionView(shouldShow: Bool, destination: MKPlacemark? = nil) {
        let yOrigin = shouldShow ? self.view.frame.height - self.rideActionViewHeight :
            self.view.frame.height
        
        if shouldShow {
            guard let destination = destination else { return }
            rideActionView.destination = destination
        }
        
        UIView.animate(withDuration: 0.3) {
            self.rideActionView.frame.origin.y = yOrigin
        }
    }
    
    func animateCalendarAndListView(shouldShow: Bool) {
        print("animateCalendarAndListView")
        let yOrigin = shouldShow ? self.view.frame.height - self.calendarAndListViewHeight :
            self.view.frame.height
        
        UIView.animate(withDuration: 0.3) {
            self.calendarAndListView.frame.origin.y = yOrigin
        }
    }
    
    func animateItemsView(shouldShow: Bool) {
        print("animateItemsView")
        let yOrigin = shouldShow ? self.view.frame.height - self.calendarAndListViewHeight :
            self.view.frame.height
        
        UIView.animate(withDuration: 0.3) {
            self.items.frame.origin.y = yOrigin
        }
    }
    
    func animateDetailItemView(shouldShow: Bool) {
        print("animateDetailItemView")
        let yOrigin = shouldShow ? self.view.frame.height - self.calendarAndListViewHeight :
            self.view.frame.height
        
        UIView.animate(withDuration: 0.3) {
            self.detailItem.frame.origin.y = yOrigin
        }
    }
}

//MARK: - Map Helper Functions

private extension HomeController {
    func searchBy(naturalLanguageQuery: String, completion: @escaping([MKPlacemark]) -> Void) {
        var results = [MKPlacemark]()
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQuery
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {return}
            
            response.mapItems.forEach({ item in
                results.append(item.placemark)
            })
            completion(results)
        }
    }
    
    func generatePolyline(toDestination destination: MKMapItem) {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
        request.transportType = .automobile
        
        let directionRequest = MKDirections(request: request)
        directionRequest.calculate{(response, error) in
            guard let response = response else { return }
            self.route = response.routes[0]
            guard let polyline = self.route?.polyline else { return }
            self.mapView.addOverlay(polyline)
        }
    }
    
    func removeAnnotationsAndOverlays() {
        mapView.annotations.forEach{(annotation) in
            if let anno = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(anno)
            }
        }
        
        if mapView.overlays.count > 0 {
            mapView.removeOverlay(mapView.overlays[0])
        }
    }
}

//MARK: MKMapViewDeligate

extension HomeController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let route = self.route {
            let polyline = route.polyline
            let lineRenderer = MKPolylineRenderer(overlay: polyline)
            lineRenderer.strokeColor = .mainBlueTint
            lineRenderer.lineWidth = 4
            print("polyline")
            return lineRenderer
            
        }
        return MKOverlayRenderer()
    }
}
//MARK: - LocationServices

extension HomeController {
    func enableLocationservices() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("DEBUG: Not determined..")
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("DEBUG: Auth always..")
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("DEBUG: Auth when in use..")
            locationManager?.requestAlwaysAuthorization()
        @unknown default:
            break
        }

        
    }
    
}

// MARK: - LocatationInputActivationViewDelegate

extension HomeController: LocatationInputActivationViewDelegate {
    func presentLocationInputView() {
        inputActivationView.alpha = 0
        configureLocationInputView()
    }
}

// MARK: - LocationInputViewDelegate
    
extension HomeController: LocationInputViewDelegate {
    func executeSearch(query: String) {
        searchBy(naturalLanguageQuery: query) { (results) in
            self.searchResults = results
            self.tableView.reloadData()
        }
    }
    
    func dismissLocationInputView() {
        dismissLocationView { _ in 
            UIView.animate(withDuration: 0.3, animations: {
                self.inputActivationView.alpha = 1
            })
        }
    }
}
// MARK: - UITableViewDelegate/dataSource

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "test"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
        if indexPath.section == 1 {
            cell.placemark = searchResults[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlacemark = searchResults[indexPath.row]
        var annotations = [MKAnnotation]()
        
        configureActionButton(config: .dismissActionView)
        
        let destination = MKMapItem(placemark: selectedPlacemark)
        generatePolyline(toDestination: destination)
        
        dismissLocationView {_ in
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedPlacemark.coordinate
            self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)

                self.mapView.annotations.forEach{(annotation) in
                    if let anno = annotation as? MKUserLocation {
                        annotations.append(anno)
                    }

                    if let anno = annotation as? MKPointAnnotation {
                        annotations.append(anno)
                    }
                }

            self.mapView.zoomToFit(annotations: annotations)
            
            Service.shared.uploadDestinationAddressAndName(destinationAddress: selectedPlacemark.address ?? "none", destinationName: selectedPlacemark.name ?? "none") { (error, ref) in
                if let error = error {
                    print("DEBUG: Failed to upload trip with error \(error)")
                    return
                }
                print("DEBUG: Did upload trip successfully")
            }
            self.animateRideActionView(shouldShow: true, destination: selectedPlacemark)
            
        }
    }
}

extension HomeController: RideActionViewDelegate {
    func proceedToSetDateAndUploadAddress(_ view: RideActionView){
        guard let pickupCoordinates = locationManager?.location?.coordinate else { return }
        guard let destinationCoordinates = view.destination?.coordinate else { return }

        print(searchResults)
        Service.shared.uploadCoordinates(pickupCoordinates, destinationCoordinates) { (error, ref) in
            if let error = error {
                print("DEBUG: Failed to upload trip with error \(error)")
                return
            }
            print("DEBUG: Did upload trip successfully")

        }
        print("Hello")
        self.animateCalendarAndListView(shouldShow: true)
        
    }
}

// CalendarAndListView -> ItemsView
extension HomeController: CalendarAndListViewDelegate {
    func proceedToItemsView(_ view: CalendarAndListView) {
        
        print("proceeding to items...")
        self.animateItemsView(shouldShow: true)
    }
}

// ItemsView -> DetailItemView
extension HomeController: ItemsViewDelegate {
    func proceedToDetailItemView(_ view: ItemsView) {
        print("proceeding to detailitem...")
        self.animateDetailItemView(shouldShow: true)
    }
}

// DetailItemView -> ItemsView
extension HomeController: DetailItemViewDelegate {
    func returnToItemsView(_ view: DetailItemView) {
        print("return to item...")
        self.animateDetailItemView(shouldShow: false)
    }
}


// ItemsView -> ConfirmView
