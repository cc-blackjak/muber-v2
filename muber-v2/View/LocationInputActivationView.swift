//
//  LocationInputActivationView.swift
//  muber-v2
//
//  Created by 田中翔 on 2021/04/19.
//

import UIKit

protocol LocatationInputActivationViewDelegate: class {
    func presentLocationInputView()
}

class LocatationInputActivationView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: LocatationInputActivationViewDelegate?
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Where to?"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addShadow()
        
        addSubview(indicatorView)
        indicatorView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16)
        indicatorView.setDimentions(height: 6, width: 6)
        
        addSubview(placeholderLabel)
        placeholderLabel.centerY(inView: self, leftAnchor: indicatorView.rightAnchor, paddingLeft: 20)
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentLocationInputView))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func presentLocationInputView(){
        delegate?.presentLocationInputView()
    }
}