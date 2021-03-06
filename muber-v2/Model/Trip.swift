//
//  Trip.swift
//  muber-v2
//
//  Created by LucySD on 2021/04/22.
//

import CoreLocation


enum TripState: Int {
    case requesting //0
    case requested // 1
    case accepted // 2
    case inProgress // 3
    case completed // 4
}

struct Trip {
    var pickupCoodinates: CLLocationCoordinate2D!
    var destinationCoordinates: CLLocationCoordinate2D!
    let pickupLocationAddress: String!
    let destinationAddress: String!
    let destinationName: String!
    let date: String!
    let passengerUid: String!
    var driverUid: String?
    var state: TripState!
    var items: [[String:String]]?

    init(passengerUid: String, dictionary: [String: Any]) {
        self.passengerUid = passengerUid
        self.driverUid = dictionary["driverUid"] as? String ?? ""
        
        self.items = dictionary["items"] as? [[String:String]] ?? []
            
        self.pickupLocationAddress = dictionary["pickupLocationAddress"] as? String ?? ""

        self.destinationAddress = dictionary["destinationAddress"] as? String ?? ""
        
        self.destinationName = dictionary["destinationName"] as? String ?? ""

        self.date = dictionary["date"] as? String
        
        self.items = dictionary["items"] as? [[String:String]] ?? tmpItems
        
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

        if dictionary["state"] == nil {
            self.state = .requested
        } else {
            let tmp = dictionary["state"] as? Int
            self.state = TripState(rawValue: tmp!)
        }
    }
}
