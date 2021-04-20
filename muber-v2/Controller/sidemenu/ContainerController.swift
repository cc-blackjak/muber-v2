//
//  containerController.swift
//  Muber
//
//  Created by 中路亜理沙 on 16/04/2021.
//

//import Foundation

import UIKit

class ContainerController: UIViewController{
    // MARK: - Properties
    
    private let homeController = HomeController()
    private let menuController = MenuController()
    private var isExpanded = false
    
//    private var user: User?{
//        didSet{
//
//        }
//    }
    // MARK: -Lifecycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        configureHomeController()
        configureMenuController()
    }
    
    // MARK: -Selectors
    
    // MARK: -API
    
//    func fetchUserData(){
//        guard let current Uid = Auth.auth().currentUser?.uid else { return }
//        Service.shared.fetchUserData(uid: currentUid) {use in
//            self.user = user
//        }
//    }
    
    // MARK: -Helper Functions
    
    //LoginController is position 1
    func configureHomeController(){
        self.addChild(homeController)
        self.view.addSubview(homeController.view!)
        homeController.didMove(toParent: self)
        homeController.delegate = self
    }
    //MenuController is position 0
    func configureMenuController(){
        self.addChild(menuController)
        self.view.insertSubview(menuController.view!, at: 0)
        menuController.didMove(toParent: self)
        print("menucontroller")
    }
    
    func animateMenu(shouldExpand: Bool){
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
extension ContainerController: HomeControllerDelegate{
    func handleMenuToggle() {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
    }
}
