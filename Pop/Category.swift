//
//  Category.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 16/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var attributes: NSOrderedSet
    @NSManaged var children: NSOrderedSet
    @NSManaged var parent: Category
    @NSManaged var products: NSOrderedSet

}
