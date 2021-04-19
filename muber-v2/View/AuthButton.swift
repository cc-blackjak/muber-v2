//
//  AuthButton.swift
//  Muber
//
//  Created by LucySD on 2021/04/16.
//

import UIKit

class AuthButton: UIButton {

    // Making reusable button
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        backgroundColor = .mainBlueTint
        setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        heightAnchor.constraint(equalToConstant: 50).isActive = true 
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
