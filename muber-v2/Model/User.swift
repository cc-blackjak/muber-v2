//
//  User.swift
//  muber-v2
//
//  Created by LucySD on 2021/04/20.
//

import CoreLocation

enum AccountType: Int {
    case passenger // 0
    case driver // 1
}

struct User {
    let firstName: String
    let lastName: String
    let email: String
    var accountType: AccountType!
    var location: CLLocation?
    let uid: String
    
    var firstInitial: String { return String(firstName.prefix(1))}
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        
        if let index = dictionary["accountType"] as? Int {
            self.accountType = AccountType(rawValue: index)
        }
    }
}
