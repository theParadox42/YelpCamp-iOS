//
//  AccountVC.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/28/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Logout user
    
    @IBAction func logoutPressed(_ sender: Any) {
        var urlRequest = URLRequest(url: URL(string: API.shared.urlString + "logout")!)
        urlRequest.httpMethod = "POST"
        let api = API(successFunc: { (data) in
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(RegularResponseObject.self, from: data)
                if response.type == "error" {
                    print("response brought back error")
                    print(response.data.message ?? "no error given")
                    self.logoutFailed(error: nil)
                } else {
                    print("Logout successful")
                    self.performSegue(withIdentifier: "loggedOutSegue", sender: self)
                }
            } catch {
                print("Failed to decode")
                self.logoutFailed(error: nil)
            }
        }, failureFunc: logoutFailed(error:))
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: api.handleResponse(data:response:error:))
        task.resume()
    }
    
    func logoutFailed(error: Error?) {
        print("Logout Failed")
        let failedAlert = UIAlertController(title: "Logout Failed", message: "The App failed to logout the user out of the server", preferredStyle: .alert)
        present(failedAlert, animated: true, completion: nil)
    }

}
