//
//  CommentCell.swift
//  YelpCamp
//
//  Created by Nathaniel on 12/1/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

protocol CommentCellDelegate {
    func commentCampgroundPressed(campground: CommentCampgroundObject)
}

class CommentCell: UITableViewCell {
    
    // IBOutlets
    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var campgroundButton: UIButton!
    
    // Delegate
    var delegate: CommentCellDelegate?
    var commentCampground: CommentCampgroundObject?
    
    func setCommentAttributes(comment: CommentObject) {
        commentTextLabel.text = comment.text
        timeAgoLabel.text = comment.sinceCreated
        commentCampground = comment.campground
        campgroundButton.setTitle(commentCampground!.name, for: .normal)
    }
    
    @IBAction func campgroundPressed(_ sender: Any) {
        if let safeCampground = commentCampground {
            delegate?.commentCampgroundPressed(campground: safeCampground)
        }
    }
    
}
