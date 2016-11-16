//
//  VKPost+CoreDataClass.swift
//  vkswift
//
//  Created by Admin on 15.11.16.
//  Copyright © 2016 mcat345. All rights reserved.
//

import Foundation
import CoreData

@objc(VKPost)
public class VKPost: NSManagedObject {
    
    class func postWithUserInfo(postInfo:AZPost, inManagedObjectContext context:NSManagedObjectContext) -> VKPost?
    {
        
        let request : NSFetchRequest<VKPost> = VKPost.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", postInfo.postID!)
        
        if let post = (try? context.fetch(request))?.first  {
            return post
        } else  {
            let post = VKPost(context:context)
            post.id = Int32(postInfo.postID!)
            post.text = postInfo.text
            return post
        }
    }
}
