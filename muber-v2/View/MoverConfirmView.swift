//
//  MoverRiderView.swift
//  muber-v2
//
//  Created by Jun Gao on 2021/04/27.
//

import UIKit
import MapKit

protocol MoverConfirmViewDelegate: class {
    func proceedToConfirmAndUpload(_ view: MoverConfirmView)
}

class MoverConfirmView: UIView {

    // MARK: - Properties
    
    weak var delegate: MoverConfirmViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
        
    }()
    
    let muberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Moving details"
        label.textAlignment = .center
        return label
    }()
    
    let destNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Tmp destNameLabel"
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let destAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Tmp destAddressLabel"
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "TmpRiderName"
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let itemsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "TmpRiderName"
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Confirm the moving", for: .normal)
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
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: topAnchor, paddingTop:  32)
        
        addSubview(muberLabel)
        muberLabel.anchor(top: stack.bottomAnchor, paddingTop: 8)
        muberLabel.centerX(inView: self)
        
        addSubview(destNameLabel)
        destNameLabel.anchor(top: muberLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        
        addSubview(destAddressLabel)
        destAddressLabel.anchor(top: destNameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: destAddressLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        
        addSubview(itemsLabel)
        itemsLabel.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.anchor(top: muberLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, height: 0.75)
        
        addSubview(actionButton)
        actionButton.anchor(left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingLeft: 12, paddingBottom: 12, paddingRight: 12, height: 50)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func actionButtonPressed() {
        delegate?.proceedToConfirmAndUpload(self)
    }
}


var tmpItems : [[String : String]] = [
    ["title" : "冷蔵庫",
     "memo" : "とても重い",
    ],
    ["title" : "ダンボール",
     "memo" : "中くらいのが8箱",
    ],
    ["title" : "文庫本",
     "memo" : """
とても長い長い説明が続く。
吾輩わがはいは猫である。名前はまだ無い。
　どこで生れたかとんと見当けんとうがつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪どうあくな種族であったそうだ。
""",
    ],
    ["title" : "テレビ",
     "memo" : "そこそこ",
    ],
]
