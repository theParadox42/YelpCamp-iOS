//
//  API.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/28/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import Foundation

class API {
    
    static let shared = API(apiUrl: URL(string: "https://paradox-yelp-camp.herokuapp.com/api/v1/")!)
    
    let url: URL
    
    private init(apiUrl: URL){
        self.url = apiUrl
    }
    
}
