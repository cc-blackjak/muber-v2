//
//  MenuHeader.swift
//  Muber
//
//  Created by 中路亜理沙 on 19/04/2021.
//

import UIKit

class MenuHeader: UIView{
    //MARK: -Properties
// ***fetch関連
//    private let user: User
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.text = "Arisa Nakaji"
//        label.text = user.fullname
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.text = "Arisa@test.com"
//        label.text = user.email
        return label
    }()
    
    //MARK: -Lifecycle
    override init(frame:CGRect){
        //     ***fetch関連？
//        init(user: User, frame:CGRect){
//        self.user = user
        super.init(frame: frame)

        backgroundColor = .backgroundColor
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor,
                                paddingTop:4, paddingLeft:12,
                                width: 64, height: 64)
        profileImageView.layer.cornerRadius = 64/2
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, emailLabel])
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.axis = .vertical
        addSubview(stack)
        stack.centerY(inView: profileImageView,
                      leftAnchor: profileImageView.rightAnchor,
                      paddingLeft: 12)
    }
    
    required init?(coder aDecoder:NSCoder){
        fatalError("init(coder:) has not been implementaed")
    }
    
    //MARK: -Selector
}
