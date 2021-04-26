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
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    private let tripsListView = UITableView()
    private var tripsListController: TripsListController!
    private var searchResults = [MKPlacemark]()
    private final let locationInputViewHeight: CGFloat = 200
    private final let rideActionViewHeight: CGFloat = 300
    private final let calendarAndListViewHeight: CGFloat = 800

    private var actionButttonConfig = actionButtonConfiguration()
    private var route: MKRoute?
    
    
    var user: User? {
        didSet {
            locationInputView.user = user
            
            if user?.accountType == .passenger {
                print("\n\(loadedNumber). \(String(describing: type(of: self))) > User didSet > .passenger is loaded.")
                loadedNumber += 1
                
                print("HomeC > User > didSet > passenger login")
                configureRideActionView()
                
                configureLocationInputActivationView()
                
                configureTableiew()
            } else {
                print("\n\(loadedNumber). \(String(describing: type(of: self))) > User didSet > else is loaded.")
                loadedNumber += 1
                
                print("HomeC > User > didSet > not passenger login")
                
                configureTripsListView()
            }
        }
    }
    //     チュートリアル完成形
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
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()

    weak var delegate: HomeControllerDelegate?   

    // MARK: - Selectors
    
    // ライダー/Mover共通画面処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\n\(loadedNumber). HomeController > viewDidLoad is loaded.")
        loadedNumber += 1
        
//        checkIfUserIsLoggedIn()
        enableLocationservices()
//        configure()
        configureUI()
    }
    
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
                }
            }
    }
    
    // MARK: - API
    
//    func fetchUserData() {
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//        Service.shared.fetchUserData(uid: currentUid) { user in
//            self.user = user
//        }
//    }
    
//    func checkIfUserIsLoggedIn(){
//        print("\n\(loadedNumber). \(String(describing: type(of: self))) > extension checkIfUserIsLoggedIn is loaded.")
//        loadedNumber += 1
//
//        if Auth.auth().currentUser?.uid == nil {
//            DispatchQueue.main.async {
//                let nav = UINavigationController(rootViewController: LoginController())
//                nav.modalPresentationStyle = .fullScreen
//                self.present(nav, animated: true, completion: nil)
//            }
//        } else {
//            configure()
//        }
//    }
    
    
    

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

    
//    func configure() {
//        print("\n\(loadedNumber). \(String(describing: type(of: self))) > enableLocationservices is loaded.")
//        loadedNumber += 1
//
//        configureUI()
////        fetchUserData()
////        fetchDrivers()
//    }
    
    func configureUI(){
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configureUI is loaded.")
        loadedNumber += 1
        
        // マップ層 MKMapView を読み出し
        configureMapView()
        
//        // ライダー用画面層 class RideActionView を読み出し
//        configureRideActionView()
        
        // カレンダー/リスト層 class CalendarAndListView を読み出し
        configureCalendarAndListView()
        
        // ハンバーガーメニューボタンを直で付け足し
        view.addSubview(actionButton)
        actionButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                            paddingTop: 16, paddingLeft:16, width:30, height: 30)
        
        UIView.animate(withDuration: 2) {
            self.inputActivationView.alpha = 1
        }
//
//        // ライダー用のテーブルビュー
//        configureTableiew()
    }
    
    func configureLocationInputActivationView() {
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimensions(height: 50, width: view.frame.width - 64)
        inputActivationView.anchor(top: actionButton.bottomAnchor, paddingTop: 32)
        inputActivationView.alpha = 0
        inputActivationView.delegate = self
        
        UIView.animate(withDuration: 2) {
            self.inputActivationView.alpha = 1
        }
    }
    
    // rideActionView = ライダー用の画面を表示
    func configureRideActionView() {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configureRideActionView is loaded.")
        loadedNumber += 1
        
        view.addSubview(rideActionView)
        rideActionView.delegate = self
        rideActionView.frame = CGRect(x: 0,
                                      y: view.frame.height,
                                      width: view.frame.width,
                                      height: rideActionViewHeight)
        print("DEBUG: test1 RideAction View loaded")
    }
    
    // カレンダー/アイテムリスト表示
    func configureCalendarAndListView() {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configureCalendarAndListView is loaded.")
        loadedNumber += 1
        
        view.addSubview(calendarAndListView)
        calendarAndListView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width , height: view.frame.height)
        print("DEBUG: test2 Calendar And List View loaded")
    }
   
    // Mapを表示
    func configureMapView(){
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configureMapView is loaded.")
        loadedNumber += 1
        
        view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
    }
    
    // Whereを表示
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
    
    // Mover用 ListItems
    func configureTripsListView() {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configureTripsListView is loaded.")
        loadedNumber += 1
        
        tripsListController = TripsListController()
        addChild(tripsListController)
        tripsListController.didMove(toParent: self)
        tripsListController.view.frame = CGRect(x: 0, y: 120, width: self.view.frame.width, height: self.view.frame.height)
        view.insertSubview(tripsListController.view!, at: 1)
//        tripsListController.delegate = self
    }
    
    func configureTableiew() {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configureTableiew is loaded.")
        loadedNumber += 1
        
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
        let yOrigin = shouldShow ? self.view.frame.height - self.calendarAndListViewHeight :
            self.view.frame.height
        
        UIView.animate(withDuration: 0.3) {
            self.calendarAndListView.frame.origin.y = yOrigin
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

// allow

extension HomeController {
    func enableLocationservices() {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > enableLocationservices is loaded.")
        loadedNumber += 1
        
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

// MARK: - Delegates

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
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > tableView(UITableViewDelegate/dataSource) is loaded.")
        loadedNumber += 1
        
        return "Please select your destination."
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
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > tableView > indexPath is loaded.")
        loadedNumber += 1
        
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
            
            self.animateRideActionView(shouldShow: true, destination: selectedPlacemark)
            
        }
    }
}

extension HomeController: RideActionViewDelegate {
    
    func proceedToSetDateAndUploadAddress(_ view: RideActionView){
        guard let pickupCoordinates = locationManager?.location?.coordinate else { return }
        guard let destinationCoordinates = view.destination?.coordinate else { return }
        
        Service.shared.uploadAddress(pickupCoordinates, destinationCoordinates) { (error, ref) in
            if let error = error {
                print("DEBUG: Failed to upload trip with error \(error)")
                return
            }
            print("DEBUG: Did upload trip successfully")

        }
        self.animateCalendarAndListView(shouldShow: true)
        
    }
}

