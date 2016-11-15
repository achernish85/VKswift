//
//  VKUser+CoreDataProperties.swift
//  vkswift
//
//  Created by Admin on 15.11.16.
//  Copyright © 2016 mcat345. All rights reserved.
//

import Foundation
import CoreData


extension VKUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VKUser> {
        return NSFetchRequest<VKUser>(entityName: "VKUser");
    }

    @NSManaged public var firstName: NSObject?
    @NSManaged public var post: NSSet?

}

// MARK: Generated accessors for post
extension VKUser {

    @objc(addPostObject:)
    @NSManaged public func addToPost(_ value: VKPost)

    @objc(removePostObject:)
    @NSManaged public func removeFromPost(_ value: VKPost)

    @objc(addPost:)
    @NSManaged public func addToPost(_ values: NSSet)

    @objc(removePost:)
    @NSManaged public func removeFromPost(_ values: NSSet)

}
