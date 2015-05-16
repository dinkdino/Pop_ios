//
//  Attribute.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 08/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import Foundation
import CoreData

class Attribute: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var category: NSSet
    @NSManaged var values: NSSet

}
