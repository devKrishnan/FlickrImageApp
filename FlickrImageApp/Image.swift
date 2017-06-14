//
//  Image.swift
//  FlickrImageApp
//
//  Created by radhakrishnan S on 14/06/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class Image: NSObject {
    var farm:NSNumber?
    var title:String?
    var server:String?
    var secret:String?
    var imageId:String?
    var url: String?{
        if let _farm = farm, let _server = server, let _imageId = imageId, let _secret = secret  {
            return String("http://farm\(_farm.stringValue).staticflickr.com/\(_server)/\(_imageId)_\(_secret).jpg")
        }
        return nil
    }
    init(imageData:Dictionary<String, Any>?) {
        farm = imageData?["farm"] as? NSNumber
        title = imageData?["title"] as? String
        server = imageData?["server"] as? String
        secret = imageData?["secret"] as? String
        imageId = imageData?["id"] as? String
        
    }
}
