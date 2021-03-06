//
//  Service.swift
//  muber-v2
//
//  Created by LucySD on 2021/04/20.
//

import Firebase
import FirebaseAuth
import CoreLocation

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_TRIPS = DB_REF.child("trips")

var loginUid : String? = nil

struct Service {
    
    static let shared = Service()
    
    func fetchUserData(uid: String, completion: @escaping(User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            loginUid = user.uid
            completion(user)
        }
    }
    
    func fetchUserTripData(uid: String, completion: @escaping(Trip) -> Void) {
        REF_TRIPS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let trips = Trip(passengerUid: uid, dictionary: dictionary)
            completion(trips)
        }
    }
    
    func uploadDestinationAddressAndName(destinationAddress: String, destinationName: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [
            "destinationName": destinationName,
            "destinationAddress": destinationAddress,
            "state": TripState.requesting.rawValue
        ] as [String : Any]
        
        REF_TRIPS.child(uid).updateChildValues(values, withCompletionBlock: completion)
        print(values, uid)
    }
    
    func uploadCoordinates(_ pickupCoordinates: CLLocationCoordinate2D, _ destinationCoordinates: CLLocationCoordinate2D, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let pickupArray = [pickupCoordinates.latitude, pickupCoordinates.longitude]
        let destinationArray = [destinationCoordinates.latitude, destinationCoordinates.longitude]
        
        let values = [
            "pickupCoordinates": pickupArray,
            "destinationCoordinates": destinationArray,
            "state": TripState.requesting.rawValue
        ] as [String : Any]
        
        REF_TRIPS.child(uid).updateChildValues(values, withCompletionBlock: completion)
        print(values, uid)
    }
    
    func uploadDate(date: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let value = [
            "date": date,
            "state": TripState.requesting.rawValue
        ] as [String : Any]
        
        REF_TRIPS.child(uid).updateChildValues(value, withCompletionBlock: completion)
        print(value, uid)
    }
    
    func uploadItemList(items: [[String:String]], completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [
            "items": items,
            "state": TripState.requesting.rawValue
        ] as [String : Any]
        
        REF_TRIPS.child(uid).updateChildValues(values, withCompletionBlock: completion)
        print(values, uid)
    }
    
    func uploadTripState(state: Int,completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["state": state]
        
        REF_TRIPS.child(uid).updateChildValues(values, withCompletionBlock: completion)
        print(values, uid)
    }
    
    func observeCurrentTrip(completion: @escaping(Trip) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_TRIPS.child(uid).observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let trips = Trip(passengerUid: uid, dictionary: dictionary)
            completion(trips)
        }

    }
}

struct DriverService {
    static let shared = DriverService()
    
    // ????????????????????????????????????????????????0???????????????????????????????????????????????????????????????????????????????????????String???????????????????????????????????????
    func observeTrips(completion: @escaping(String) -> Void) {
        print("\n\(loadedNumber). DriverService > observeTrips is loaded.")
        loadedNumber += 1
        
        REF_TRIPS.observe(.value) { (snapshot) in
            var tmpAry : [Trip] = []
            for child in snapshot.children {
                print("child: ", child)
                guard let childData = child as? DataSnapshot else { return }
                guard let dictionary = childData.value as? NSDictionary else { return }
                let puid = childData.key
                
                let trip = Trip(passengerUid: puid, dictionary: dictionary as! [String : Any])
                // ?????????????????? 1 = ??????????????????MoverUID?????????????????????Mover???????????????????????????????????????????????????
                if trip.state.rawValue == 2 && trip.driverUid == loginUid! {
                    reservedTrip = trip
                }
                
                // Mover??????????????????????????????????????????????????????????????????????????? 0 = ?????????????????????????????????
                
                if trip.state.rawValue == 1 && reservedTrip == nil {
                    tmpAry.append(trip)
                }
            }
            tripsArray = tmpAry
            completion("Done")
            print("observeTrips in Driver service DONE.")
        }
        
    }
}
