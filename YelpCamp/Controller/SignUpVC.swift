//
//  SignUpVC.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/28/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Sign Up pressed
    @IBAction func signUpPressed(_ sender: Any) {
        
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
                    self.performSegue(withIdentifier: "signUpToTabView", sender: self.self)
                } else {
                    print(signUpResponse.type)
                    print("Failed to sign user up!")
                    print(signUpResponse.data.message ?? "Unknown Reason")
                    print(signUpResponse.data.error?.message ?? "Unknown Error")
                    self.performSegue(withIdentifier: "signUpToHome", sender: self.self)
                }
            } catch {
                print("Error decoding data")
                print(error)
                self.performSegue(withIdentifier: "signUpToHome", sender: self.self)
            }
        }) { (error) in
            print("Error performing signup request")
            if let err = error {
                print(err)
            }
            self.performSegue(withIdentifier: "signUpToHome", sender: self.self)
        }
        
        // Send Request
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: api.handleResponse(data:response:error:))
        task.resume()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
