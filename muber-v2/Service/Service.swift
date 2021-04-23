//
//  Service.swift
//  muber-v2
//
//  Created by LucySD on 2021/04/20.
//

import Firebase
import CoreLocation

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_TRIPS = DB_REF.child("trips")

struct Service {
    
    static let shared = Service()
    
    func fetchUserData(uid: String, completion: @escaping(User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func uploadAddress(_ pickupCoordinates: CLLocationCoordinate2D, _ destinationCoordinates: CLLocationCoordinate2D, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let pickupArray = [pickupCoordinates.latitude, pickupCoordinates.longitude]
        let destinationArray = [destinationCoordinates.latitude, destinationCoordinates.longitude]
        
        let values = ["pickupCoordinates": pickupArray, "destinationCoordinates": destinationArray]
        
//        REF_TRIPS.child(uid).updateChildValues(values, withCompletionBlock: completion)
        print(values, uid)
    }
}
