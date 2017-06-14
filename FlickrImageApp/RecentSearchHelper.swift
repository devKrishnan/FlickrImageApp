//
//  RecentSearchHelper.swift
//  FlickrImageApp
//
//  Created by radhakrishnan S on 14/06/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

let maxSize = 5
class RecentSearchHelper: NSObject {
    static let sharedInstance = RecentSearchHelper()
    private override init() {}
    //we can use set here, the
    var searchTerms  = [String]()
    func addRecentSearchText(searchText: String?){
        
        if let text = searchText   {
            searchTerms.insert(text, at: 0)
        }
        if searchTerms.count > maxSize {
            searchTerms.removeLast()
        }
    }
    func fetchRecentSearches()->[String]{
        return searchTerms
    }
}

