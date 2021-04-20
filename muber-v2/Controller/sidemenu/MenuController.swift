//
//  MenuController.swift
//  Muber
//
//  Created by 中路亜理沙 on 16/04/2021.
//

//import Foundation

import UIKit

private let reuseIdentifier = "MenuCell"

private enum MenuOptions: Int, CaseIterable, CustomStringConvertible {
    case yourTrips
    case settings
    case logout
    
    var description: String {
        switch self {
        
        case .yourTrips:
            return "Your Trips"
        case .settings:
            return "settings"
        case .logout:
            return "logout"
        }
    }
}

class MenuController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    // MARK: - Properties
    
    private let tableView = UITableView()
    
//    private let user: User
    
    private lazy var menuHeader: MenuHeader = {
        let frame = CGRect(x: 0,
                           y: 0,
                           width: self.view.frame.width - 80,
                           height: 140)
        let view = MenuHeader(frame: frame)
//        let view = MenuHeader(user: user, frame: frame)
        return view
    }()
    
    // MARK: -Lifecycle
    
//    init(user: User){
//        self.user = user
//        super.init(nibName: nil, bundle: nil)
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        configureTableView()
    }
    
    override func  viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: -Selectors
    
    // MARK: -Helper Functions
    func configureTableView(){
        view.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableHeaderView = menuHeader
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "Menu Option"
        return cell
    }
}
