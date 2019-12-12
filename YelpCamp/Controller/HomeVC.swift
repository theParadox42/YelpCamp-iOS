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
        
        if let username = userDefaults.value(forKey: "username") as? String,
            let password = userDefaults.value(forKey: "password") as? String {
            
            print(username)
            print(password)
            
            
            
        }
        
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
