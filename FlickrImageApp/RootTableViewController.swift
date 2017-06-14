//
//  RootTableViewController.swift
//  FlickrImageApp
//
//  Created by radhakrishnan S on 14/06/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

let cellReusableIdentifier = "resuableiddentifier"
class RootTableViewController: UITableViewController {
    var searchController : ViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSearchIcon()
        self.navigationItem.title = "Flickr Search"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReusableIdentifier)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func showSearchIcon (){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem (barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(RootTableViewController.showSearchBar))
    }
    func showSearchBar(){
        let searchbar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-20, height: 44))
        searchbar.placeholder = "Search Photos"
        searchbar.showsCancelButton =  true
        searchbar.delegate = self
        let barButtonItem = UIBarButtonItem(customView: searchbar)
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recentSearchTerm : String = RecentSearchHelper.sharedInstance.fetchRecentSearches()[indexPath.row]
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReusableIdentifier)!
        cell.textLabel?.text = recentSearchTerm
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentSearchHelper.sharedInstance.fetchRecentSearches().count;
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recentSearchTerm : String = RecentSearchHelper.sharedInstance.fetchRecentSearches()[indexPath.row]
        self.showSearchResults(searchTerm: recentSearchTerm)
    }
    
}

extension RootTableViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        if let text = searchBar.text {
            RecentSearchHelper.sharedInstance.addRecentSearchText(searchText: text)
            self.tableView.reloadData()
            self.showSearchResults(searchTerm: text)
            //self.searchPhoto(withText: text)
            
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        self.showSearchIcon()
    }
    func showSearchResults(searchTerm: String){
        if searchController == nil {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            self.searchController  = storyBoard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
            self.navigationController?.navigationBar.topItem?.title = "Search"
        }
        
        self.searchController?.searchTerm = searchTerm
        self.navigationController?.pushViewController(self.searchController!, animated: true)
    }
}
