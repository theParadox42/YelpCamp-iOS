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
    @IBOutlet weak var campgroundTableView: UITableView!
    
    // Campground array
    var campgrounds: [CampgroundObject] = []
    var sendCampgroundID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Search Bar stuff
        searchBar.delegate = self
        
        // Table View Delegate + DataSource
        campgroundTableView.delegate = self
        campgroundTableView.dataSource = self
        
        // Register my campground cell file
        campgroundTableView.register(UINib(nibName: "CampgroundCellTableViewCell", bundle: nil), forCellReuseIdentifier: "campgroundCell")
        
    }
    
    //MARK: - Search Bar Methods
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil && searchBar.text != "" {
            startSearch(searchString: searchBar.text!)
        } else {
            let emptyAlert = UIAlertController(title: "Missing Search", message: "Please enter something before searching", preferredStyle: .alert)
            emptyAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(emptyAlert, animated: true, completion: nil)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    //MARK: - Search Request
    func startSearch(searchString search: String) {
        loadingIndicator.startAnimating()
        let searchAPI = API(successFunc: { (data) in
            do {
                let decoder = JSONDecoder()
                let campgroundsResponse = try decoder.decode(CampgroundsResponseObject.self, from: data)
                if campgroundsResponse.type == "campgrounds" {
                    self.campgrounds = campgroundsResponse.data
                    self.loadingIndicator.stopAnimating()
                    self.campgroundTableView.reloadData()
                    return
                } else {
                    print("Response brought error")
                }
            } catch {
                print("Error decoding response")
            }
            self.searchFailed(error: nil)
        }, failureFunc: self.searchFailed(error:))
        if let searchString = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            print(API.shared.urlString + "campgrounds/search?q=\(searchString)")
            if let safeURL = URL(string: API.shared.urlString + "campgrounds/search?q=\(searchString)") {
                let task = URLSession.shared.dataTask(with: safeURL, completionHandler: searchAPI.handleResponse(data:response:error:))
                task.resume()
                return
            }
        }
        let searchErrorAlert = UIAlertController(title: "Search Error", message: "Couldn't create a search", preferredStyle: .alert)
        searchErrorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(searchErrorAlert, animated: true, completion: nil)
    }
    
    func searchFailed(error: Error?){
        self.loadingIndicator.stopAnimating()
        self.searchBar.text = ""
        let errorAlert = UIAlertController(title: "Search Failed", message: "Either the app or the server failed to complete the search", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
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
