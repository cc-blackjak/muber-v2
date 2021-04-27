//
//  DetailItemView.swift
//  muber-v2
//
//  Created by 中路亜理沙 on 24/04/2021.
//

import UIKit

//protocol DetailItemViewDelegate: class {
//    func presentDetailInputView()
//}

class DetailItemView: UIView, UITextFieldDelegate {
    
//    weak var delegate: DetailItemViewDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "Detail"
        return label
    }()

    private let promptLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGroupedBackground
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "Add items here"
        return label

    }()
    
    private let okButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("ok", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(okButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("delete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var detailItemTitleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Please enter item.."
        tf.backgroundColor = .systemGroupedBackground
        tf.returnKeyType = .search
        tf.font = UIFont.systemFont(ofSize: 24)
        
        let paddingView = UIView()
        paddingView.setDimentions(height: 30, width: 8)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    private lazy var detailItemInformationTextField: UITextView = {
        let tf = UITextView()
        tf.backgroundColor = .systemGroupedBackground
        tf.returnKeyType = .search
        tf.font = UIFont.systemFont(ofSize: 18)
        
        return tf
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        addShadow()

        let stack = UIStackView(arrangedSubviews: [titleLabel, promptLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually

        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: topAnchor, paddingTop: 12)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        
        addSubview(separatorView)
        separatorView.anchor(top: stack.bottomAnchor,
                             left: leftAnchor,
                             right: rightAnchor,
                             paddingTop: 8,
                             height: 0.75)
        
        addSubview(okButton)
        okButton.anchor(top: separatorView.bottomAnchor, left: leftAnchor,
                            right: rightAnchor,
                            paddingTop: 12,
                            paddingLeft: 12,
                            paddingBottom: 40,
                            paddingRight: 12,
                            height: 50)

        addSubview(deleteButton)
        deleteButton.anchor(top: okButton.bottomAnchor, left: leftAnchor,
                        right: rightAnchor,
                        paddingTop: 12,
                        paddingLeft: 12,
                        paddingBottom: 40,
                        paddingRight: 12,
                        height: 50)
        
        addSubview(detailItemTitleTextField)
        detailItemTitleTextField.anchor(top: deleteButton.bottomAnchor,
                                    left: leftAnchor,
                                    right: rightAnchor,
                                    paddingTop: 12,
                                    paddingLeft: 40,
                                    paddingRight: 40,
                                    height: 40)

        addSubview(detailItemInformationTextField)
        detailItemInformationTextField.anchor(top: detailItemTitleTextField.bottomAnchor,
                                    left: leftAnchor,
                                    right: rightAnchor,
                                    paddingTop: 12,
                                    paddingLeft: 40,
                                    paddingRight: 40,
                                    height: 400)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Selectors
    @objc func okButtonPressed() {
        print("okbutton pressed!")
        if(selectedRow == nil){
            itemsList.append(["title":detailItemTitleTextField.text!, "memo":detailItemInformationTextField.text])
        } else {
            itemsList[selectedRow!]["title"]! = detailItemTitleTextField.text!
            itemsList[selectedRow!]["memo"]! = detailItemInformationTextField.text
        }
    }
    
    @objc func deleteButtonPressed() {
        print("deletebutton pressed!")
    }
}
