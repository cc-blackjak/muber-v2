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
    private var menuController: MenuController!
    private var isExpanded = false
    private let blackView = UIView()
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
        
        print("\n\(loadedNumber). ContainerController > viewDidLoad is loaded.")
        loadedNumber += 1
        
        checkIfUserIsLoggedIn()
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    // MARK: - Selectors
    
    @objc func dismissMenu() {
        isExpanded = false
        animateMenu(shouldExpand: isExpanded)
    }
    
    // MARK: -API
    
    func checkIfUserIsLoggedIn() {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > checkIfUserIsLoggedIn is loaded.")
        loadedNumber += 1
        
        if Auth.auth().currentUser?.uid == nil {
            presentLoginController()
        } else {
            configure()
        }
    }
    
    func fetchUserData() {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > enableLocationservices is loaded.")
        loadedNumber += 1
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Service.shared.fetchUserData(uid: currentUid) { user in
            self.user = user
        }
    }
    
    func signOut() {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > signOut is loaded.")
        loadedNumber += 1
        
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            print("DEBUG: Error signing out")
        }
    }
    
    // MARK: -Helper Functions
    
    func presentLoginController() {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > presentLoginController is loaded.")
        loadedNumber += 1
        
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
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configure is loaded.")
        loadedNumber += 1
        
        view.backgroundColor = .backgroundColor
        configureHomeController()
        fetchUserData()
    }
    
    // LoginController is position 1
//    func configureHomeController(withUser user: User){
    func configureHomeController(){
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configure*Home*Controller is loaded.")
        loadedNumber += 1
        
        // ***** fetch関連
        // ホームコントロールを追加する
        self.addChild(homeController)
        self.view.addSubview(homeController.view!)
        homeController.didMove(toParent: self)
        homeController.delegate = self
    }
    
    //MenuController is position 0
        // ***** fetch関連
//    func configureMenuController(){
    func configureMenuController(withUser user: User){
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configure*Menu*Controller is loaded.")
        loadedNumber += 1
        
        menuController = MenuController(user: user)
        addChild(menuController)
        menuController.didMove(toParent: self)
        menuController.view.frame = CGRect(x: 0, y: 40, width: self.view.frame.width, height: self.view.frame.height - 40)
        view.insertSubview(menuController.view!, at: 0)
        menuController.delegate = self
        configureBlackView()
    }
    
    func configureBlackView() {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > configureBlackView is loaded.")
        loadedNumber += 1
        
        self.blackView.frame = CGRect(x: xOrigin, y: 0, width: 80, height: self.view.frame.height)
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.alpha = 0
        view.addSubview(blackView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        blackView.addGestureRecognizer(tap)
    }
    
    func animateMenu(shouldExpand: Bool, completion: ((Bool) -> Void)? = nil){
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > animateMenu is loaded.")
        loadedNumber += 1
        
        if shouldExpand {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homeController.view.frame.origin.x = self.xOrigin
                self.blackView.alpha = 1
            }, completion: nil)
        } else {
            self.blackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homeController.view.frame.origin.x = 0
            }, completion: completion)

        }
        
        animateStatusBar()
        
    }
    
    func animateStatusBar () {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > animateStatusBar is loaded.")
        loadedNumber += 1
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
}

//MARK: -HomeControllerDelegate

extension ContainerController: HomeControllerDelegate{
    func handleMenuToggle() {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > extension handleMenuToggle is loaded.")
        loadedNumber += 1
        
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
    }
}

//MARK: -MenuControllerDelegate

extension ContainerController: MenuControllerDelegate {
    func didSelect(option: MenuOptions) {
        print("\n\(loadedNumber). \(String(describing: type(of: self))) > extension didSelect is loaded.")
        loadedNumber += 1
        
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
