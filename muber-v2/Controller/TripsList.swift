//
//  TripsList.swift
//  muber-v2
//
//  Created by Jun Gao on 2021/04/26.
//

var tripsArray : [Trip] = []
var selectedTripRow : Int? = nil
var reservedTrip : Trip? = nil

import UIKit

protocol TripsListControllerDelegate: AnyObject {
    func tripSelected(selectedRow: Int)
}

class TripsListController: UITableViewController {
    
    // MARK: - Properties
    
    weak var delegate: TripsListControllerDelegate?
    
    // MARK: - Lifecycle
    
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
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Waiting trips list"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TripsMenuCell", for: indexPath)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
//        guard let option = MenuOptions(rawValue: indexPath.row) else { return UITableViewCell() }
//        cell.textLabel?.text = tmpTrips[indexPath.row]
        
        cell.textLabel?.text = "\(tripsArray[indexPath.row].destinationName!)"
        cell.detailTextLabel?.text = "\(tripsArray[indexPath.row].destinationAddress!)"
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected indexPath.row is: ",indexPath.row)
//        print("Selected value is: ",tmpTrips[indexPath.row])
//        guard let option = MenuOptions(rawValue: indexPath.row) else { return }
        selectedTripRow = indexPath.row
        delegate?.tripSelected(selectedRow: indexPath.row)
    }
}
