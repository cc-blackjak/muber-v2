//
//  Trip.swift
//  muber-v2
//
//  Created by LucySD on 2021/04/22.
//

import CoreLocation

enum TripState: Int {
    case requested
    case accepted
    case inProgress
    case completed
}

struct Trip {
    var pickupCoodinates: CLLocationCoordinate2D!
    var destinationCoordinates: CLLocationCoordinate2D!
    let pickupLocationAddress: String!
    let destinationAddress: String!
    let dateAndTime: Date!
    let passengerUid: String!
    var driverUid: String?
    var state: TripState!
    var items: [[String:String]]?

    init(passengerUid: String, dictionary: [String: Any]) {
        self.passengerUid = passengerUid
        
        self.pickupLocationAddress = dictionary["pickupLocationAddress"] as? String ?? ""

        self.destinationAddress = dictionary["destinationAddress"] as? String ?? ""

        self.dateAndTime = dictionary["dateAndTime"] as? Date
        
        self.items = dictionary["items"] as? [[String:String]]

        if let pickupCoordinates = dictionary["pickupCoordinates"] as? NSArray {
            guard let lat = pickupCoordinates[0] as? CLLocationDegrees else { return }
            guard let long = pickupCoordinates[1] as? CLLocationDegrees else { return }
            self.pickupCoodinates = CLLocationCoordinate2D(latitude: lat, longitude: long)

        }

        if let destinationCoordinates = dictionary["destinationCoordinates"] as? NSArray {
            guard let lat = destinationCoordinates[0] as? CLLocationDegrees else { return }
            guard let long = destinationCoordinates[1] as? CLLocationDegrees else { return }
            self.destinationCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)

        }

        self.driverUid = dictionary["driverUid"] as? String ?? ""

        if let state = dictionary["state"] as? Int {
            self.state = TripState(rawValue: state)

        }
    }
}