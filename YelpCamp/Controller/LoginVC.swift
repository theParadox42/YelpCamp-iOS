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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
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
    
    func performURLRequest(username: String, password: String){
        // Create urlRequest
        var urlRequest = URLRequest(url: URL(string: API.shared.urlString + "login")!)
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        let api = API(successFunc: { (jsonData) in
            let decoder = JSONDecoder()
            do {
                let loggedInResponse = try decoder.decode(RegularResponseObject.self, from: jsonData)
                if loggedInResponse.type == "success" {
                    print("Successfully logged user in!")
                    self.performSegue(withIdentifier: "loggedInToTabView", sender: self.self)
                } else {
                    let failedAlert = UIAlertController(title: "Wrong Credentials", message: "Either your username or password were wrong", preferredStyle: .alert)
                    failedAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                    }))
                }
            } catch {
                print("Error decoding data")
                print(error)
                self.failedLogin()
            }
        }) { (error) in
            print("Error performing signup request")
            if let err = error {
                print(err)
            }
            self.failedLogin()
        }
        
        
        if let safeRequest = API.shared.setAuth(urlRequest: urlRequest) {
            // Send Request
            let task = URLSession.shared.dataTask(with: safeRequest, completionHandler: api.handleResponse(data:response:error:))
            task.resume()
        }
    }
    
    func failedLogin() {

        self.performSegue(withIdentifier: "loggedInToHome", sender: self.self)
    }
    
    func succeededLogin() {
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
