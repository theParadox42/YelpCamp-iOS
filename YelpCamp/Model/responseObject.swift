//
//  signUpRequestObject.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/28/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import Foundation

struct RegularResponseData: Decodable {
    let message: String?
    let error: ErrorResponseObject?
}

struct ErrorResponseObject: Decodable {
    let message: String?
}

struct RegularResponseObject: Decodable {
    let type: String
    let data: RegularResponseData
}

struct AuthorObject: Decodable {
    let username: String
    let id: String?
    let _id: String?
}

struct CommentObject: Decodable {
    let text: String
    let author: AuthorObject
}

struct CampgroundObject: Decodable {
    let name: String
    let description: String
    let price: String
    let createdAt: String?
    let comments: [CommentObject]
    let author: AuthorObject
}

struct CampgroundResponseObject: Decodable {
    let type: String
    let data: CampgroundObject
}

struct CampgroundsResponseObject: Decodable {
    let type: String
    let data: [CampgroundObject]
}
