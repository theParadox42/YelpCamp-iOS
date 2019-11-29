//
//  LoginVC.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/28/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if let username = usernameTextField.text, let password = passwordTextField.text {
            if username == "" && password == "" {
                usernameTextField.placeholder = "Enter Username"
                passwordTextField.placeholder = "Enter Password"
            } else {
                performURLRequest(username: username, password: password)
            }
        } else {
            usernameTextField.placeholder = "Enter Username"
            passwordTextField.placeholder = "Enter Password"
        }
    }
    
    func performURLRequest(username: String, password: String){
        // Create urlRequest
        var urlRequest = URLRequest(url: URL(string: API.shared.urlString + "login")!)
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        // Create HTTPBody
        let parameters: [String: Any] = [
            "username": username,
            "password": password,
        ]
        urlRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        let api = API(successFunc: { (jsonData) in
            let decoder = JSONDecoder()
            do {
                let loggedInResponse = try decoder.decode(RegularResponseObject.self, from: jsonData)
                if loggedInResponse.type == "success" {
                    print("Successfully logged user in!")
                    self.performSegue(withIdentifier: "loggedInToTabView", sender: self.self)
                } else {
                    print(loggedInResponse)
                    self.passwordTextField.text = ""
                    self.passwordTextField.placeholder = "Password Doesn't Match Username"
                }
            } catch {
                print("Error decoding data")
                print(error)
                self.performSegue(withIdentifier: "loggedInToHome", sender: self.self)
            }
        }) { (error) in
            print("Error performing signup request")
            if let err = error {
                print(err)
            }
            self.performSegue(withIdentifier: "loggedInToHome", sender: self.self)
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
