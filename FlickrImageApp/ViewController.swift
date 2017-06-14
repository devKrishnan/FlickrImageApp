//
//  ViewController.swift
//  FlickrImageApp
//
//  Created by radhakrishnan S on 14/06/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

import os.log

protocol PhotoSearchPagination {
    func reloadData() -> Void
    func showErrorMessage(title:String,message:String)
}

class ViewController: UIViewController {
    
    var searchTerm : String! {
        didSet {
            self.delegate?.searchText = searchTerm
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    var delegate : PhotoSearchResultsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = PhotoSearchResultsDelegate()
        self.delegate?.delegate = self
        self.delegate?.searchText = self.searchTerm
        self.searchResultsCollectionView.delegate = self.delegate
        self.searchResultsCollectionView.dataSource = self.delegate
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = self.searchTerm
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: UISearchBarDelegate,PhotoSearchPagination{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            
            self.delegate?.searchText = text
            
        }
    }
    func showErrorMessage(title:String,message:String){
        let alertController : UIAlertController = UIAlertController(title: title    , message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    func reloadData() -> Void {
        self.searchResultsCollectionView.reloadData()
    }
    
}

