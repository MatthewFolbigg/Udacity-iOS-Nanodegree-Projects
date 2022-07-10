//
//  LoginViewController.swift
//  On The Map - Udacity iOS NanoDegree
//
//  Created by Matthew Folbigg on 01/02/2021.
//  Udacity Logo and Text are not my own and are from Udacity. They are beign used for Educational purposes only

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginActivityIndicatior: UIActivityIndicatorView!
    @IBOutlet var friendlyReminderLabel: UILabel!
    
    //MARK: Varibales
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        setUI()
    }
        
    //MARK: Network Requests
    func login() {
        UdacityApiClient.removeCurrentLoginData()
        let user = createUserFromTextFields()
        activiyIndicatorIs(active: true)
        UdacityApiClient.login(user: user, completion: handelLoginResponse(loginSuccess: error:))
    }
    
    //MARK: Network Completeion Handelers
    func handelLoginResponse(loginSuccess: Bool, error: Error?) -> Void {
        if let error = error {
            alertUserTo(error: error as NSError)
            return
        }
        
        guard let userID = UdacityApiClient.currentLogin?.account.key else {
            //TODO: Handel this error
            return
        }
        UdacityApiClient.getUserData(userID: userID, completeion: handelUserDataResposne(success:error:))
    }
    
    func handelUserDataResposne(success: Bool, error: Error?) {
        activiyIndicatorIs(active: false)
        if success  {
            self.performLoginSegue()
        } else {
            if let error = error { self.alertUserTo(error: error as NSError) }
        }
    }
    
    //MARK: UI Setup
    func setUI() {
        view.backgroundColor = InterfaceColours.udacityBackground
        loginButton.layer.cornerRadius = 10
        loginButton.backgroundColor = InterfaceColours.udacityBlue
        loginButton.setTitleColor(InterfaceColours.udacityBackground, for: .normal)
        skipButton.setTitleColor(InterfaceColours.udacityBlue, for: .normal)
        signUpButton.setTitleColor(InterfaceColours.udacityBlue, for: .normal)
        loginActivityIndicatior.alpha = 0
        setFriendlyReminderLabel(active: false)
    }
    
    //MARK: Button Actions
    @IBAction func loginButtonDidTapped() {
        if !checkForCredentials() {
            alertNoCredentialEntered()
            return
        }
        resignAllTextFields()
        login()
    }
    
    @IBAction func skipButtonDidTapped() {
        resignAllTextFields()
        UdacityApiClient.removeCurrentLoginData()
        clearTextFields()
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        //TODO: Add Warning about no login
    }
    
    @IBAction func signUpButtonDidTapped() {
        let url = UdacityApiClient.EndPoints.signUp.url
        print(url)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        print("Sign Up")
    }
    
    //MARK: Activity Indicator
    func activiyIndicatorIs(active: Bool) {
        //Animated Changes
        UIView.animate(withDuration: 0.2) {
            if active {
                self.loginActivityIndicatior.alpha = 1
            } else {
                self.loginActivityIndicatior.alpha = 0
            }
        }
        //Non Animated Changes
        if active {
            self.loginActivityIndicatior.startAnimating()
            
        } else {
            self.loginActivityIndicatior.stopAnimating()
        }
    }

    //MARK: Login Helper Methods
    func checkForCredentials() -> Bool {
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if username == "" || password == "" {
            return false
        } else {
            return true
        }
    }

    func performLoginSegue() {
        passwordTextField.text = nil
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func setFriendlyReminderLabel(active: Bool) {
        //Reminds user to add both a password and username if one of the text fields is empty
        UIView.animate(withDuration: 0.2) {
            if active {
                self.friendlyReminderLabel.alpha = 1
            } else {
                self.friendlyReminderLabel.alpha = 0
            }
        }
    }
    
    //MARK: Login Error User Alerts
    func alertNoCredentialEntered() {
        setFriendlyReminderLabel(active: true)
    }
    
    func alertUserTo(error: NSError) {
        let alertController = UIAlertController(title: error.domain, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
}
//MARK: Text Fields
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == usernameTextField.tag {
            passwordTextField.becomeFirstResponder()
            return true
        }
        
        if textField.tag == passwordTextField.tag {
            resignAllTextFields()
            return true
        }
        return true
    }
    
    func resignAllTextFields() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func clearTextFields() {
        usernameTextField.text = nil
        passwordTextField.text = nil
    }
    
    func setUpTextFields() {
        //Username
        usernameTextField.textContentType = .username
        usernameTextField.tag = 1
        
        //Password
        passwordTextField.textContentType = .password
        passwordTextField.tag = 2
    }
    
    func createUserFromTextFields() -> UdacityUserCredentials {
        UdacityUserCredentials(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
    }    
}
