//
//  SearchVC.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/28/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CampgroundCellDelegate {
    
    //MARK: - Setup
    
    // IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // Campground array
    var campgrounds: [CampgroundObject] = []
    var sendCampgroundID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
    }
    
    //MARK: - Search Bar Methods
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil && searchBar.text != "" {
            startSearch(searchString: searchBar.text!)
            searchBar.placeholder = "Search Campgrounds..."
        } else {
            searchBar.placeholder = "Enter Something!"
        }
    }
    
    //MARK: - Search Request
    func startSearch(searchString search: String) {
        loadingIndicator.startAnimating()
        searchBar.isHidden = true
        let searchAPI = API(successFunc: { (data) in
            do {
                let decoder = JSONDecoder()
                let campgroundsResponse = try decoder.decode(CampgroundsResponseObject.self, from: data)
                if campgroundsResponse.type == "campgrounds" {
                    
                }
            } catch {
                self.searchFailed(error: nil)
            }
        }, failureFunc: self.searchFailed(error:))
        let task = URLSession.shared.dataTask(with: URL(string: API.shared.urlString + "/search?q=\(search)")!, completionHandler: searchAPI.handleResponse(data:response:error:))
        task.resume()
    }
    
    func searchFailed(error: Error?){
        self.loadingIndicator.stopAnimating()
        self.searchBar.text = ""
        let alert = UIAlertController(title: "Search Failed", message: "Either the app or the server failed to complete the search", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Table View methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campgrounds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "campgroundCell", for: indexPath) as! CampgroundCellTableViewCell
        
        let campground = campgrounds[indexPath.row]
        
        cell.setAttributes(campground: campground)
        
        cell.delegate = self

        return cell
    }
    
    // When a cell is pressed
    func campgroundPressed(campground: CampgroundProtocol) {
        sendCampgroundID = campground._id
        performSegue(withIdentifier: "showCampgroundFromSearch", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let campgroundVC = segue.destination as? CampgroundVC {
            campgroundVC.campgroundID = sendCampgroundID!
        }
    }
    
}
