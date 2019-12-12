//
//  CampgroundsVC.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/28/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

class CampgroundsVC: UITableViewController, CampgroundCellDelegate {
    
    //MARK: - Setup

    // Campground Array
    var campgrounds: [CampgroundObject] = []
    var setCampground: CampgroundObject?
    
    // IBOutlets
    @IBOutlet var campgroundTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Send request to get campgrounds
        sendCampgroundRequest()
        
        // Register your CampgroundCell.xib file here:
        campgroundTableView.register(UINib(nibName: "CampgroundCellTableViewCell", bundle: nil), forCellReuseIdentifier: "campgroundCell")
        
    }
    
    
    //MARK: - API Requests
    func sendCampgroundRequest(){
        
        let api = API(successFunc: { (data) in
            let decoder = JSONDecoder()
            do {
                let campgroundsResponse = try decoder.decode(CampgroundsResponseObject.self, from: data)
                if campgroundsResponse.type == "campgrounds" {
                    print("Successfully got campgrounds")
                    self.campgrounds = campgroundsResponse.data
                    self.campgroundTableView.reloadData()
                    self.loadingIndicator.stopAnimating()
                } else {
                    print("Error accessing campgrounds")
                    print(campgroundsResponse.type)
                }
            } catch {
                print("Error parsing campgrounds")
                print(error)
            }
        }) { (error) in
            if let err = error {
                print("Error getting campgrounds")
                print(err)
            }
        }
        
        let url = URL(string: api.urlString + "campgrounds")
        
        if let safeURL = url {
            let task = URLSession.shared.dataTask(with: safeURL, completionHandler: api.handleResponse(data:response:error:))
            task.resume()
            
        } else {
            print("Nonvalid URL")
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campgrounds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "campgroundCell", for: indexPath) as! CampgroundCellTableViewCell
        
        let campground = campgrounds[indexPath.row]
        
        cell.setAttributes(campground: campground)
        
        cell.delegate = self

        return cell
    }
    
    // Cell Delegate
    func campgroundPressed(campground: CampgroundProtocol) {
        
        if setCampground == nil {
            if let campgroundObject = campground as? CampgroundObject {
                setCampground = campgroundObject
                performSegue(withIdentifier: "showCampgroundFromCampgrounds", sender: self.self)
            }
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let campgroundVC = segue.destination as? CampgroundVC {
            campgroundVC.campgroundID = setCampground!._id
            setCampground = nil
        }
        
    }

}
