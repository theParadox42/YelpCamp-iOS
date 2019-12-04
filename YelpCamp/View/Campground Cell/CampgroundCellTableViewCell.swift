//
//  CampgroundCellTableViewCell.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/29/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

protocol CampgroundCellDelegate {
    func campgroundPressed(campground: CampgroundProtocol)
}

class CampgroundCellTableViewCell: UITableViewCell {
    
    // IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var campgroundImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // Delegate
    var delegate: CampgroundCellDelegate?
    var cellCampground: CampgroundProtocol?
    
    // Init
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Set cell up
    func setAttributes(campground: CampgroundProtocol) {
        cellCampground = campground
        
        nameLabel.text = campground.name
        if let url = URL(string: campground.img) {
            campgroundImage.load(url: url)
        }
        authorLabel.text = campground.author.username
        timeAgoLabel.text = campground.sinceCreated ?? "a few UNKNOWN ago"
        descriptionLabel.text = campground.description
        priceLabel.text = "Price is $\(campground.price) per night"
    }
    
    // On Selection
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected == true {
            if let safeCampground = cellCampground {
                delegate?.campgroundPressed(campground: safeCampground)
            }
        }
    }
    
}
