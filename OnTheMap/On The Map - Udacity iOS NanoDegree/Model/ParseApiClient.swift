//
//  ParseApiClient.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 02/02/2021.
//

import Foundation

class ParseApiClient {
    
    static var currentLocations: [StudentLocation]?
    
    //MARK: Endpoints
    enum Endpoints {
        static let baseUrl: String = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let queryOrderUpdateTime: String = "order=-updatedAt"
        static let queryLimit: String = "limit=100"
        
        case getStudentLocations
        
        var url: URL {
            URL(string: self.urlString)!
        }
        
        //MARK: Endpoint construction 
        var urlString: String {
            switch self {
            case .getStudentLocations:
                return Endpoints.baseUrl + "?" + Endpoints.queryOrderUpdateTime + "&" + Endpoints.queryLimit
                
            }
        }
    }
    
    //MARK: Errors
    enum Errors {
        
        case networkFailed
        case unableToDecode
        case unableToEncode
        
        var nsError: NSError {
            switch self {
            case .networkFailed : return NSError(domain: "Network Error", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Failed to communicate with Locations server. Check your network connection."])
            case .unableToDecode : return NSError(domain: "Error", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Unable to update locations. Please try again later"])
            case .unableToEncode : return NSError(domain: "Error", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Unable to generate your pin. Please try again"])
            }
        }
    }
    
    //MARK: GET Resquests
    class func getStudentLocations(completion: @escaping ([StudentLocation]?, Error?) -> Void) {
        let endpoint = Endpoints.getStudentLocations.url
        let task = URLSession.shared.dataTask(with: endpoint) { (data, response, error)
            in
            guard let data = data else {
                let networkError = Errors.networkFailed.nsError
                DispatchQueue.main.async {
                    completion(nil, networkError)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
            let responseObject = try decoder.decode(StudentLocationsResults.self, from: data)
                let studentLocations = responseObject.studentLocations
                DispatchQueue.main.async {
                    self.currentLocations = studentLocations
                    completion(studentLocations, nil)
                }
            } catch {
                let decodeError = Errors.unableToDecode.nsError
                DispatchQueue.main.async {
                    completion(nil, decodeError)
                }
            }
        }
        task.resume()
    }
    
    //MARK: POST Resquests
    class func postStudentLocation(studentLocation: StudentLocation, completion: @escaping (Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getStudentLocations.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            let studentLocationJSON = try encoder.encode(studentLocation)
            request.httpBody = studentLocationJSON
        } catch {
            let encodeError = Errors.unableToEncode.nsError
            DispatchQueue.main.async {
                completion(encodeError)
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if data == nil {
                let networkError = Errors.networkFailed.nsError
                DispatchQueue.main.async {
                    completion(networkError)
                }
                return
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
        
        
    }
    

}
