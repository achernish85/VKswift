//
//  MOCExtensions.swift
//  vkswift
//
//  Created by Admin on 14.11.16.
//  Copyright © 2016 mcat345. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    public func saveThrows() {
        if self.hasChanges {
            do {
                try save()
            } catch let error {
                let nserror = error as NSError
                print("Core Data Error: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
