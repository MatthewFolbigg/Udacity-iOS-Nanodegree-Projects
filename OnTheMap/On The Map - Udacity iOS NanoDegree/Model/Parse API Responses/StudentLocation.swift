//
//  StudentLocation.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 02/02/2021.
//

import Foundation

struct StudentLocation: Codable {
   
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let locationString: String
    let url: String
    let identifierKey: String
    let objectID: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        //Explicitly added all case even to some aren't required to prevend having to refer back to API documentation if any names are refactored in the future
        case firstName = "firstName"
        case lastName = "lastName"
        case longitude = "longitude"
        case latitude = "latitude"
        case locationString = "mapString"
        case url = "mediaURL"
        case identifierKey = "uniqueKey"
        case objectID = "objectId"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }
}

