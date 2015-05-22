//
//  ProductImages.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 16/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import Foundation
import CoreData

class ProductImages: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var product: Product

}
