//
//  SignUpVC.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/28/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    //MARK: - Setup
    
    // IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // User defaults
    let userDefaults = UserDefaults.standard
    
    //MARK: - Buttons Pressed
    
    @IBAction func cancelPressed(_ sender: Any) {
        // Dismiss View
        dismiss(animated: true, completion: nil)
    }
    
    // Sign Up pressed
    @IBAction func signUpPressed(_ sender: Any) {
        
        // Disable sign up button
        signUpButton.isEnabled = false
        // Start loading thing
        loadingIndicator.startAnimating()
        
        var alertHeader = "Passwords Do Not Match"
        var alertMessage = "Make sure your passwords match before signing up."
        
        // Make Sure Inputs Aren't Empty
        if passwordTextField.text == "" || usernameTextField.text == "" || emailTextField.text == "" {
            alertHeader = "Missing Info"
            alertMessage = "Please fill in all the boxes before signing up"
        }
        // Make sure passwords match
        else if passwordTextField.text != confirmPasswordTextField.text {
            self.passwordTextField.text = ""
            self.confirmPasswordTextField.text = ""
        }
        // make sure inputs exist
        else if let password = passwordTextField.text, let username = usernameTextField.text, let email = emailTextField.text {
            createURLRequest(username: username, email: email, password: password)
            return
        }
        let alert = UIAlertController(title: alertHeader, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Send API Request
    
    func createURLRequest(username: String, email: String, password: String){
        
        // Create urlRequest
        var urlRequest = URLRequest(url: URL(string: API.shared.urlString + "register")!)
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        // Create HTTPBody
        let parameters: [String: Any] = [
            "username": username,
            "email": email,
            "password": password,
            "admincode": API.shared.adminCode
        ]
        urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        let api = API(successFunc: { (jsonData) in
            let decoder = JSONDecoder()
            do {
                let signUpResponse = try decoder.decode(RegularResponseObject.self, from: jsonData)
                if signUpResponse.type == "success" {
                    self.succeededSignup(username: username, password: password)
                } else {
                    self.failedSignup(reason: signUpResponse.data.error?.message ?? signUpResponse.data.message ?? "Failed to sign user up!")
                }
            } catch {
                print("Error decoding data")
                print(error)
                self.failedSignup(reason: "Unknown Reason")
            }
        }) { (error) in
            self.failedSignup(reason: "Try Checking Your Internet!")
        }
        
        // Send Request
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: api.handleResponse(data:response:error:))
        task.resume()
    }
    
    //MARK: - Handle outcomes
    
    private func failedSignup(reason message: String) {
        let failedAlert = UIAlertController(title: "Failed Sign Up", message: message, preferredStyle: .alert)
        failedAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.signUpButton.isEnabled = true
            self.loadingIndicator.stopAnimating()
        }))
        present(failedAlert, animated: true, completion: nil)
    }
    
    private func succeededSignup(username: String, password: String) {
        userDefaults.set(username, forKey: "username")
        userDefaults.set(password, forKey: "password")
        self.performSegue(withIdentifier: "signUpToTabView", sender: self.self)
    }

}
