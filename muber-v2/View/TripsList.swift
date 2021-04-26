//
//  TripsList.swift
//  muber-v2
//
//  Created by Jun Gao on 2021/04/26.
//

var tmpTrips = ["Trip1", "Trip2", "Trip3"]

import UIKit

//protocol TripsListControllerDelegate: class {
//    func didSelect(option: "selected")
//}

class TripsListController: UITableViewController {
    
    // MARK: - Properties
    
//    private let user: User
//    weak var delegate: TripsListControllerDelegate?
    
//    private lazy var menuHeader: MenuHeader = {
//        let frame = CGRect(x: 0,
//                           y: 0,
//                           width: self.view.frame.width,
//                           height: 140)
//        let view = MenuHeader(user: user, frame: frame)
//        return view
//    }()
    
    // MARK: - Lifecycle
    
//    init(user: User) {
//        super.init(nibName: nil, bundle: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TripsMenuCell")
    }
}

// MARK: - UITableViewDelegate/DataSource

extension TripsListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmpTrips.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripsMenuCell", for: indexPath)
        
//        guard let option = MenuOptions(rawValue: indexPath.row) else { return UITableViewCell() }
        cell.textLabel?.text = tmpTrips[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let option = MenuOptions(rawValue: indexPath.row) else { return }
//        delegate?.didSelect(option: option)
    }
}