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
    private let moverActionView = MoverActionView()
    private let moverConfirmView = MoverConfirmView()
    private let moverWaitingView = MoverWaitingView()
    private let calendarAndListView = CalendarAndListView()
    private let items = ItemsView()
    private let detailItem = DetailItemView()
    private let confirmationPageView = ConfirmationPageView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    private var tripsListController: TripsListController!
    private var searchResults = [MKPlacemark]()
    private final let locationInputViewHeight: CGFloat = 200
    private final let rideActionViewHeight: CGFloat = 300
    private final let calendarAndListViewHeight: CGFloat = 720

    private var actionButttonConfig = actionButtonConfiguration()
    private var route: MKRoute?
    
    var user: User? {
        didSet {
            locationInputView.user = user
            
            if user?.accountType == .passenger {
                // Riderが必要な画面
                print("\n\(loadedNumber). \(String(describing: type(of: self))) > User didSet > .passenger is loaded.")
                loadedNumber += 1
                
                print("HomeC > User > didSet > passenger login")
                configureRideActionView()
                configureCalendarAndListView()
                configureLocationInputActivationView()
                configureItemsView()
                configureDetailItemView()
                configureConfirmationPageView()
                configureActionButton(config: .showMenu)
                
                configureTableiew()
            } else {
                // Moverが必要な画面
                print("\n\(loadedNumber). \(String(describing: type(of: self))) > User didSet > else is loaded.")
                loadedNumber += 1
                
                print("HomeC > User > didSet > not passenger login")
                // obseveTrips は非同期処理なので、他の画面読み込みはobserveTripsクロージャ内にて行う
                configureMoverActionView()
                configureMoverDetailView()
                observeTrips()
            }
        }
    }
    
    var trip: Trip? {
        didSet { confirmationPageView.trip = trip}
    }
    
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
        
        enableLocationservices()
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
                    self.animateItemsView(shouldShow: false)
                    self.animateDetailItemView(shouldShow: false)
                    self.animateConfirmationPageView(shouldShow: false)
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
    
    func fetchUserTripData() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Service.shared.fetchUserTripData(uid: currentUid) { trip in
            self.trip = trip
        }
    }
    
