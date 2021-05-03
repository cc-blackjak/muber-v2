//
//  MoverWaitingView.swift
//  muber-v2
//
//  Created by Jun Gao on 2021/04/27.
//

import UIKit
import MapKit

class MoverWaitingView: UIView, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    
    var tableView = UITableView()
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your list of items"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reservedTrip != nil {
            print("count in confirmList: ", reservedTrip?.items?.count ?? 0)
            return reservedTrip?.items?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        if reservedTrip != nil {
            cell.textLabel?.text = "\(reservedTrip?.items![indexPath.row]["title"] ?? "nil")"
            cell.detailTextLabel?.text = "\(reservedTrip?.items![indexPath.row]["memo"] ?? "nil")"
            cell.detailTextLabel?.numberOfLines = 0
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = itemsList[indexPath.row]
//        selectedItemRow = indexPath.row
//        print("selectedRow: ", selectedItemRow!)
    }
    
    func configureTable() {
        
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
//        tableView.frame = CGRect(x: 0, y: 200, width: 450, height: 200)
        tableView.layer.backgroundColor = UIColor.black.cgColor
        addSubview(tableView)
    }
    
    
    
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
        label.text = "Reserved Moving details"
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
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Tmp destAddressLabel"
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "TmpRiderDate"
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let itemsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "TmpRiderItems"
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addShadow()
        
//        let scroll = UIScrollView()
//        scroll.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
//        addSubview(scroll)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: topAnchor, paddingTop: 6)
//        stack.anchor(top: scroll.topAnchor,
//                     left: scroll.leftAnchor,
//                     bottom: scroll.bottomAnchor,
//                     right: scroll.rightAnchor)
        
        addSubview(muberLabel)
        muberLabel.anchor(top: stack.bottomAnchor)
        muberLabel.centerX(inView: self)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.anchor(top: muberLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, height: 0.75)
        
        addSubview(destNameLabel)
        destNameLabel.anchor(top: muberLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        
        addSubview(destAddressLabel)
        destAddressLabel.anchor(top: destNameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 20, paddingRight: 20)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: destAddressLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)

//        addSubview(itemsLabel)
//        itemsLabel.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        
        configureTable()
        tableView.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20, paddingBottom: 12)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.separatorStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
}
