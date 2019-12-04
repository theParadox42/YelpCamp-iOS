//
//  UserDataModel.swift
//  YelpCamp
//
//  Created by Nathaniel on 12/1/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import Foundation

struct AuthorObject: Decodable {
    let username: String
}

struct AccountObject: Decodable {
    let username: String
    let campgrounds: [BasicCampgroundObject]
    let comments: [CommentObject]
    let sinceCreated: String?
}

struct AccountResponseObject: Decodable {
    let type: String
    let data: AccountObject?
}
