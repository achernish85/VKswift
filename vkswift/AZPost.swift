//
//  AZPost.swift
//  vkswift
//
//  Created by Admin on 13.11.16.
//  Copyright © 2016 mcat345. All rights reserved.
//

import Foundation

import Foundation
import SwiftyJSON

class AZPost: AZServerObject {
    
    var text: String?
    var fromID: Int?
    var postID: Int?
    var fromUser: AZUser?
    var postDate: Double?
    var postImageURL: String?
    var postImageWidth: Int?
    var postImageHeight: Int?
    
    override init(withResponseDictionary dictionary: [String : AnyObject]) {
        self.text = dictionary["text"] as? String
        self.fromID = dictionary["from_id"] as? Int
        self.postID = dictionary["id"] as? Int
        self.postDate = dictionary["date"] as? Double
        let dict = dictionary["attachments"]?.object(at: 0) as? [String : AnyObject]
        self.postImageURL = dict?["photo"]?["photo_75"] as? String
        self.postImageHeight = dict?["photo"]?["height"] as? Int
        self.postImageWidth = dict?["photo"]?["width"] as? Int
        
        super.init(withResponseDictionary: dictionary)
        
    }
    
    
}
