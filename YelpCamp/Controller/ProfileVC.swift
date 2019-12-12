//
//  ProfileVC.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/30/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, CampgroundCellDelegate, CommentCellDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Setup
    
    // Objects
    var accountProfile: AccountObject!
    private var comments: [CommentObject] = []
    private var campgrounds: [BasicCampgroundObject] = []
    var sendCampgroundID: String?
    
    // IBOutlets
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var campgroundTableView: UITableView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var joinedAgoLabel: UILabel!
    
    // Load function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up some items from the account variable
        accountNameLabel.text = accountProfile.username
        comments = accountProfile.comments
        campgrounds = accountProfile.campgrounds
        joinedAgoLabel.text = "Joined \(accountProfile.sinceCreated ?? "unknown ago")"
        
        // TableViews
        campgroundTableView.delegate = self
        campgroundTableView.dataSource = self
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        // Register my cells
        campgroundTableView.register(UINib(nibName: "CampgroundCellTableViewCell", bundle: nil), forCellReuseIdentifier: "campgroundCell")
        commentTableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "commentCell")
        
    }
    
    //MARK: - IBActions
    
    // Dismiss view controller
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Delegate Protocol Methods
    
    // On any campground pressed
    func campgroundPressed(campground: CampgroundProtocol) {
        sendCampgroundID = campground._id
        performSegue(withIdentifier: "goToCampgroundFromProfile", sender: self)
    }
    // On any comment campground pressed
    func commentCampgroundPressed(campground: CommentCampgroundObject) {
        sendCampgroundID = campground.id
        performSegue(withIdentifier: "goToCampgroundFromProfile", sender: self)
    }
    
    // Useless function
    func usernamePressed(username: String) {
        // Won't do anything because the only links will be to this page
    }
    
    //MARK: - API Requests
    
    // Get a campground
    func getCampground(campground: CampgroundProtocol) -> CampgroundObject? {
        if let data = try? Data(contentsOf: URL(string: API.shared.urlString + "campgrounds/" + campground._id)!) {
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(CampgroundResponseObject.self, from: data)
                if response.type == "campground" {
                    return response.data
                } else {
                    print("Response brought error")
                }
            } catch {
                print("Error getting campground info")
                print(error)
            }
        }
        return nil
    }
    
    //MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return campgrounds.count
        } else if tableView.tag == 2 {
            return comments.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = campgroundTableView.dequeueReusableCell(withIdentifier: "campgroundCell", for: indexPath) as! CampgroundCellTableViewCell
            
            let campground = campgrounds[indexPath.row]

            cell.setAttributes(campground: campground)

            cell.delegate = self

            return cell
        } else if tableView.tag == 2 {
            let cell = commentTableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
            
            let comment = comments[indexPath.row]
            
            cell.setCommentAttributes(comment: comment)
            
            cell.delegate = self

            return cell
        }
        return UITableViewCell()
    }
    
    
    //MARK: - Navigation
    
    // Get ready for view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let campgroundVC = segue.destination as? CampgroundVC {
            campgroundVC.campgroundID = sendCampgroundID
        }
    }
    
}
