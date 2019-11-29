//
//  signUpRequestObject.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/28/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import Foundation

struct responseData: Decodable {
    let message: String?
    let error: String?
}

struct SignUpResponseObject: Decodable {
    let type: String
    let data: responseData
}
