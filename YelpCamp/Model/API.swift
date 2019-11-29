//
//  API.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/28/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import Foundation

class API {
    
    static let shared = API(apiUrl: "https://paradox-yelp-camp.herokuapp.com/api/v1/")
//    static let shared = API(apiUrl: "http://localhost:8080/api/v1/")
    
    let urlString: String
    let adminCode = "7890"
    
    private init(apiUrl: String){
        self.urlString = apiUrl
    }
    
}
