//
//  MoreDetailViewController.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 03/02/2021.
//

import Foundation
import UIKit
import MapKit

class MoreDetailViewController: UIViewController {

    //MARK: Outlets
    //loc lat long link update
    @IBOutlet var latLabel: UILabel!
    @IBOutlet var longLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var urlLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    //MARK: Variables
    var studentLocation: StudentLocation?
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupMap()
    }
    
    //MARK: UI
    func setUI() {
        guard let studentLocation = self.studentLocation else {
            print("No Location passed by table view")
            return
        }
        self.navigationItem.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
        
        locationLabel.text = studentLocation.locationString
        latLabel.text = String(studentLocation.latitude)
        longLabel.text = String(studentLocation.longitude)
        urlLabel.text = studentLocation.url
    }
    
    //MARK: Open Website Button
    @IBAction func openWebsiteButtonDidTapped() {
        
        guard let studentLocation = self.studentLocation else {
            print("No Location passed by table view")
            return
        }
        followLink(urlString: studentLocation.url)
    }
    
    func followLink(urlString: String) {
        if urlString.contains("http") {
            guard let url = URL(string: urlString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            guard let url = URL(string: "https://\(urlString)") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //MARK: Map View
    func setupMap() {
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isRotateEnabled = false
        mapView.layer.cornerRadius = 20
        
        guard let studentLocation = self.studentLocation else { return }
        
        setMapCenter(location: studentLocation)
        createPin(location: studentLocation)
    }
    
    func setMapCenter(location: StudentLocation) {
        var lastCoordinate = CLLocationCoordinate2D()
        lastCoordinate.latitude = location.latitude
        lastCoordinate.longitude = location.longitude
    
        var region = MKCoordinateRegion()
        region.center = lastCoordinate
        region.span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        mapView.setRegion(region, animated: true)
    }
    
    func createPin(location: StudentLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = location.latitude
        annotation.coordinate.longitude = location.longitude
        mapView.addAnnotation(annotation)
    }
}
