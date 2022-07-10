//
//  Udacity User Data.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 04/02/2021.
//

import Foundation

struct UdacityUserData: Codable {
    let firstName: String
    let lastName: String
    let bio: String?
    let key: String
    let email: UdacityEmail
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
        case key = "key"
        case email = "email"
    }
}

struct UdacityEmail: Codable {
    let address: String
}
