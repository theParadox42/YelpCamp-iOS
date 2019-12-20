//
//  AccountVC.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/28/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    
    //MARK: - Setup
    
    
    // IBOutlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var automaticSigninSwitch: UISwitch!
    
    // User Defaults (for logging out)
    private let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        automaticSigninSwitch.setOn(!userDefaults.bool(forKey: "noAutomaticSignin"), animated: false)
        usernameLabel.text = "Username: \(userDefaults.string(forKey: "username") ?? "No Username Found")"
    }
    
    
    //MARK: - Logout user
    
    
    // On press
    @IBAction func logoutPressed(_ sender: Any) {
        logoutUser()
    }
    
    // Logout user
    func logoutUser() {
        
        // Remove credentials
        userDefaults.removeObject(forKey: "username")
        userDefaults.removeObject(forKey: "password")
        
        // Go home
        performSegue(withIdentifier: "loggedOutSegue", sender: self)
        
    }
    
    
    //MARK: - Delete Account Process
    
    
    //MARK: - Button Pressed
    
    // When the button is pressed, create a alert
    @IBAction func deleteAccountPressed(_ sender: Any) {
        let deleteAccountAlert = UIAlertController(title: "Are You Sure?", message: "Deleting your account will delete your profile, comments, campgrounds, and any other data we have stored on you.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Don't Erase", style: .cancel, handler: nil)
        let eraseAction = UIAlertAction(title: "Erase Account", style: .destructive) { (action) in
            self.requirePasscode()
        }
        deleteAccountAlert.addAction(cancelAction)
        deleteAccountAlert.addAction(eraseAction)
        present(deleteAccountAlert, animated: true, completion: nil)
    }
    
    
    //MARK: - Requires Passcode
    
    
    // Require passcode before deleting everything
    func requirePasscode() {
        
        // Really just a long series of alerts.
        
        let passwordCheckAlert = UIAlertController(title: "Enter your password", message: "Enter your passcode for you account with the username \(self.userDefaults.string(forKey: "username")!)", preferredStyle: .alert)
        passwordCheckAlert.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
            textField.textContentType = UITextContentType(rawValue: "Password")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let eraseAction = UIAlertAction(title: "Erase", style: .destructive) { (action) in
            if let passwordTextField = passwordCheckAlert.textFields?[0] {
                if let safePassword = self.userDefaults.string(forKey: "password") {
                    if passwordTextField.text == safePassword {
                        self.deleteAccount()
                        
                        return
                    }
                }
            }
            let wrongPasswordAlert = UIAlertController(title: "Wrong Password!", message: "You Entered Your Passcode Incorrectly", preferredStyle: .alert)
            wrongPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            wrongPasswordAlert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (action) in
                self.requirePasscode()
            }))
            self.present(wrongPasswordAlert, animated: true, completion: nil)
        }
        passwordCheckAlert.addAction(cancelAction)
        passwordCheckAlert.addAction(eraseAction)
        self.present(passwordCheckAlert, animated: true, completion: nil)
    }
    
    
    //MARK: - Delete Execution
    
    
    // Delete Everything
    private func deleteAccount() {
        
        let loadingAlert = UIAlertController(title: "Deleting...", message: "Telling our server to forget who you are...", preferredStyle: .alert)
        present(loadingAlert, animated: true, completion: nil)
        
        let api = API(successFunc: { (data) in
            
            loadingAlert.dismiss(animated: true, completion: nil)
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(RegularResponseObject.self, from: data)
                
                if response.type == "success" {
                    self.succeededDelete()
                } else {
                    self.failedDelete(reason: "Failed for reason: " + (response.data.message ?? "UNKNOWN REASON"))
                }
            } catch {
                self.failedDelete(reason: "Unable to parse outcome")
            }
        }) { (error) in
            
            loadingAlert.dismiss(animated: true, completion: nil)
            
            self.failedDelete(reason: "Error sending delete request")
        }
        
        var deleteRequest = URLRequest(url: URL(string: api.urlString + "user/delete")!)
        deleteRequest.httpMethod = "DELETE"
        if let safeRequest = api.setAuth(urlRequest: deleteRequest) {
            let deleteTask = URLSession.shared.dataTask(with: safeRequest, completionHandler: api.handleResponse(data:response:error:))
            deleteTask.resume()
        }
    }
    
    
    //MARK: - Delete Outcomes
    
    
    func succeededDelete() {
        let successAlert = UIAlertController(title: "Success!", message: "We successfully deleted your account!", preferredStyle: .alert)
        successAlert.addAction(UIAlertAction(title: "Thanks!", style: .cancel, handler: { (action) in
            
            // Log you out
            self.logoutUser()
            
        }))
        present(successAlert, animated: true, completion: nil)
    }
    
    func failedDelete(reason message: String) {
        let failedAlert = UIAlertController(title: "Failed to delete account", message: message, preferredStyle: .alert)
        failedAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(failedAlert, animated: true, completion: nil)
    }
    
    
    //MARK: - Other Settings
    // Automatic Sign-in
    @IBAction func switchValueChanged(_ sender: Any) {
        userDefaults.set(!automaticSigninSwitch.isOn, forKey: "noAutomaticSignin")
    }
}
