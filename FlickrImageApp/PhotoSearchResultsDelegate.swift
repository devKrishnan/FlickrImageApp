//
//  PhotoSearchResultsDelegate.swift
//  FlickrImageApp
//
//  Created by radhakrishnan S on 14/06/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import SDWebImage
import os.log

class PhotoSearchResultsDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var delegate : PhotoSearchPagination!
    var imageResults:[Image] = []
    var currentPage : Int = 1
    var total : Int? = nil
    let apiKey = "105a8cfd5143911caa4e91a1ed6d55ed"
    let pageSize = 30
    var searchText = "" {
        didSet {
            self.currentPage = 1
            self.total = nil
            self.imageResults = []
            
            self.initiateSearch(searchText: searchText, apiKey: self.apiKey, pageSize: self.pageSize, currentPage: self.currentPage)
        }
    }
    var photoFetchTask : URLSessionDataTask?
    let defaultSession : URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageResults.count > 0 ? ( self.imageResults.count == total ? self.imageResults.count : self.imageResults.count + 3 ):  0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row <  self.imageResults.count {
            let  cell : ImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            let imageData = self.imageResults[indexPath.row]
            if let url = imageData.url {
                cell.imageView.sd_setImage(with: URL(string:url) , placeholderImage: UIImage(named: "placeholder"))
            }
            return cell
        }else{
            let  cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath)
            self.fetchNextPagePhotos()
            return cell
            
        }
        
        
        //Support cache using NSCache or SDWebImageCache
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = UIScreen.main.bounds.width
        return CGSize(width: (width-20)/4, height: (width-20)/4)
    }
    
    
    func fetchNextPagePhotos(){
        self.currentPage += 1
        if self.currentPage <= (self.total)!  {
            self.initiateSearch(searchText: searchText, apiKey: self.apiKey, pageSize: self.pageSize, currentPage: self.currentPage)
        }else{
            self.currentPage = 1;
            print("")
        }
    }
    func initiateSearch(searchText:String?,apiKey:String, pageSize:Int, currentPage:Int){
        let failureBlock : ()->Void = {
            if currentPage == 1 {
                self.total = nil
            }
            self.currentPage -= 1
            DispatchQueue.main.async{
                self.delegate.showErrorMessage(title: "Photo fetch", message: "Oops! The search failed")
            }
        }
        if let text  = searchText {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let searchTerm = text.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
            if let url = self.urlWithSearchTerm(searchTerm: searchTerm, apiKey: apiKey, pageSize: pageSize, currentPage: currentPage){
                self.photoFetchTask = self.defaultSession.dataTask(with: url, completionHandler: { (data:Data?, response:URLResponse?, error:Error?) in
                    DispatchQueue.main.async{
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    if let data = data{
                        if let (pages,imageResults) = self.photos(data:data){
                            self.imageResults += imageResults
                            self.total = pages
                            DispatchQueue.main.async{
                                self.delegate.reloadData()
                            }
                        }else{
                            failureBlock()
                        }
                    }
                    else{
                        failureBlock()
                        os_log("error = %@", (error?.localizedDescription)!)
                        
                    }
                })
                self.photoFetchTask?.resume()
            }
            //TODO:-HANDLE ERROR CASE WITH ALERT
            
            
        }
    }
    func urlWithSearchTerm(searchTerm:String?,apiKey:String, pageSize:Int, currentPage:Int)->URL?{
        if let queryText = searchTerm {
            
            let urlString = String("https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(queryText)&per_page=\(pageSize)&page=\(currentPage)&format=json&nojsoncallback=1")
            if let _urlString = urlString {
                return URL(string: _urlString)
            }
        }
        return nil
    }
    
    func photos(data:Data)->(Int,[Image])?{
        do{
            
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            if let responseData = dictionary {
                let photos =  responseData["photos"] as? [String:Any]
                let pages = photos?["pages"] as? NSNumber
                let photoList =  photos?["photo"]
                var list:[Image] = []
                for item in (photoList as? [[String:AnyObject]])!{
                    let image:Image = Image(imageData: item )
                    list.append(image)
                }
                if let pageCount = pages  {
                    let result = (pageCount.intValue,list)
                    return result
                }
                
            }
            return nil
            
        }catch {
            //Handling Exception
            return nil
        }
        
    }
    
}