//    func checkIfUserIsLoggedIn(){
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
//        configureUI()
//        fetchUserData()
//        fetchUserTripData()
////        fetchDrivers()
//    }
    
    func configureUI(){
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configureUI is loaded.")
        loadedNumber += 1
        
        // マップ層 MKMapView を読み出し
        configureMapView()
        
        // ハンバーガーメニューボタンを直で付け足し
        view.addSubview(actionButton)
        actionButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                            paddingTop: 16, paddingLeft:16, width:30, height: 30)
        
        UIView.animate(withDuration: 2) {
            self.inputActivationView.alpha = 1
        }
    }
    
    // ライダー用 入力画面 Where部分
    func configureLocationInputActivationView() {
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimensions(height: 50, width: view.frame.width - 64)
        inputActivationView.anchor(top: actionButton.bottomAnchor, paddingTop: 32)
        inputActivationView.alpha = 0
        inputActivationView.delegate = self
        
        UIView.animate(withDuration: 0.5) {
            self.inputActivationView.alpha = 1
        }
    }
    
    // ライダー用のマップルートビューを表示
    func configureRideActionView() {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configureRideActionView is loaded.")
        loadedNumber += 1
        
        view.addSubview(rideActionView)
        rideActionView.delegate = self
        rideActionView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: rideActionViewHeight)
        print("Configuring ride action view...")

    }
    
    // カレンダー/アイテムリスト表示
    func configureCalendarAndListView() {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configureCalendarAndListView is loaded.")
        loadedNumber += 1
        
        view.addSubview(calendarAndListView)
        calendarAndListView.delegate = self
        calendarAndListView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width , height: calendarAndListViewHeight)
        print("Configuring calendar view...")

    }

    func configureItemsView() {
        view.addSubview(items)
        items.delegate = self
        items.delegate2 = self
        items.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width , height: calendarAndListViewHeight)
        print("Configuring items view...")
    }
    
    func configureDetailItemView() {
        view.addSubview(detailItem)
        detailItem.delegate = self
        detailItem.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width , height: calendarAndListViewHeight)
        print("Configuring detail item view...")
    }
    
    func configureConfirmationPageView() {
        view.addSubview(confirmationPageView)
        confirmationPageView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width , height: calendarAndListViewHeight)
        print("Configuring confirmation page view...")
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
    
    // ライダー用入力後画面???を表示
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
    
    func animateConfirmationPageView(shouldShow: Bool) {
        print("animateConfirmationPageView")
        let yOrigin = shouldShow ? self.view.frame.height - self.calendarAndListViewHeight :
            self.view.frame.height
        
        UIView.animate(withDuration: 0.3) {
            self.confirmationPageView.frame.origin.y = yOrigin
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
    
    // Mover用に、指定地点からのルートを表示可能に。デフォルト(Riderでの使用時)は現在地を取得
    func generatePolyline(fromOrigin origin: MKMapItem = MKMapItem.forCurrentLocation(), toDestination destination: MKMapItem) {
        let request = MKDirections.Request()
        request.source = origin
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
        return "Search results..."
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > tableView(UITableViewDelegate/dataSource) is loaded.")
        loadedNumber += 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
        
            cell.placemark = searchResults[indexPath.row]
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
        print("DEBUG: RideActionViewDelegate")
        self.animateCalendarAndListView(shouldShow: true)
        
    }
}

// MARK: - Mover's actions / TripsListControllerDelegate

extension HomeController: TripsListControllerDelegate {
    // Mover用 ListItemsを表示
    func configureTripsListView() {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configureTripsListView is loaded.")
        loadedNumber += 1
        
        tripsListController = TripsListController()
        addChild(tripsListController)
        tripsListController.didMove(toParent: self)
        tripsListController.view.frame = CGRect(x: 0, y: 120, width: self.view.frame.width, height: self.view.frame.height)
        view.insertSubview(tripsListController.view!, at: 1)
        self.tripsListController.view.alpha = 1
        tripsListController.delegate = self
    }
    
    func observeTrips() {
        DriverService.shared.observeTrips { status in
            print("\n\(loadedNumber). \(String(describing: type(of: self))) > observeTrips(calling observeTrips) is loaded.")
            loadedNumber += 1
            
            print("observeTrips > print tripsArray: ", tripsArray)
            print("observeTrips > print reservedTrip: ", reservedTrip)
            if reservedTrip == nil {
                self.configureTripsListView()
            } else {
                self.configureMoverWaitingView()
                self.animateMoverWaitingView(shouldShow:true)
            }
        }
    }
    
    func tripSelected(selectedRow: Int) {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configureCalendarAndListView is loaded.")
        loadedNumber += 1
        
        // テーブルビューを透明にすることでごまかす
        print("Delegate success.")
        UIView.animate(withDuration: 0.3) {
            self.tripsListController.view.alpha = 0
        }
        tripsListController.view.removeFromSuperview()
        
        // マップにルートを表示させる
        var annotations = [MKAnnotation]()
        
        // 戻るボタン。Mover用に要改変
        configureActionButton(config: .dismissActionView)
        
        // 行き先は元から指定していたので、流用
        let selectedPlacemark = MKPlacemark(coordinate: tripsArray[selectedRow].destinationCoordinates)
        let destination = MKMapItem(placemark: selectedPlacemark)
        
        // 出発地点はなかったので、新規作成
        let pickupPlacemark = MKPlacemark(coordinate: tripsArray[selectedRow].pickupCoodinates)
        let origin = MKMapItem(placemark: pickupPlacemark)
        
        // Originの指定を元関数に追加し、指定
        generatePolyline(fromOrigin: origin, toDestination: destination)
        
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
        }
        
        configureMoverActionView()
        animateMoverActionView(shouldShow: true, destination: selectedPlacemark)
    }
}

extension HomeController: MoverActionViewDelegate {
    // Mover用のマップルートビュー(See detailボタン画面)を表示
    func configureMoverActionView() {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configureMoverActionView is loaded.")
        loadedNumber += 1
        
        view.addSubview(moverActionView)
        moverActionView.delegate = self
        moverActionView.frame = CGRect(x: 0,
                                      y: view.frame.height,
                                      width: view.frame.width,
                                      height: rideActionViewHeight)
    }
    
    func animateMoverActionView(shouldShow: Bool, destination: MKPlacemark? = nil) {
        let yOrigin = shouldShow ? self.view.frame.height - self.rideActionViewHeight :
            self.view.frame.height
        
        moverActionView.muberLabel.text = tripsArray[selectedTripRow!].destinationName
        
        if shouldShow {
            guard let destination = destination else { return }
            moverActionView.destination = destination
        }
        
        UIView.animate(withDuration: 0.3) {
            self.moverActionView.frame.origin.y = yOrigin
        }
    }
    
    // See detail ボタンが押されたら、DetailViewを更新した上で表示させる
    func proceedToConfirmView(_ view: MoverActionView) {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > proceedToConfirmView is loaded.")
        loadedNumber += 1
        
        // Format detail
        
        moverConfirmView.destNameLabel.text = "Destination: \(tripsArray[selectedTripRow!].destinationName!)"
        moverConfirmView.destAddressLabel.text = "\(tripsArray[selectedTripRow!].destinationAddress!)"
        moverConfirmView.dateLabel.text = "Day: \(tripsArray[selectedTripRow!].date!)"
        
        var tmpText = "Items:"
        for item in tripsArray[selectedTripRow!].items! {
            print(item)
            tmpText += "\n\t - "
            tmpText += "\(item["title"] ?? "")"
            tmpText += "\n\t\t - \(item["memo"] ?? "")"
        }
        moverConfirmView.itemsLabel.text = tmpText
        
        animateMoverActionView(shouldShow: false)
        animateMoverConfirmView(shouldShow: true)
    }
    
}

