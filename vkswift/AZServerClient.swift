//
//  AZServerClient.swift
//  vkswift
//
//  Created by Admin on 13.11.16.
//  Copyright © 2016 mcat345. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class AZServerClient {
    
    static let manager = AZServerClient()
    
    //VK.com users.get request https://api.vk.com/method/METHOD_NAME?PARAMETERS&access_token=ACCESS_TOKEN&v=V
    
    func getUser(userID: String, onSuccess:@escaping (AZUser) -> Void) {
        
        let params : [String : String] = ["user_id" : userID,
                                             "name_case" : "nom",
                                             "fields" :"photo_50,city,site",
                                             "v" : "5.58"]
        
        request("https://api.vk.com/method/users.get", method: .get, parameters: params).responseJSON { response in
            let jsonVK = JSON(response.result.value!).dictionary
            let jsonName = jsonVK!["response"]?.arrayObject
            let usr = AZUser(withResponseDictionary: jsonName?.first as! [String:AnyObject])
            onSuccess(usr)
        }
}

    func getGroupWall(groupID:String, offset: Int,count: Int, onSuccess:@escaping ([AZPost]) -> Void) {
        
        let params : [String : AnyObject] = ["owner_id" : groupID as AnyObject,
                                             "offset" : offset as AnyObject,
                                             "count" : count as AnyObject,
                                             "extended" : 1 as AnyObject,
                                             "v" : 5.58 as AnyObject	]
        
        request("https://api.vk.com/method/wall.get",method: .get ,parameters: params).responseJSON { response in
            var postsArray  = [AZPost]()
            let usersArray : NSMutableArray = []
            let jsonVK = JSON(response.result.value!).dictionary
            let jsonPosts = jsonVK!["response"]?["items"].arrayObject
            let jsonProfiles = jsonVK!["response"]?["profiles"].arrayObject
            for user in jsonProfiles! {
                let user = AZUser(withResponseDictionary: user as! [String : AnyObject])
                usersArray.add(user)
            }
            
            for dict in jsonPosts! {
                let post = AZPost(withResponseDictionary: dict as! [String : AnyObject])
                for users in usersArray  {
                    let user = users as! AZUser
                    //assign user to post
                    if post.fromID! == user.id! {
                        post.fromUser = user
                        postsArray.append(post)
                        
                        break
                    }
                }
            }
            onSuccess(postsArray)
        }
}

}
