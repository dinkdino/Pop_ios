//
//  Product.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 01/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import Foundation
import CoreData

class Product: NSManagedObject {

    @NSManaged var desc: String
    @NSManaged var name: String
    @NSManaged var price: NSNumber
    @NSManaged var quantity: NSNumber

}
