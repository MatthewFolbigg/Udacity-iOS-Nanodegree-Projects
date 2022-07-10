//
//  StudentLocationMapViewController.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 03/02/2021.
//

import Foundation
import UIKit
import MapKit

class StudentLocationMapViewController: UIViewController {
    
    //MARK: Outlets & UI Elements
    @IBOutlet var mapView: MKMapView!
    var accountButton: UIBarButtonItem!
    var addPinButton: UIBarButtonItem!
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarButtons()
        setupMap()
        setMapCenter()
        askToLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStudentLocations()
        updateMapAnnotations()
        setButtonsForLoginStatus()
    }
    
    //MARK: Ask to Login on Initial load
    func askToLogin() {
        let destination = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        DispatchQueue.main.async {
            self.present(destination, animated: true, completion: nil)
        }
    }
        
    //MARK: Network Requests
    @objc func updateStudentLocations() {
        ParseApiClient.getStudentLocations(completion: handleGetStudentLocations(locationsArray:error:))
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
    
    //MARK: Network Completeion Handelers
    func handleGetStudentLocations(locationsArray: [StudentLocation]?, error: Error?) -> Void {
        guard let locations = locationsArray else {
            if let error = error {
                alertUserTo(error: error as NSError)
            }
            return
        }
        ParseApiClient.currentLocations = locations
        DispatchQueue.main.async {
            self.updateMapAnnotations()
            self.setMapCenter()
        }
    }
    
    //MARK: Error
    func alertUserTo(error: NSError) {
        let alertController = UIAlertController(title: error.domain, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Bar Buttons
    func getAddPinButton() -> UIBarButtonItem {
        let image = UIImage(systemName: "mappin.and.ellipse")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addPinButtonDidTapped))
        return button
    }
    
    func getAccountButton() -> UIBarButtonItem {
        let image = UIImage(systemName: "person")
        let button = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(accountButtonDidTapped))
        return button
    }
    
    func setUpBarButtons() {
        accountButton = getAccountButton()
        self.navigationItem.leftBarButtonItem = accountButton
        addPinButton = getAddPinButton()
        self.navigationItem.rightBarButtonItem = addPinButton
        setButtonsForLoginStatus()
    }

    func setButtonsForLoginStatus() {
        //Disables adding pins if user skipped log in
        if UdacityApiClient.currentLogin == nil {
            addPinButton.isEnabled = false
        } else {
            addPinButton.isEnabled = true
        }
    }
    
    //MARK: Bar Button Actions
    @objc func accountButtonDidTapped() {
        if UdacityApiClient.currentLogin == nil {
            let destination = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            self.present(destination, animated: true, completion: nil)
        } else {
            let destination = storyboard?.instantiateViewController(identifier: "AccountViewController") as! AccountViewController
            self.present(destination, animated: true, completion: nil)
        }
    }
    
    @objc func addPinButtonDidTapped() {
        let destination = (storyboard?.instantiateViewController(identifier: "AddPinNavController"))!
        present(destination, animated: true, completion: nil)
    }
    
    //MARK: Map View
    
    func setupMap() {
        mapView.mapType = .standard
        mapView.isRotateEnabled = false
    }
    
    func updateMapAnnotations() {
        let annotations = createMapPins()
        addToMap(annotations: annotations)
    }
    
    func addToMap(annotations: [MKPointAnnotation]) {
        for annotaion in annotations {
            mapView.addAnnotation(annotaion)
        }
    }
    
    func setMapCenter() {
        //Zooms map to most recently updated pin
        let lastLocation = ParseApiClient.currentLocations?.first
        var lastCoordinate = CLLocationCoordinate2D()
        lastCoordinate.latitude = lastLocation?.latitude ?? 0
        lastCoordinate.longitude = lastLocation?.longitude ?? 0
    
        var region = MKCoordinateRegion()
        region.center = lastCoordinate
        region.span = MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    //MARK: Map Annotations
    func createMapPins() -> [MKPointAnnotation] {
        var annotations: [MKPointAnnotation] = []
        guard let currentLocations = ParseApiClient.currentLocations else {
            return annotations
        }
        for location in currentLocations {
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = location.latitude
            annotation.coordinate.longitude = location.longitude
            annotation.title = "\(location.firstName)"
            annotation.subtitle = location.url
            
            annotations.append(annotation)
        }
        return annotations
    }
}

extension StudentLocationMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "userPin") as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "userPin")
            //MARK: Pin UI
            view!.canShowCallout = true
            view?.pinTintColor = InterfaceColours.red
            
            let button = UIButton(type: .detailDisclosure)
            view?.rightCalloutAccessoryView = button
            
            let image = UIImageView(image: UIImage(systemName: "person.fill"))
            image.tintColor = InterfaceColours.blue
            view?.leftCalloutAccessoryView = image
        } else {
            view?.annotation = annotation
        }
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

