//
//  CalendarAndListView.swift
//  muber-v2
//
//  Created by LucySD on 2021/04/22.
//

import UIKit

class CalendarAndListView: UIView {

    // MARK: - Properties
    
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "Calendar"
        return label
    }()
    
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "Choose a date and time for your move"
        return label
        
    }()
    
    private let calendar: UIDatePicker = {
        let calendar1 = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        calendar1.preferredDatePickerStyle = .compact
        return calendar1
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

 
    // MARK: - Lifecycle
    
    
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
        
        addSubview(calendar)
        calendar.anchor(top: stack.bottomAnchor, paddingTop: 8)
        calendar.centerX(inView: self)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.anchor(top: calendar.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, height: 0.75)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func actionButtonPressed() {
        
    }
}


