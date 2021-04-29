//
//  containerController.swift
//  Muber
//
//  Created by 中路亜理沙 on 16/04/2021.
//
//import Foundation
import UIKit
import FirebaseAuth

class ContainerController: UIViewController{
    // MARK: - Properties
    
    private let homeController = HomeController()
    private var menuController: MenuController! = nil
    private var isExpanded = false
    private let shadedView = UIView()
    private lazy var xOrigin = self.view.frame.width - 80

    // ***fetch関連
    private var user: User? {
        didSet {
            guard let user = user else { return }
            homeController.user = user
            configureMenuController(withUser: user)
        }
    }
    
    // MARK: -Lifecycle
        
    override func viewDidLoad(){
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    @objc func dismissMenu() {
        isExpanded = false
        animateMenu(shouldExpand: isExpanded)
    }
    
    // MARK: -API
    
    func signOut() {
        do {
            homeController.inputActivationView.alpha = 0
            homeController.tripsListController?.view.alpha = 0
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            print("DEBUG: Error signing out")
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            presentLoginController()
        } else {
            configure()
        }
    }
    
    func fetchUserData() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Service.shared.fetchUserData(uid: currentUid) { user in
            self.user = user
        }
    }
    
    // MARK: -Helper Functions
    
    func configureShadedView() {
        self.shadedView.frame = CGRect(x: xOrigin, y: 0, width: 80, height: self.view.frame.height)
        shadedView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        shadedView.alpha = 0
        view.addSubview(shadedView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        shadedView.addGestureRecognizer(tap)
    }
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: LoginController())
            if #available(iOS 13.0, *) {
                nav.isModalInPresentation = true
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func configure() {
        view.backgroundColor = .backgroundColor
        configureHomeController()
        fetchUserData()
    }
    
    //LoginController is position 1
    func configureHomeController(){
        // ***** fetch関連
//    func configureHomeController(withUser user: User){
        self.addChild(homeController)
        self.view.addSubview(homeController.view!)
        homeController.didMove(toParent: self)
        homeController.delegate = self
    }
    //MenuController is position 0
//    func configureMenuController(){
        // ***** fetch関連
    func configureMenuController(withUser user: User){
        menuController = MenuController(user: user)
        addChild(menuController)
        menuController.didMove(toParent: self)
        menuController.view.frame = CGRect(x: 0, y: 40, width: self.view.frame.width, height: self.view.frame.height - 40)
        view.insertSubview(menuController.view!, at: 0)
        menuController.delegate = self
        configureShadedView()
    }
    
    func animateMenu(shouldExpand: Bool, completion: ((Bool) -> Void)? = nil){
        
        if shouldExpand{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homeController.view.frame.origin.x = self.xOrigin
                self.shadedView.alpha = 1
            }, completion: nil)
        } else {
            self.shadedView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homeController.view.frame.origin.x = 0
            }, completion: completion)

        }
        
        animateStatusBar()
        
    }
    
    func animateStatusBar () {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
}

//MARK: -HomeControllerDelegate
extension ContainerController: HomeControllerDelegate{
    func handleMenuToggle() {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
    }
}

//MARK: -MenuControllerDelegate
extension ContainerController: MenuControllerDelegate {
    func didSelect(option: MenuOptions) {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded) { _ in
            switch option {
            case .yourTrips:
                break
            case .settings:
                break
            case .logout:
                let alert = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
                    self.signOut()
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
