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
            
            product.desc = ($0["description"] ?? "") as! String;
            product.price = ($0["price"] ?? 0.0) as! NSNumber;
            
            var images = NSMutableOrderedSet()
            
            if let imagesList = $0["images"] as? [String] {
                for imageLink in imagesList {
                    let imageEntity = NSEntityDescription.entityForName("ProductImages", inManagedObjectContext: managedObjectContext)!
                    let productImage = ProductImages(entity: imageEntity, insertIntoManagedObjectContext: managedObjectContext)
                    productImage.name = imageLink
                    productImage.product = product
                    images.addObject(productImage)
                }
            }
            
            product.images = images.copy() as! NSOrderedSet
            
            return product
        }
        
        return products
    }
}
