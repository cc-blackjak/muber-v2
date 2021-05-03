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

class MoverConfirmView: UIView, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    
    weak var delegate: MoverConfirmViewDelegate?
    
    var tableView = UITableView()
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your list of items"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedTripRow != nil {
            print("count in confirmList: ", tripsArray[selectedTripRow!].items?.count ?? 0)
            return tripsArray[selectedTripRow!].items!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        
        if selectedTripRow != nil {
            cell.textLabel?.text = "\(tripsArray[selectedTripRow!].items![indexPath.row]["title"] ?? "nil")"
            cell.detailTextLabel?.text = "\(tripsArray[selectedTripRow!].items![indexPath.row]["memo"] ?? "nil")"
            cell.detailTextLabel?.numberOfLines = 0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func configureTable() {
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.layer.backgroundColor = UIColor.black.cgColor
        addSubview(tableView)
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
    
    private let addressNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "Destination Name"
        return label
    }()
    
    let destNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Tmp destNameLabel"
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "Destination Address"
        return label
    }()
    
    let destAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Tmp destAddressLabel"
        return label
    }()
    
    private let dateTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "Date of Move"
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Tmp dateLabel"
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
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, promptLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: topAnchor, paddingTop:  12)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, height: 0.75)
        
        let hStack0 = UIStackView(arrangedSubviews: [addressNameLabel, destNameLabel])
        hStack0.axis = .horizontal
        hStack0.spacing = 0
        hStack0.distribution = .fillEqually
        
        let hStack1 = UIStackView(arrangedSubviews: [addressLabel, destAddressLabel])
        hStack1.axis = .horizontal
        hStack1.spacing = 0
        hStack1.distribution = .fillEqually
        
        let hStack2 = UIStackView(arrangedSubviews: [dateTitleLabel, dateLabel])
        hStack2.axis = .horizontal
        hStack2.spacing = 0
        hStack2.distribution = .fillEqually
        
        let stack2 = UIStackView(arrangedSubviews: [hStack0, hStack1, hStack2])
        stack2.axis = .vertical
        stack2.spacing = 6
        stack2.distribution = .fillEqually
        addSubview(stack2)
        stack2.centerX(inView: self)
        stack2.anchor(top: separatorView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        configureTable()
        tableView.anchor(top: stack2.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingBottom: 12)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let buttonStack = UIStackView(arrangedSubviews: [actionButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 4
        buttonStack.distribution = .fillEqually
        
        addSubview(buttonStack)
        buttonStack.anchor(top: tableView.bottomAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 12, paddingRight: 12, height: 50)
        
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
