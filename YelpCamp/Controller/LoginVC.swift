//
//  LoginVC.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/28/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    //MARK: - Setup
    
    // IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // Defaults
    let userDefaults = UserDefaults.standard
    
    //MARK: - Login Pressed
    @IBAction func loginPressed(_ sender: Any) {
        
        // Disable button and start loading
        loginButton.isEnabled = false
        loadingIndicator.startAnimating()
        
        // Start urlRequest
        if let username = usernameTextField.text, let password = passwordTextField.text {
            if username != "" && password != "" {
                return performURLRequest(username: username, password: password)
            }
        }
        let enterInfo = UIAlertController(title: "Enter Info", message: "Please enter both a username and password", preferredStyle: .alert)
        enterInfo.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    }
    
    //MARK: - Send API Request
    func performURLRequest(username: String, password: String){
        // Create urlRequest
        var urlRequest = URLRequest(url: URL(string: API.shared.urlString + "checkuser")!)
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        let api = API(successFunc: { (jsonData) in
            let decoder = JSONDecoder()
            do {
                let loggedInResponse = try decoder.decode(RegularResponseObject.self, from: jsonData)
                if loggedInResponse.type == "success" {
                    print("Successfully logged user in!")
                    self.succeededLogin()
                } else {
                    self.failedLogin(changeSegues: false)
                }
            } catch {
                print("Error decoding data")
                self.failedLogin(changeSegues: true)
            }
        }) { (error) in
            print("Error performing signup request")
            self.failedLogin(changeSegues: true)
        }
        
        userDefaults.set(username, forKey: "username")
        userDefaults.set(password, forKey: "password")
        let authRequest = API.shared.setAuth(urlRequest: urlRequest)!
        // Send Request
        let task = URLSession.shared.dataTask(with: authRequest, completionHandler: api.handleResponse(data:response:error:))
        task.resume()
    }
    
    //MARK: - Outcomes
    func failedLogin(changeSegues: Bool) {
        let failedAlert = UIAlertController(title: "Wrong Credentials", message: "Either your username or password were wrong", preferredStyle: .alert)
        failedAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""
            if changeSegues {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.loginButton.isEnabled = true
            }
        }));
        
        present(failedAlert, animated: true)
        loadingIndicator.stopAnimating()
        
        userDefaults.removeObject(forKey: "username")
        userDefaults.removeObject(forKey: "password")
        
    }
    
    func succeededLogin() {
        performSegue(withIdentifier: "loggedInToTabView", sender: self.self)
    }
    
    //MARK: - Cancel Pressed
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
