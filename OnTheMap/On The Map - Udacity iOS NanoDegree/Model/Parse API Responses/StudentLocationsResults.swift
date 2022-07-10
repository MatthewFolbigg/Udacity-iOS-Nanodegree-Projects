//
//  GetStudentLocationsResponse.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 02/02/2021.
//

import Foundation

struct StudentLocationsResults: Codable {
    
    let studentLocations: [StudentLocation]
    
    enum CodingKeys: String, CodingKey {
        case studentLocations = "results"
    }
    
}
