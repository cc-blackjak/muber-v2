//
//  ConfirmationPageView.swift
//  muber-v2
//
//  Created by LucySD on 2021/04/27.
//

import UIKit

class ConfirmationPageView: UIView {
    
    var trip: Trip? {
        didSet {
            address.text = trip?.destinationAddress
            date.text = trip?.date
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "Confirmation Page"
        return label
    }()
    
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "Please confirm all details before booking"
        return label
        
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "Destination Address"
        return label
    }()
    
    private let address: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "Date of Move"
        return label
    }()
    
    private let date: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("CONFIRM BOOKING", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
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
        separatorView.anchor(top: stack.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 8, height: 0.75)
        
        
        let hStack1 = UIStackView(arrangedSubviews: [addressLabel, address])
        hStack1.axis = .horizontal
        hStack1.spacing = 0
        hStack1.distribution = .fillEqually
        
        let hStack2 = UIStackView(arrangedSubviews: [dateLabel, date])
        hStack2.axis = .horizontal
        hStack2.spacing = 0
        hStack2.distribution = .fillEqually
        
        
        let stack2 = UIStackView(arrangedSubviews: [hStack1, hStack2])
        stack2.axis = .vertical
        stack2.spacing = 4
        stack2.distribution = .fillEqually
        
        addSubview(stack2)
        stack2.centerX(inView: self)
        stack2.anchor(top: separatorView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        addSubview(actionButton)
        actionButton.anchor(left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingLeft: 12, paddingBottom: 40, paddingRight: 12, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func actionButtonPressed() {
    
    }
    
}
