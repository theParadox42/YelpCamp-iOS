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
        
        // Make Sure Inputs Aren't Empty
        if passwordTextField.text == "" || usernameTextField.text == "" || emailTextField.text == "" {
            usernameTextField.placeholder = "Enter Username"
            emailTextField.placeholder = "Enter Email"
            passwordTextField.placeholder = "Enter Password"
            return
        }
        // Make sure passwords match
        else if passwordTextField.text != confirmPasswordTextField.text {
            print("Passwords do not match")
            passwordTextField.text = ""
            confirmPasswordTextField.text = ""
            passwordTextField.placeholder = "Passwords Do Not Match!"
            return
        }
        
        // make sure inputs exist
        if let password = passwordTextField.text, let username = usernameTextField.text, let email = emailTextField.text {
            
            createURLRequest(username: username, email: email, password: password)
        } else {
            usernameTextField.placeholder = "Enter Username"
            emailTextField.placeholder = "Enter Email"
            passwordTextField.placeholder = "Enter Password"
        }
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
                    print("Successfully signed user up!")
                    self.successSignup(username: username, password: password)
                } else {
                    print(signUpResponse.type)
                    print("Failed to sign user up!")
                    print(signUpResponse.data.message ?? "Unknown Reason")
                    print(signUpResponse.data.error?.message ?? "Unknown Error")
                    self.failedSignup()
                }
            } catch {
                print("Error decoding data")
                print(error)
                self.failedSignup()
            }
        }) { (error) in
            print("Error performing signup request")
            if let err = error {
                print(err)
            }
            self.failedSignup()
        }
        
        // Send Request
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: api.handleResponse(data:response:error:))
        task.resume()
    }
    
    private func failedSignup() {
        performSegue(withIdentifier: "signUpToHome", sender: self.self)
    }
    
    private func successSignup(username: String, password: String) {
        self.performSegue(withIdentifier: "signUpToHome", sender: self.self)
        userDefaults.set(username, forKey: "username")
        userDefaults.set(password, forKey: "password")
    }

}
