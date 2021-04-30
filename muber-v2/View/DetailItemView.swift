//
//  DetailItemView.swift
//  muber-v2
//
//  Created by 中路亜理沙 on 24/04/2021.
//

import UIKit

protocol DetailItemViewDelegate: AnyObject {
    func returnToItemsView(_ view: DetailItemView)
}

//protocol DetailItemViewDelegate2: AnyObject {
//    func refreshItemList(_ view: DetailItemView)
//}

class DetailItemView: UIView, UITextFieldDelegate {
    
    weak var delegate: DetailItemViewDelegate?
//    weak var delegate2: DetailItemViewDelegate2?

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
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(okButtonPressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(UIView.endEditing), for: .touchUpInside)
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("delete or back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(UIView.endEditing), for: .touchUpInside)
        return button
    }()
    
    lazy var detailItemTitleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Please enter item.."
        tf.backgroundColor = .systemGroupedBackground
        tf.returnKeyType = .search
        tf.font = UIFont.systemFont(ofSize: 24)
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    lazy var detailItemInformationTextField: UITextView = {
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
                                    paddingLeft: 12,
                                    paddingRight: 12,
                                    height: 50)

        addSubview(detailItemInformationTextField)
        detailItemInformationTextField.anchor(top: detailItemTitleTextField.bottomAnchor,
                                    left: leftAnchor,
                                    right: rightAnchor,
                                    paddingTop: 12,
                                    paddingLeft: 12,
                                    paddingRight: 12,
                                    height: 500)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //もしtitleに入力がなかったらエラー発火
    func alert(){
        let alertController = UIAlertController(title: "please enter a item.",
                                              message: "and enter details of a item.",
                                              preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

    
    // MARK: - Selectors
    @objc func okButtonPressed() {
        print("DetailItemView > Selectors > okButtonPressed")
        if (detailItemTitleTextField.text == ""){
            alert()
        }else{
            if(selectedItemRow == nil){
                itemsList.append(["title":detailItemTitleTextField.text!, "memo":detailItemInformationTextField.text])
            } else {
                itemsList[selectedItemRow!]["title"] = detailItemTitleTextField.text
                itemsList[selectedItemRow!]["memo"] = detailItemInformationTextField.text
            }
            
            detailItemTitleTextField.text = ""
            detailItemInformationTextField.text = ""
            
            selectedItemRow = nil
            
            print("itemsList: ", itemsList)
            delegate?.returnToItemsView(self)
        }
    }
    
    @objc func deleteButtonPressed() {
        print("deletebutton pressed!")
        if selectedItemRow != nil {
            itemsList.remove(at: (selectedItemRow!))
        }
        
        detailItemTitleTextField.text = ""
        detailItemInformationTextField.text = ""
        
        selectedItemRow = nil
        delegate?.returnToItemsView(self)
    }
}
