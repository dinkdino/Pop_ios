//
//  Product.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 21/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import Foundation
import CoreData

class Product: NSManagedObject {

    @NSManaged var desc: String
    @NSManaged var id: NSNumber
    @NSManaged var price: NSNumber
    @NSManaged var attributeValues: NSSet
    @NSManaged var category: Category
    @NSManaged var images: NSOrderedSet

}
