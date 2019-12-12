//
//  BasicDataModel.swift
//  YelpCamp
//
//  Created by Nathaniel on 12/1/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import Foundation

struct RegularResponseObject: Decodable {
    let type: String
    let data: RegularResponseData
}

struct RegularResponseData: Decodable {
    let message: String?
    let error: ErrorResponseObject?
}

struct ErrorResponseObject: Decodable {
    let message: String?
}
