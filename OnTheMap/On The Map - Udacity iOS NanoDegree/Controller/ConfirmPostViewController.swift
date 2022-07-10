//
//  locationPostConfirmedViewController.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 06/02/2021.
//

import Foundation
import UIKit
import MapKit

class ConfirmPostViewController: UIViewController {

    //MARK: IB Outlets
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var addToMapButton: UIButton!
    @IBOutlet var postActivityController: UIActivityIndicatorView!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    //MARK: Variables
    var createdLocation: StudentLocation?
    
    enum Errors {
        case networkError
        
        var nsError: NSError {
            switch self {
            case .networkError : return NSError(domain: "Network Error", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Unable to post your location. Check your network connection"])
            }
        }
    }
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupButtonUI()
        setTransparentNavigationBar()
        postActivityController.alpha = 0
        postActivityController.stopAnimating()
    }
    
    //MARK: Setup UI
    func setupButtonUI() {
        addToMapButton.layer.cornerRadius = 10
        addToMapButton.backgroundColor = InterfaceColours.blue
        addToMapButton.setTitleColor(.white, for: .normal)
        addToMapButton.titleLabel?.text = "Add to Map"
    }
    
    func setTransparentNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    //MARK: Network POST Request
    func makePostRequest(completion: @escaping (Bool) -> Void) {
        guard let location = createdLocation else { return }
        ParseApiClient.postStudentLocation(studentLocation: location) { (error) in
            if error != nil {
                self.alertUserTo(error: Errors.networkError.nsError)
                completion(false)
            } else {
                self.dismiss(animated: true, completion: nil)
                completion(true)
            }
        }
    }
    
    //MARK: Open URL
    func followLink(urlString: String) {
        if urlString.contains("http") {
            guard let url = URL(string: urlString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            guard let url = URL(string: "https://\(urlString)") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //MARK: Activity Indicator
    func activiyIndicatorIs(active: Bool) {
        //Animated Changes
        UIView.animate(withDuration: 0.2) {
            if active {
                self.postActivityController.alpha = 1
            } else {
                self.postActivityController.alpha = 0
            }
        }
        //Non Animated Changes
        if active {
            self.postActivityController.startAnimating()
            self.addToMapButton?.setTitle("Dropping Pin...", for: .normal)
            cancelButton.isEnabled = false
        } else {
            self.postActivityController.stopAnimating()
            self.addToMapButton.setTitle("Add to Map", for: .normal)
            cancelButton.isEnabled = true
        }
    }
    
    //MARK: Errors
    func alertUserTo(error: NSError) {
        let alertController = UIAlertController(title: error.domain, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Map View
    func setupMap() {
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isRotateEnabled = false
        mapView.layer.cornerRadius = 20
        
        guard let location = self.createdLocation else { return }
        
        setMapCenter(location: location)
        createPin(location: location)
    }
    
    func setMapCenter(location: StudentLocation) {
        var lastCoordinate = CLLocationCoordinate2D()
        lastCoordinate.latitude = location.latitude
        lastCoordinate.longitude = location.longitude
    
        var region = MKCoordinateRegion()
        region.center = lastCoordinate
        region.span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        mapView.setRegion(region, animated: true)
    }
    
    func createPin(location: StudentLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = location.latitude
        annotation.coordinate.longitude = location.longitude
        mapView.addAnnotation(annotation)
        annotation.title = "\(createdLocation?.firstName ?? "")"
        annotation.subtitle = createdLocation?.url
    }
    
    //MARK: Button Actions
    @IBAction func backButtonDidTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToMapButtonDidTapped() {
        activiyIndicatorIs(active: true)
        makePostRequest { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            self.activiyIndicatorIs(active: false)
        }
    }
}

extension ConfirmPostViewController: MKMapViewDelegate {
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "userPin")
        //MARK: Pin UI
        view.canShowCallout = true
        view.pinTintColor = InterfaceColours.red
        view.animatesDrop = true
        view.isSelected = true
        
        let button = UIButton(type: .detailDisclosure)
        view.rightCalloutAccessoryView = button
            
        let image = UIImageView(image: UIImage(systemName: "person.fill"))
        image.tintColor = InterfaceColours.blue
        view.leftCalloutAccessoryView = image

        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            if let urlString = view.annotation?.subtitle {
                followLink(urlString: urlString!)
            }
        }
    }
}

