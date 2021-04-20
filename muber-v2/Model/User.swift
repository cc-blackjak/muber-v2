//
//  User.swift
//  muber-v2
//
//  Created by LucySD on 2021/04/20.
//

struct User {
    let firstName: String
    let lastName: String
    let email: String
    let accountType: Int
    
    init(dictionary: [String: Any]) {
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.accountType = dictionary["accountType"] as? Int ?? 0
    }
}
