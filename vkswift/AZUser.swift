//
//  AZUser.swift
//  vkswift
//
//  Created by Admin on 13.11.16.
//  Copyright © 2016 mcat345. All rights reserved.
//

import Foundation
import SwiftyJSON

class AZUser: AZServerObject {
    
    var id : Int?
    var firstName : String?
    var lastName : String?
    var imageURL : NSURL?
    var city: String?
    var site: String?
    
    override init(withResponseDictionary dictionary: [String : AnyObject]) {
        self.firstName = dictionary["first_name"] as? String
        self.lastName = dictionary["last_name"] as? String
        self.city = dictionary["city"]?["title"] as? String
        self.id =  dictionary["id"] as? Int
        if let site = dictionary["site"] as? String {
            let stringArray = site.components(separatedBy:"://")
            self.site = stringArray.last
        }
        if let urlString = dictionary["photo_50"] as? String {
            self.imageURL = NSURL(string: urlString)
        }
        super.init(withResponseDictionary: dictionary)
    }
}
