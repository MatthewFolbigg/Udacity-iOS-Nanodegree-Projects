//
//  UdacityApiClient.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 03/02/2021.
//

import Foundation

class UdacityApiClient {
    
    static var currentLogin: udacityLoginResponse? = nil
    static var currentUserData: UdacityUserData? = nil
    
    //MARK: Endpoints
    enum EndPoints {
        
        static let baseUrl: String = "https://onthemap-api.udacity.com/v1"
        static let userSessionUrl: String = "/session"
        static let userDataUrl: String = "/users" // /<user_id>
        static let signUpURL: String = "https://auth.udacity.com/sign-up"
        
        case login
        case userData(String)
        case signUp
        
        var url: URL {
            URL(string: self.urlString)!
        }
        
        var urlString: String {
            switch self {
            case .login:
                return "\(EndPoints.baseUrl)\(EndPoints.userSessionUrl)"
            case .userData(let userID):
                return "\(EndPoints.baseUrl)\(EndPoints.userDataUrl)/\(userID)"
            case .signUp:
                return "\(EndPoints.signUpURL)"
            }
        }
    }
    
    //MARK: Errors
    enum Errors {
        
        case networkFailed
        case incorrectLoginDetails
        
        var nsError: NSError {
            switch self {
            case .networkFailed : return NSError(domain: "Network Error", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Failed to communicate with Udacity. Check your network connection."])
            case .incorrectLoginDetails : return NSError(domain: "Login Failed", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Incorrect username and/or password. Please try again."])
            }
        }
    }
    
    //MARK: Login POST Request
    static func login(user: UdacityUserCredentials, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: EndPoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            let loginData = UdacityLoginData(udacity: user)
            let data = try encoder.encode(loginData)
            request.httpBody = data
        } catch {
            DispatchQueue.main.async {
                completion(false, error)
                print("Failed to encode login credentials to JSON data")
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                let noDataError = Errors.networkFailed.nsError
                DispatchQueue.main.async {
                    completion(false, noDataError)
                }
                print("no data recived back from login put")
                return
            }
            
            //Removes first 5 characters from data to only include the required JSON
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            let decoder = JSONDecoder()
            do {
                let loginResponse = try decoder.decode(udacityLoginResponse.self, from: newData)
                DispatchQueue.main.async {
                    self.currentLogin = loginResponse
                    print("Sucess")
                    completion(true, nil)
                }
            } catch {
                let incorrectLoginError = Errors.incorrectLoginDetails.nsError
                DispatchQueue.main.async {
                    completion(false, incorrectLoginError)
                }
                print("not able to decode login response")
                return
            }
        }
        task.resume()
    }
    
    //MARK: User Data GET Request
    static func getUserData(userID: String, completeion: @escaping (Bool, Error?) -> Void) {
        print("URL: \(EndPoints.userData(userID).url)")
        let task = URLSession.shared.dataTask(with: EndPoints.userData(userID).url) { (data, response, error) in
            
            guard let data = data else {
                //TODO: Handle Error Here
                print("Error: No Data")
                return
            }
            
            //Removes first 5 characters from data to only include the required JSON
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            let decoder = JSONDecoder()
            do {
                let userData = try decoder.decode(UdacityUserData.self, from: newData)
                self.currentUserData = userData
                DispatchQueue.main.async {
                    completeion(true, error)
                }
            } catch {
                //TODO: Handle Error Here
                print(error)
            }
        }
        task.resume()
    }
    
    static func removeCurrentLoginData() {
        self.currentLogin = nil
        self.currentUserData = nil
    }
    
}
