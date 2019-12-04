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
    
    @IBAction func logoutPressed(_ sender: Any) {
        var urlRequest = URLRequest(url: URL(string: API.shared.urlString + "logout")!)
        urlRequest.httpMethod = "POST"
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
        }
    }

}
