//
//  CampgroundVC.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/29/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

class CampgroundVC: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var campgroundName: UILabel!
    @IBOutlet weak var campgroundImage: UIImageView!
    @IBOutlet weak var authorButton: UIButton!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // Campground Object
    var campground: CampgroundObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        campgroundName.text = campground.name
//        campgroundImage.image = TODO
        authorButton.setTitle(campground.author.username, for: .normal)
//        timeAgoLabel.text = TODO
        descriptionLabel.text = campground.description
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
