//
//  StudentLocationsTableViewController.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 02/02/2021.
//

import Foundation
import UIKit

class StudentLocationsTableViewController: UITableViewController {
    
    //MARK: Outlets & UI Items
    var accountButton: UIBarButtonItem!
    var addPinButton: UIBarButtonItem!
    
    //MARK: Variables
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewPullToRefresh()
        setUpBarButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStudentLocations()
        setButtonsForLoginStatus()
    }
    
    //MARK: Network Requests
    @objc func updateStudentLocations() {
        ParseApiClient.getStudentLocations(completion: handleGetStudentLocations(locationsArray:error:))
    }
    
    //MARK: Network Completeion Handelers
    func handleGetStudentLocations(locationsArray: [StudentLocation]?, error: Error?) -> Void {
        guard let locations = locationsArray else {
            if let error = error {
                tableView.refreshControl?.endRefreshing()
                alertUserTo(error: error as NSError)
            }
            return
        }
        ParseApiClient.currentLocations = locations
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
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

    
    //MARK: Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ParseApiClient.currentLocations?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "Locations"}
        else { return nil }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentLocation = ParseApiClient.currentLocations![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentLocationTableCell") as! StudentLocationTableCell
        setCellUI(cell: cell, studentLocation: studentLocation)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationController = storyboard?.instantiateViewController(identifier: "moreDetailViewController") as! MoreDetailViewController
        destinationController.studentLocation = ParseApiClient.currentLocations![indexPath.row]
        destinationController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(destinationController, animated: true)
    }
    
    //MARK: Cell UI
    func setCellUI(cell: StudentLocationTableCell, studentLocation: StudentLocation) {
        cell.nameLabel.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.locationLabel.text = studentLocation.locationString
        cell.pinImageView.tintColor = InterfaceColours.red
        cell.arrowImageView.tintColor = InterfaceColours.blue
        cell.locationLabel.textColor = InterfaceColours.blue
    }
    
    //MARK: Pull to Refresh
    func setupTableViewPullToRefresh() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(updateStudentLocations), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        updateStudentLocations()
    }
}

