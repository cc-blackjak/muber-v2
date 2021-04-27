//
//  Items.swift
//  muber-v2
//
//  Created by 中路亜理沙 on 23/04/2021.
//

import UIKit

protocol ItemsViewDelegate: AnyObject {
    func proceedToDetailItemView(_ view: ItemsView)
}

//var itemsList: [String] = ["jun", "bilaal","kakeru", "arisa"]
var itemsList: [[String : String]] = []

var selectedRow: Int? = nil

class ItemsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    weak var delegate: ItemsViewDelegate?

    
    var tableView = UITableView()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("countaaaa: ", itemsList.count)
        return itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = itemsList[indexPath.row]["title"]
        print("title: ", cell)
        return cell
    }
    
    
    // 選択したアイテムの行番号を取得
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemsList[indexPath.row]
        print("item: ", item)
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "Items"
        return label
    }()

    private let promptLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "Add items here"
        return label

    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // to comfirm
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("confirm", for: .normal)
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
        separatorView.anchor(top: stack.bottomAnchor,
                             left: leftAnchor,
                             right: rightAnchor,
                             paddingTop: 8,
                             height: 0.75)
        
        addSubview(addButton)
        addButton.anchor(top: separatorView.bottomAnchor,
                         left: leftAnchor,
                         right: rightAnchor,
                         paddingTop: 12,
                         paddingLeft: 12,
                         paddingBottom: 40,
                         paddingRight: 12,
                         height: 30)
        
        // itemsのTableViewの設定
        setup()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // to comfirm
        addSubview(actionButton)
        actionButton.anchor(left: leftAnchor,
                            bottom: safeAreaLayoutGuide.bottomAnchor,
                            right: rightAnchor,
                            paddingTop: 12,
                            paddingLeft: 12,
                            paddingBottom: 40,
                            paddingRight: 12,
                            height: 50)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func updateConstraints() {
//        print("updateConstraints is called")
//        super.updateConstraints()
//    }
    
    func setup() {
        tableView = UITableView(frame: CGRect(x: 0, y: 120, width: 450, height: 800))
        tableView.layer.backgroundColor = UIColor.black.cgColor
        addSubview(tableView)
      }
    
    // MARK: - Selectors
    
    @objc func addButtonPressed() {
        selectedRow = nil
        delegate?.proceedToDetailItemView(self)
//        tableView.reloadData() // Addボタン時、リロードは不要
        print("addbutton pressed")

    }
    
    @objc func actionButtonPressed() {
        print("button pressed to comfirm!")
    }
}
