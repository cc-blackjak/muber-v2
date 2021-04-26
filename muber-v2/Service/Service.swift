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
    
    func uploadAddress(_ pickupCoordinates: CLLocationCoordinate2D, _ destinationCoordinates: CLLocationCoordinate2D, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let pickupArray = [pickupCoordinates.latitude, pickupCoordinates.longitude]
        let destinationArray = [destinationCoordinates.latitude, destinationCoordinates.longitude]
        
        let values = ["pickupCoordinates": pickupArray, "destinationCoordinates": destinationArray]
        
//        REF_TRIPS.child(uid).updateChildValues(values, withCompletionBlock: completion)
        print(values, uid)
    }
}

struct DriverService {
    static let shared = DriverService()
    
    // 全旅行をフェッチし、ステータスが0のものを旅行リストにいれる。処理完了後、念の為ステータスをStringで返し、テーブル表示を行う
    func observeTrips(completion: @escaping(String) -> Void) {
        print("\n\(loadedNumber). DriverService > observeTrips is loaded.")
        loadedNumber += 1
        
        REF_TRIPS.observe(.value) { (snapshot) in
            for child in snapshot.children {
                print("child: ", child)
                guard let childData = child as? DataSnapshot else { return }
                guard let dictionary = childData.value as? NSDictionary else { return }
                let puid = childData.key
                
                let trip = Trip(passengerUid: puid, dictionary: dictionary as! [String : Any])
                // ステータスが 1 = 予約済みで、MoverUIDがログイン中のMoverのものがあれば保存、表示判定に利用
                if trip.state.rawValue == 1 && trip.driverUid == loginUid! {
                    reservedTrip = trip
                }
                
                // Moverとして予約済みのものがないのであれば、ステータスが 0 = 未予約のものを全て取得
                if trip.state.rawValue == 0 && reservedTrip == nil {
                    tripsArray.append(trip)
                }
            }
            completion("Done")
            print("observeTrips in Driver service DONE.")
        }
        
    }
}
