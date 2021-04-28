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

protocol ItemsViewDelegate2: AnyObject {
    func proceedToConfirmationPageView(_ view: ItemsView)
}

//var itemsList: [String] = ["jun", "bilaal","kakeru", "arisa"]
var itemsList: [[String : String]] = []

var selectedItemRow: Int? = nil

class ItemsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    weak var delegate: ItemsViewDelegate?
    weak var delegate2: ItemsViewDelegate2?

    
    var tableView = UITableView()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: ", itemsList.count)
        return itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(itemsList[indexPath.row]["title"] ?? "nil")"
        print("title: ", itemsList[indexPath.row]["title"] ?? "nil")
        return cell
    }
    
    
    // 選択したアイテムの行番号を取得
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = itemsList[indexPath.row]
        selectedItemRow = indexPath.row
        print("selectedRow: ", selectedItemRow!)
        delegate?.proceedToDetailItemView(self)
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
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // to comfirm
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("PROCEED TO CONFIRMATION", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
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
        actionButton.anchor(left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingLeft: 12, paddingBottom: 12, paddingRight: 12, height: 50)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setup() {
        tableView = UITableView(frame: CGRect(x: 0, y: 120, width: 450, height: 800))
        tableView.layer.backgroundColor = UIColor.black.cgColor
        addSubview(tableView)
      }
    
    // MARK: - Selectors
    
    @objc func addButtonPressed() {
        print("addbutton pressed")
        delegate?.proceedToDetailItemView(self)
        selectedItemRow = nil
    }
    
    @objc func confirmButtonPressed() {
        Service.shared.uploadItemList(items: itemsList) { (error, ref) in
            if let error = error {
                print("DEBUG: Failed to upload items with error \(error)")
                return
            }
            print("DEBUG: Did upload items successfully")
        }
        
        print("confirm button pressed")
        delegate2?.proceedToConfirmationPageView(self)
    }
}
