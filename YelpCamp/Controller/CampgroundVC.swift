//
//  CampgroundVC.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/29/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

class CampgroundVC: UIViewController, CommentViewDelegate {
    
    //MARK: - Setup
    
    // IBOutlets
    @IBOutlet weak var campgroundName: UILabel!
    @IBOutlet weak var campgroundImage: UIImageView!
    @IBOutlet weak var authorButton: UIButton!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentStack: UIStackView!
    
    // Campground Object
    var campgroundID: String!
    var sendAccount: AccountObject?
    
    // When an error occurs getting data
    private var errorOccurred: Bool = false
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let campground = getCampgroundData() {
            
            // Set campground info
            campgroundName.text = campground.name
            if let url = URL(string: campground.img){
                campgroundImage.load(url: url)
            }
            authorButton.setTitle(campground.author.username, for: .normal)
            timeAgoLabel.text = campground.sinceCreated ?? "a few UNKNOWN ago"
            descriptionLabel.text = campground.description
            priceLabel.text = "Costs $\(campground.price) per night"
            
            // Load comments in
            for comment in campground.comments {
                let commentView = CommentView()
                commentView.setCommentAttributes(comment: comment)
                commentView.delegate = self
                commentStack.addArrangedSubview(commentView)
            }
            
        } else {
            errorOccurred = true
        }
    }
    
    //MARK: - View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("Why didn't it work?")
        
        // If error occurred, dismiss view controller
        if errorOccurred {
            let errorAlert = UIAlertController(title: "Error", message: "An error occurred loading this campground. Make sure it exists.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            present(errorAlert, animated: true, completion: nil)
        }
        
    }
    
    //MARK: - Get Campground Data
    
    func getCampgroundData() -> CampgroundObject? {
        if let data = try? Data(contentsOf: URL(string: API.shared.urlString + "campgrounds/" + campgroundID)!) {
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
    
    //MARK: - IBActions
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func authorButtonPressed(_ sender: Any) {
        if let safeUsername = authorButton.titleLabel?.text {
            goToProfile(username: safeUsername)
        }
    }
    
    //MARK: - API Requests
    
    func goToProfile(username: String){
        
        if let data = try? Data(contentsOf: URL(string: API.shared.urlString + "profile/\(username)")!) {
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(AccountResponseObject.self, from: data)
                if response.type == "user" {
                    sendAccount = response.data!
                    performSegue(withIdentifier: "goToProfile", sender: self)
                    return
                } else {
                    print("Response brought error")
                }
            } catch {
                print("Error getting account info")
                print(error)
            }
        }
        
        authorButton.isEnabled = false
        
    }
    
    //MARK: - Delegate Methods
    
    func usernamePressed(username: String) {
        goToProfile(username: username)
    }
    
    func commentCampgroundPressed(campground: CommentCampgroundObject) {
        // Not used but required to conform to protocol
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let profileVC = segue.destination as? ProfileVC {
            profileVC.accountProfile = sendAccount!
        }
    }

}
