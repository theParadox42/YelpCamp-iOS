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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let signinRequest = API.shared.setAuth(urlRequest: URLRequest(url: URL(string: API.shared.urlString + "checkuser")!)) {
            
            let loadingAlert = UIAlertController(title: "Loading", message: "Signing In...", preferredStyle: .alert)
            present(loadingAlert, animated: true)
            
            let api = API(successFunc: { (data) in
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(RegularResponseObject.self, from: data)
                    if response.type == "success" {
                        
                    }
                } catch {
                    print("Error decoding response")
                    print(error)
                }
                loadingAlert.dismiss(animated: true, completion: nil)
            }) { (error) in
                loadingAlert.dismiss(animated: true, completion: nil)
            }
            
            let signinTask = URLSession.shared.dataTask(with: signinRequest, completionHandler: api.handleResponse(data:response:error:))
            
            signinTask.resume()
            
        }
        
    }
    
    func signinFailed() {
        let failedAlert = UIAlertController(title: "Signin Failed", message: "Automatic Sign In Failed.", preferredStyle: .alert)
        failedAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
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