extension HomeController: MoverConfirmViewDelegate {
    // Mover用のマップルートビューを表示
    func configureMoverDetailView() {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configureMoverDetailView is loaded.")
        loadedNumber += 1
        
        view.addSubview(moverConfirmView)
        moverConfirmView.delegate = self
        moverConfirmView.frame = CGRect(x: 0,
                                      y: view.frame.height,
                                      width: view.frame.width,
                                      height: view.frame.height)
    }
    
    func animateMoverConfirmView(shouldShow: Bool) {
        let yOrigin = shouldShow ? 0 :
            self.view.frame.height
        
//        moverActionView.muberLabel.text = tripsArray[selectedTripRow!].passengerUid
        
        UIView.animate(withDuration: 0.3) {
            self.moverConfirmView.frame.origin.y = yOrigin
        }
    }
    
    func proceedToConfirmAndUpload(_ view: MoverConfirmView) {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > proceedToConfirmAndUpload is loaded.")
        loadedNumber += 1
        
        // 更新すべき内容記載してアップロードする
        let updateDic = [
            "driverUid" : loginUid!,
            "state" : 2
        ] as [String : Any]
        
        REF_TRIPS.child(tripsArray[selectedTripRow!].passengerUid).updateChildValues(updateDic)
        animateMoverConfirmView(shouldShow: false)
    }
}

// Mover用の予約後画面を表示, デリゲートは追加するかもしれないので、Extensionとして切り出し
extension HomeController {
    func configureMoverWaitingView() {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configureMoverDetailView is loaded.")
        loadedNumber += 1
        
        view.addSubview(moverWaitingView)
//        moverWaitingView.delegate = self
        moverWaitingView.frame = CGRect(x: 0,
                                      y: view.frame.height,
                                      width: view.frame.width,
                                      height: view.frame.height)
        
        // reservedTrip より内容を反映
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy年MM月dd日 H:mm"
        moverWaitingView.destNameLabel.text = "Destination: \(reservedTrip!.destinationName!)"
        moverWaitingView.destAddressLabel.text = "\(reservedTrip!.destinationAddress!)"
        moverWaitingView.dateLabel.text = "Day: \(reservedTrip!.date!)"
        
        var tmpText = "Items:"
        for item in reservedTrip?.items as! [[String:String]] {
            print(item)
            tmpText += "\n\t - "
            tmpText += "\(item["title"] ?? "")"
            tmpText += "\n\t\t - \(item["memo"] ?? "")"
        }
        moverWaitingView.itemsLabel.text = tmpText
        
        // マップにルートを表示させる
        var annotations = [MKAnnotation]()
        
//        // 戻るボタン。Mover用に要改変
//        configureActionButton(config: .dismissActionView)
        
        // 行き先は元から指定していたので、流用
        let selectedPlacemark = MKPlacemark(coordinate: (reservedTrip?.destinationCoordinates)!)
        let destination = MKMapItem(placemark: selectedPlacemark)
        
        // 出発地点はなかったので、新規作成
        let pickupPlacemark = MKPlacemark(coordinate: (reservedTrip?.pickupCoodinates)!)
        let origin = MKMapItem(placemark: pickupPlacemark)
        
        // Originの指定を元関数に追加し、指定
        generatePolyline(fromOrigin: origin, toDestination: destination)
        
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
        }
        
    }
    
    func animateMoverWaitingView(shouldShow: Bool) {
        let yOrigin = shouldShow ? 500 :
            self.view.frame.height
        
//        moverActionView.muberLabel.text = tripsArray[selectedTripRow!].passengerUid
        
        UIView.animate(withDuration: 0.3) {
            self.moverWaitingView.frame.origin.y = yOrigin
        }
    }
}

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
        
        // selectedRow がnil でない場合、DetailItemViewのTextBoxを入れておく
        if selectedItemRow != nil {
            self.detailItem.detailItemTitleTextField.text = itemsList[selectedItemRow!]["title"]!
            self.detailItem.detailItemInformationTextField.text = itemsList[selectedItemRow!]["memo"]!
        }
        
        self.animateDetailItemView(shouldShow: true)
    }
}

// ItemsView -> ConfirmView
extension HomeController: ItemsViewDelegate2 {
    func proceedToConfirmationPageView(_ view: ItemsView) {
        print("proceeding to confirmation page...")
        self.confirmationPageView.tableView.reloadData()
        fetchUserTripData()
        self.animateConfirmationPageView(shouldShow: true)
    }
}

// DetailItemView -> ItemsView
extension HomeController: DetailItemViewDelegate {
    func returnToItemsView(_ view: DetailItemView) {
        print("HomeController > returnToItemsView called start.")
        self.items.tableView.reloadData()
        self.animateDetailItemView(shouldShow: false)
        print("HomeController > returnToItemsView called end.")
    }
}


