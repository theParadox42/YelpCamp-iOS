//
//  CampgroundDataModel.swift
//  YelpCamp
//
//  Created by Nathaniel on 12/1/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import Foundation

protocol CampgroundProtocol: Decodable {
    var name: String { get }
    var description: String { get }
    var author: AuthorObject { get }
    var img: String { get }
    var price: String { get }
    var _id: String { get }
    var sinceCreated: String? { get }
}

struct BasicCampgroundObject: CampgroundProtocol {
    let name: String
    let description: String
    var author: AuthorObject
    let img: String
    let price: String
    let _id: String
    let sinceCreated: String?
}

struct CampgroundObject: CampgroundProtocol {
    let name: String
    let description: String
    let author: AuthorObject
    let img: String
    let price: String
    let comments: [CommentObject]
    let sinceCreated: String?
    let _id: String
}

struct CampgroundResponseObject: Decodable {
    let type: String
    let data: CampgroundObject
}

struct CampgroundsResponseObject: Decodable {
    let type: String
    let data: [CampgroundObject]
}
