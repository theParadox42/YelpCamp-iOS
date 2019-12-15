//
//  HomeVC.swift
//  YelpCamp
//
//  Created by Nathaniel on 12/11/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // userDefaults
    private var userDefaults = UserDefaults.standard
    
    //MARK: - View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if var signinRequest = API.shared.setAuth(urlRequest: URLRequest(url: URL(string: API.shared.urlString + "checkuser")!)) {
            
            signinRequest.httpMethod = "POST"
            
            // set loading alert
            let loadingAlert = UIAlertController(title: "Loading", message: "Signing In...", preferredStyle: .alert)
            present(loadingAlert, animated: true)
            
            let api = API(successFunc: { (data) in
                loadingAlert.dismiss(animated: true, completion: nil)
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(RegularResponseObject.self, from: data)
                    if response.type == "success" {
                        return self.signinSucceeded()
                    } else {
                        print(response)
                    }
                } catch {
                    print("Error decoding response")
                    print(error)
                }
                self.signinFailed()
            }) { (error) in
                loadingAlert.dismiss(animated: true, completion: nil)
                self.signinFailed()
            }
            
            let signinTask = URLSession.shared.dataTask(with: signinRequest, completionHandler: api.handleResponse(data:response:error:))
            
            signinTask.resume()
            
        }
        
    }
    
    //MARK: - Request Outcomes
    
    func signinFailed() {
        let failedAlert = UIAlertController(title: "Signin Failed", message: "Automatic Sign In Failed.", preferredStyle: .alert)
        failedAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(failedAlert, animated: true, completion: nil)
    }
    
    func signinSucceeded() {
        performSegue(withIdentifier: "quickLoginSegue", sender: self)
    }

}
