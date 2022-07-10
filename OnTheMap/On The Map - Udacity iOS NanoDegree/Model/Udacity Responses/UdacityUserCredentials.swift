//
//  UdacityUserCredentials.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 03/02/2021.
//

import Foundation

struct UdacityLoginData: Codable {
    let udacity: UdacityUserCredentials
}

struct UdacityUserCredentials: Codable {
    let username: String
    let password: String
}

