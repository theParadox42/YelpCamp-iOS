//
//  CampgroundVC.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/29/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

class CampgroundVC: UIViewController, CommentViewDelegate, UITextFieldDelegate {
    
    //MARK: - Setup
    
    // IBOutlets
    @IBOutlet weak var campgroundName: UILabel!
    @IBOutlet weak var campgroundImage: UIImageView!
    @IBOutlet weak var authorButton: UIButton!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var commentStack: UIStackView!
    
    
    // Campground Object
    var campgroundID: String!
    var sendAccount: AccountObject?
    
    // When an error occurs getting data
    private var errorOccurred: Bool = false
    
    // Cached CommentViews
    var commentViews: [CommentView] = []
    
    
    //MARK: - Start Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextField.delegate = self
        
        setCampgroundInfo()
    }
    
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
    
    //MARK: - Set Campground Info
    
    func setCampgroundInfo() {
        if let campground = getCampgroundData() {
            
            // Set campground info
            campgroundName.text = campground.name
            campgroundImage.load(urlString: campground.img)
            authorButton.setTitle(campground.author.username, for: .normal)
            timeAgoLabel.text = campground.sinceCreated ?? "a few UNKNOWN ago"
            descriptionLabel.text = campground.description
            priceLabel.text = "Costs $\(campground.price) per night"
            
            for commentView in commentViews {
                commentView.removeFromSuperview()
            }
            
            // Load comments in/out
            for comment in campground.comments {
                let commentView = CommentView()
                commentView.setCommentAttributes(comment: comment)
                commentView.delegate = self
                commentStack.addArrangedSubview(commentView)
                commentViews.append(commentView)
            }
            
        } else {
            errorOccurred = true
        }
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
    
    @IBAction func commentPressed(_ sender: Any) {
        sendComment()
    }
    
    //MARK: - TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        sendComment()
        
        return true
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
    
    func sendComment() {
        if let commentText = commentTextField.text {
            if commentText != "" {
                // Set some stuff
                commentTextField.isEnabled = false
                commentButton.isEnabled = false
                loadingIndicator.startAnimating()
                
                // Start setting up request
                var commentRequest = URLRequest(url: URL(string: API.shared.urlString + "campgrounds/" + campgroundID + "/comments")!)
                commentRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                commentRequest.httpMethod = "POST"
                let parameters: [String: Any] = [
                    "text": commentText
                ]
                commentRequest.httpBody = parameters.percentEscaped().data(using: .utf8)
                
                let api = API(successFunc: { (jsonData) in
                    let decoder = JSONDecoder()
                    do {
                        let signUpResponse = try decoder.decode(RegularResponseObject.self, from: jsonData)
                        if signUpResponse.type == "success" {
                            self.succeededComment()
                        } else {
                            self.failedComment(reason: signUpResponse.data.error?.message ?? signUpResponse.data.message ?? "Failed to sign user up!")
                        }
                    } catch {
                        print("Error decoding data")
                        print(error)
                        self.failedComment(reason: "Unknown Reason")
                    }
                }) { (error) in
                    self.failedComment(reason: "Try Checking Your Internet!")
                }
                
                if let authRequest = api.setAuth(urlRequest: commentRequest) {
                    let commentRequest = URLSession.shared.dataTask(with: authRequest, completionHandler: api.handleResponse(data:response:error:))
                    commentRequest.resume()
                } else {
                    failedComment(reason: "Was unable to authorize request")
                }
                return
            }
        }
        // Failed
        failedComment(reason: "Make sure to enter a comment!")
    }
    
    //MARK: - Response handling
    
    func failedComment(reason: String) {
        let failedAlert = UIAlertController(title: "Comment Failed!", message: reason, preferredStyle: .alert)
        failedAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.setCampgroundInfo()
            self.commentTextField.isEnabled = true
            self.commentTextField.text = ""
            self.commentButton.isEnabled = true
        }))
        present(failedAlert, animated: true)
    }
    
    func succeededComment() {
        setCampgroundInfo()
        commentTextField.isEnabled = true
        commentTextField.text = ""
        commentButton.isEnabled = true
        loadingIndicator.stopAnimating()
        
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
