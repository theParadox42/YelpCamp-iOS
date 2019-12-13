//
//  AccountVC.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/28/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {
    
    let userDefaults = UserDefaults.standard
    
    //MARK: - Logout user
    @IBAction func logoutPressed(_ sender: Any) {
        
        userDefaults.removeObject(forKey: "username")
        userDefaults.removeObject(forKey: "password")
        
    }

}
