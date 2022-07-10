//
//  AddPinViewController.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 05/02/2021.
//

import Foundation
import UIKit
import MapKit

class AddPinViewController: UIViewController {

    //MARK: IB Outlets
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var mediaLinkTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var pinImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var geocodeActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var cancelButton: UIBarButtonItem!
 
    //MARK: Variables
    
    //MARK: Errors
    enum Errors {
        
        case missingInput
        case geocodeFailed
        case networkError
        case generic
        
        var nsError: NSError {
            switch self {
            case .missingInput : return NSError(domain: "Error", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Make sure to enter a location and website"])
            case .geocodeFailed : return NSError(domain: "Location Error", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Unable to find a location that matches the eneterd text"])
            case .networkError : return NSError(domain: "Network Error", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Unable to find your location. Check your network connection"])
            case .generic : return NSError(domain: "Unknown Error", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Something is missing, please sign in again and try again"])
            }
        }
    }
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    //MARK: Set UI
    func setUI() {
        setTransparentNavigationBar()
        geocodeActivityIndicator.alpha = 0
        pinImageView.tintColor = InterfaceColours.red
        
        submitButton.layer.cornerRadius = 10
        submitButton.backgroundColor = InterfaceColours.blue
        submitButton.setTitleColor(.white, for: .normal)
    }
    
    func setTransparentNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    
    //MARK: Create Student Location from Entered Text
    func getStudentLocationFromTextFields(completion: @escaping (StudentLocation) -> Void) {
        activiyIndicatorIs(active: true)
        var mapItem: MKMapItem?
        let search = createLocationSearch()
        search.start { (response, error ) in
            if let error = error as NSError? {
                if error.domain .contains("MK") {
                    self.handelError(error: Errors.geocodeFailed.nsError)
                } else {
                    self.handelError(error: Errors.networkError.nsError)
                }
                return
            }
            guard let response = response else { return }
            mapItem = response.mapItems[0]
            guard let studentLocation = self.createStudentLocation(location: mapItem) else { return }
            completion(studentLocation)
        }
    }
    
    func createLocationSearch() -> MKLocalSearch {
        let userLocationString = locationTextField.text ?? ""
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = userLocationString
        let search = MKLocalSearch(request: searchRequest)
        return search
    }

    func createStudentLocation(location: MKMapItem?) -> StudentLocation? {
        guard let mapItem = location,
              let user = UdacityApiClient.currentUserData,
              let login = UdacityApiClient.currentLogin?.account,
              let userUrl = URL(string: self.mediaLinkTextField.text ?? "")
        else {
            handelError(error: Errors.generic.nsError)
            return nil
        }
       
        let studentLocation = StudentLocation(
            firstName: user.firstName,
            lastName: user.lastName,
            longitude: mapItem.placemark.coordinate.longitude,
            latitude: mapItem.placemark.coordinate.latitude,
            locationString: mapItem.name!,
            url: userUrl.absoluteString,
            identifierKey: login.key,
            objectID: "",
            createdAt: "",
            updatedAt: "")
        
        return studentLocation
    }
    
    //MARK: Errors
    func alertUserTo(error: NSError) {
        let alertController = UIAlertController(title: error.domain, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func checkForUserInput() -> Bool{
        let locationString = locationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let websiteString  = mediaLinkTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if locationString == "" || websiteString == "" {
            return false
        } else {
            return true
        }
    }
        
    func handelError(error: NSError) {
        activiyIndicatorIs(active: false)
        alertUserTo(error: error)
    }
    
    
    //MARK: Button Actions
    @IBAction func submitButtonDidTapped() {
        resignAllTextFields()
        if !checkForUserInput() { handelError(error: Errors.missingInput.nsError) }
        getStudentLocationFromTextFields() { (postedLocation) in
            self.activiyIndicatorIs(active: false)
            let destination = self.storyboard?.instantiateViewController(identifier: "ConfirmPostViewController") as! ConfirmPostViewController
            destination.createdLocation = postedLocation
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    @IBAction func cancelButtonDidTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Activity Indicator
    func activiyIndicatorIs(active: Bool) {
        //Animated Changes
        UIView.animate(withDuration: 0.2) {
            if active {
                self.geocodeActivityIndicator.alpha = 1
            } else {
                self.geocodeActivityIndicator.alpha = 0
            }
        }
        //Non Animated Changes
        if active {
            self.geocodeActivityIndicator.startAnimating()
            cancelButton.isEnabled = false
        } else {
            self.geocodeActivityIndicator.stopAnimating()
            cancelButton.isEnabled = true
        }
    }
}
//MARK: TextFields
extension AddPinViewController: UITextFieldDelegate {
    
    func resignAllTextFields() {
        locationTextField.resignFirstResponder()
        mediaLinkTextField.resignFirstResponder()
    }
    
    func clearAllTextFields() {
        locationTextField.text = nil
        mediaLinkTextField.text = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}
