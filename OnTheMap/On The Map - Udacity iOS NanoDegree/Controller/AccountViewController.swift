//
//  AccountViewController.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 03/02/2021.
//  Udacity Logo and Text are not my own and are from Udacity. They are beign used for Educational purposes only
//

import Foundation
import UIKit

class AccountViewController: UIViewController {
   
    //MARK: IB Outlets
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var emailLabel: UILabel!
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailLabel.text = UdacityApiClient.currentUserData?.email.address
    }
        
    //MARK: UI Setup
    func setUI() {
        view.backgroundColor = InterfaceColours.udacityBackground
        logoutButton.layer.cornerRadius = 10
        logoutButton.backgroundColor = InterfaceColours.udacityBlue
        logoutButton.setTitleColor(InterfaceColours.udacityBackground, for: .normal)
        
        cancelButton.layer.cornerRadius = 10
        cancelButton.backgroundColor = InterfaceColours.udacityBackground
        cancelButton.setTitleColor(InterfaceColours.udacityBlue, for: .normal)
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = InterfaceColours.udacityBlueCG
    }
    
    //MARK: Logout Button Press
    @IBAction func logoutButtonDidTapped() {
        print("Logging Out ID: \(UdacityApiClient.currentLogin?.account.key ?? "ERROR: NO ID LOGGED IN")")
        UdacityApiClient.removeCurrentLoginData()
        
        performSegue(withIdentifier: "loginSegue", sender: nil)
        
        print(UdacityApiClient.currentLogin ?? "User Logged Out")
    }
    
    //MARK: Cancel Button Press
    @IBAction func cancelButtonDidTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
