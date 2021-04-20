//
//  SignUpController.swift
//  Muber
//
//  Created by LucySD on 2021/04/16.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Muber"
        label.font = UIFont(name: "Avenir-light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    private lazy var FirstNameContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: firstNameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var LastNameContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: lastNameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
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
    
    private lazy var accountTypeContainerView: UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_account_box_white_2x"), segmentedcontrol: accountTypeSegementedControl)
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    private let firstNameTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "First Name", isSecureTextEntry: false)
    }()
    
    private let lastNameTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Last Name", isSecureTextEntry: false)
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    // Creates a section with two buttons
    private let accountTypeSegementedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Rider", "Mover"])
        let normalTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]    //Text is white when it's not(normal) selected
        let selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]  //Text is black when it's selected
        sc.setTitleTextAttributes(normalTitleAttributes, for: .normal)
        sc.setTitleTextAttributes(selectedTitleAttributes, for: .selected)
        sc.backgroundColor = .backgroundColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private let signUpButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        attributedTitle.append(NSMutableAttributedString(string: "Sign Up  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.mainBlueTint]))
        
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureU()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Selectors
    
    @objc func handleSignUp() {
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName = lastNameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        let accountTypeIndex = accountTypeSegementedControl.selectedSegmentIndex;
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Failed to register user with error \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = ["firstName": firstName, "lastName": lastName, "email": email, "accountType": accountTypeIndex] as [String : Any]
            
            Database.database().reference().child("users").child(uid).updateChildValues(values) { (error, ref) in
                // Added this to fix -> "'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes"
                let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
                
                guard let controller = keyWindow?.rootViewController as? HomeController
                else { return }
                controller.configure()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func handleShowLogin() {
        // Instance
        navigationController?.popViewController(animated: true)  // This is like using segue. Pop to go back
    }
    
    // MARK: - Helper Functions
    
    func configureU() {
//        configureNavigationBar()
        
        // Sets the background color of the view
        view.backgroundColor = .backgroundColor
        
        // Adds title of the view "Muber"
        view.addSubview(titleLabel)
        // You need this to activate auto layout. Without it, no matter how much constraints you set it wont show up
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 80)
        titleLabel.centerX(inView: view)
        
        // Creates stack view with passed elements
        let stack = UIStackView(arrangedSubviews: [
                                    FirstNameContainerView,
                                    LastNameContainerView,
                                    emailContainerView,
                                    passWordContainerView,
                                    accountTypeContainerView,
                                    signUpButton])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
    
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
        
    }
}
