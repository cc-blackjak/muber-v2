//
//  MenuHeader.swift
//  Muber
//
//  Created by 中路亜理沙 on 19/04/2021.
//

import UIKit

class MenuHeader: UIView{
    //MARK: -Properties
    // *****homeControllerでUSER取得したら動くようになる
//    var user: User?{
//        didSet {
//            fullnameLabel.text = user?.fullname
//            emailLabel.text = user?.email
//        }
//    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.text = "Arisa Nakaji"
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.text = "Arisa@test.com"
        return label
    }()
    
    //MARK: -Lifecycle
    
    override init(frame:CGRect){
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
        // ****centerYの当て方がわからない。Extensinosに入ってない？でも、完成からコピってきても
        // error消えなかった。。。
//        stack.centerY(inView: profileImageView,
//                      leftAnchor: profileImageView.rightAnchor,
//                      paddingLeft: 12)
        // ****とりあえずの代替案　微妙にしか出てないwwww
        stack.anchor(top: profileImageView.bottomAnchor, left: profileImageView.leftAnchor,
                     right: profileImageView.rightAnchor)
    }
    
    required init?(coder aDecoder:NSCoder){
        fatalError("init(coder:) has not been implementaed")
    }
    
    //MARK: -Selector
}
