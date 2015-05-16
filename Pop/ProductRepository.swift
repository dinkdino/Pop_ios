//
//  ProductRepository.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 01/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import Foundation
import CoreData

extension Product {
    
    class func storeProductsFromJson(productsJson: [NSDictionary], managedObjectContext: NSManagedObjectContext) -> [Product] {
        let products: [Product] = productsJson.map {
            let entity = NSEntityDescription.entityForName("Product", inManagedObjectContext: managedObjectContext)!
            let product = Product(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
            
            product.name = ($0["name"] ?? "") as! String;
            product.desc = ($0["description"] ?? "") as! String;
            product.price = ($0["price"] ?? 0.0) as! NSNumber;
            product.quantity = ($0["quantity"] ?? 1) as! NSNumber;
            
            return product
        }
        
        return products
    }
}
