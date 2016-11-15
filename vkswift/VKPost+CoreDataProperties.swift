//
//  VKPost+CoreDataProperties.swift
//  vkswift
//
//  Created by Admin on 15.11.16.
//  Copyright © 2016 mcat345. All rights reserved.
//

import Foundation
import CoreData


extension VKPost {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VKPost> {
        return NSFetchRequest<VKPost>(entityName: "VKPost");
    }

    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var user: VKUser?

}
