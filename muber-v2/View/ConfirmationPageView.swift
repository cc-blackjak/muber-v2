//
//  ConfirmationPageView.swift
//  muber-v2
//
//  Created by LucySD on 2021/04/27.
//

import UIKit

class ConfirmationPageView: UIView, UITableViewDelegate, UITableViewDataSource {
    var trip: Trip? {
        didSet {
            address.text = trip?.destinationAddress
            date.text = trip?.date
        }
    }
    
    
    var tableView = UITableView()
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your list of items"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count in confirmList: ", itemsList.count)
        return itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(itemsList[indexPath.row]["title"] ?? "nil")"
        print("title: ", itemsList[indexPath.row]["title"] ?? "nil")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = itemsList[indexPath.row]
        selectedItemRow = indexPath.row
        print("selectedRow: ", selectedItemRow!)
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
        label.numberOfLines = 0
        return label
    }()
    
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("CONFIRM BOOKING", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(confirmBookingPressed), for: .touchUpInside)
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
        stack2.spacing = 6
        stack2.distribution = .fillEqually
        
        addSubview(stack2)
        stack2.centerX(inView: self)
        stack2.anchor(top: separatorView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        let separatorView2 = UIView()
        separatorView2.backgroundColor = .lightGray
        addSubview(separatorView2)
        separatorView2.anchor(top: stack2.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 12, height: 0.75)
        
        configureTable()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        
        addSubview(actionButton)
        actionButton.anchor(left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingLeft: 12, paddingBottom: 40, paddingRight: 12, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    func configureTable() {
        
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView = UITableView(frame: CGRect(x: 0, y: 200, width: 450, height: 400))
        tableView.layer.backgroundColor = UIColor.black.cgColor
        addSubview(tableView)
      }
    
    // MARK: - Selectors
    
    @objc func confirmBookingPressed() {
        
    }
    
}
