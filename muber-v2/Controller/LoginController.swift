//
//  LoginController.swift
//  Muber
//
//  Created by LucySD on 2021/04/15.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    // MARK: - Properties
    
    // This is how to add labels programmatically
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Muber"
        label.font = UIFont(name: "Avenir-light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passWordContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    private let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)

        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        attributedTitle.append(NSMutableAttributedString(string: "Sign Up  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.mainBlueTint]))
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Selectors
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Failed to log user in with error \(error.localizedDescription)")
                return
            }
            
            // Added this to fix -> "'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes"
            let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
            
            guard let controller = keyWindow?.rootViewController as? ContainerController
            else { return }
            controller.configure()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleShowSignUp() {
        // Instance
        let controller = SignUpController()
        navigationController?.pushViewController(controller, animated: true)  // This is like using segue. Push to go forward
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        configureNavigationBar()
        
        // Sets the background color of the view
        view.backgroundColor = .backgroundColor
        
        // Adds title of the view "Muber"
        view.addSubview(titleLabel)
        // You need this to activate auto layout. Without it, no matter how much constraints you set it wont show up
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 80)
        titleLabel.centerX(inView: view)
        
        // Creates stack view with passed elements
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passWordContainerView, loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
    
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
        
    }

    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black  // Makes the content in the nav bar light
    }

}

 
