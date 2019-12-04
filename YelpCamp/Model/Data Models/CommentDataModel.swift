//
//  CommentDataModel.swift
//  YelpCamp
//
//  Created by Nathaniel on 12/1/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import Foundation

struct CommentCampgroundObject: Decodable {
    let name: String
    let id: String
}

struct CommentObject: Decodable {
    let text: String
    let author: AuthorObject
    let sinceCreated: String?
    let campground: CommentCampgroundObject
}
