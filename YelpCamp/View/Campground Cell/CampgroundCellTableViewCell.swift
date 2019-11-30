//
//  CampgroundCellTableViewCell.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/29/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

protocol CampgroundCellDelegate {
    func wasPressed(campground: CampgroundObject?)
}

class CampgroundCellTableViewCell: UITableViewCell {
    
    // IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var campgroundImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // Delegate
    var delegate: CampgroundCellDelegate?
    var cellCampground: CampgroundObject?
    
    // Init
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Set cell up
    func setAttributes(campground: CampgroundObject) {
        cellCampground = campground
        
        nameLabel.text = campground.name
//        campgroundImage.image = Fill in here
        authorLabel.text = campground.author.username
//        timeAgoLabel.text = Fill in here
        descriptionLabel.text = campground.description
    }
    
    // On Selection
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected == true {
            delegate?.wasPressed(campground: cellCampground)
        }
    }
    
}
