//
//  Udacity Login Response.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 03/02/2021.
//

import Foundation

struct udacityLoginResponse: Codable {
    let account: UdacityAccount
    let session: UdacitySession
    
    enum CodingKeys: String, CodingKey {
        case account = "account"
        case session = "session"
    }
}

struct UdacityAccount: Codable {
    let registered: Bool
    let key: String
}

struct UdacitySession: Codable {
    let id: String
    let expiration: String
}
