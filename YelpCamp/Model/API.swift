//
//  API.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/28/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import Foundation

class API {
    
    static let shared = API(successFunc: { (useless) in
        print("Don't use me!")
    }) { (useless) in
        print("Don't use me!")
    }
    
    let urlString: String = "https://paradox-yelp-camp.herokuapp.com/api/v1/"
    let adminCode: String = "7890"
    let successFunc: (Data) -> Void
    let failureFunc: (Error?) -> Void
    
    private let userDefaults = UserDefaults.standard
    
    init(successFunc: (@escaping (Data) -> Void), failureFunc: (@escaping (Error?) -> Void)){
        self.successFunc = successFunc
        self.failureFunc = failureFunc
    }
    
    
    func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
        if let err = error {
            DispatchQueue.main.async {
                self.failureFunc(err)
            }
            return
        } else if let jsonData = data {
            DispatchQueue.main.async {
                self.successFunc(jsonData)
            }
        } else {
            DispatchQueue.main.async {
                self.failureFunc(nil)
            }
        }
    }
    
    func setAuth(urlRequest: URLRequest) -> URLRequest? {
        if let username = userDefaults.value(forKey: "username") as? String {
            if let password = userDefaults.value(forKey: "password") as? String {
                // Thanks to Nate Cook @ Stackoverflow for this!
                var changedRequest = urlRequest
                let loginString = String(format: "%@:%@", username, password)
                let loginData = loginString.data(using: String.Encoding.utf8)!
                let base64LoginString = loginData.base64EncodedString()
                changedRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
                return changedRequest
            }
        }
        return nil
    }
    
}
