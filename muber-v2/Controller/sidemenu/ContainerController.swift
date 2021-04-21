//
//  containerController.swift
//  Muber
//
//  Created by 中路亜理沙 on 16/04/2021.
//

//import Foundation

import UIKit
import Firebase

class ContainerController: UIViewController{
    // MARK: - Properties
    
    private let homeController = HomeController()
    private let menuController = MenuController()
    private var isExpanded = false
    
    // ***fetch関連
//    private var user: User?{
//        didSet{
//          guard let user = user else { return }
//            homeController.user = user
//            configureMenuController(withUser: user)

//        }
//    }
    
    // MARK: -Lifecycle
    
    // ***fetch関連
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        // ***** fetch関連
//        fetchUserData()
        configureHomeController()
        // ↓↓↓↓↓ fetch 繋がったら消す？
        configureMenuController()
        // ↑↑↑↑↑↑ fetch 繋がったら消す？
        
    }
    
    // MARK: -Selectors
    
    // MARK: -API
    // ***** fetch関連
//    func fetchUserData(){
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//        Service.shared.fetchUserData(uid: currentUid) { user in
//            self.user = user
//        }
//    }
    
    func signOut() {
        print("logOut")
//        do {
//            try Auth.auth().signOut()
//        } catch {
//            print("DEBUG: Error signing out")
        }
    
    // MARK: -Helper Functions
    
    func configure() {
        view.backgroundColor = .backgroundColor
//        configureHomeController()
//        fetchUserData()
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
    func configureMenuController(){
        // ***** fetch関連
//    func configureMenuController(withUser user: User){
//        menuController = MenuController(coder: user)
        addChild(menuController)
        menuController.didMove(toParent: self)
        view.insertSubview(menuController.view!, at: 0)
    }
    
    func animateMenu(shouldExpand: Bool, completion:((Bool) -> Void)? = nil){
        if shouldExpand{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homeController.view.frame.origin.x = self.view.frame.width - 80
            }, completion: nil)
        }else{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homeController.view.frame.origin.x = 0
            }, completion: nil)

        }
        
    }
}

// MARK: -HomeControllerDelegate

extension ContainerController: HomeControllerDelegate{
    func handleMenuToggle() {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
    }
}

extension ContainerController: MenuControllerDelegate {
    func didSelect() {
//    func didSelect(option: MenuOptions) {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded){ _ in
//            switch option {
//            case .yourTrips:
//                break
//            case .settings:
//                break
//            case .logout:
//                print("logout")
//                let alert = UIAlertController(title: nil,
//                                              message: "Are you sure you want to log out?",
//                                              preferredStyle: .actionSheet)
//
//                alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
//                    self.signOut()
//                }))
//
//                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//                self.present(alert, animated:true, completion: nil)
//            }
        }
            
    }
}
