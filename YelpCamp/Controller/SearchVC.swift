//
//  SearchVC.swift
//  YelpCamp
//
//  Created by Nathaniel on 11/28/19.
//  Copyright © 2019 Nathaniel Fargo. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    

    // IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    // Campground array
    var campgrounds: [CampgroundObject] = []
    
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
        URLSession.shared.dataTask(with: URL(string: API.shared.urlString + "/search?q=\(search)")!, completionHandler: searchAPI.handleResponse(data:response:error:))
    }
    
    func searchFailed(error: Error?){
        self.loadingIndicator.stopAnimating()
        self.searchBar.text = ""
        let alert = UIAlertController(title: "Search Failed", message: "Either the app or the server failed to complete the search", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Table View methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}
