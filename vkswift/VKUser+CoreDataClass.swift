//
//  VKUser+CoreDataClass.swift
//  vkswift
//
//  Created by Admin on 15.11.16.
//  Copyright © 2016 mcat345. All rights reserved.
//

import Foundation
import CoreData

@objc(VKUser)
public class VKUser: NSManagedObject {
    
    class func postWithUserInfo(userInfo:AZUser, inManagedObjectContext context:NSManagedObjectContext) -> VKUser?
    {
        
        let request : NSFetchRequest<VKUser> = VKUser.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", userInfo.id!)
        
        if let user = (try? context.fetch(request))?.first  {
            return user
        } else  {
            let user = VKUser(context:context)
            user.id = Int32(userInfo.id!)
            user.firstName = userInfo.firstName
            return user
        }
    }


}
