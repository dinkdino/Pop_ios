//
//  ProductsService.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 01/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

/// Network interface for Products
class ProductsService {
    
    let managedObjectContext: NSManagedObjectContext!
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    /**
        Gets a list of products
    
        :param: page The page number
        :param: perPage Number of products to get for each page

        :returns: Array of Products for a page
    */
    func fetchProductsForPage(page: Int = 1, perPage: Int = 10, successHandler: ([Product]) -> Void, failureHandler: (String) -> Void) {
     
        Alamofire.request(ProductRouter.Products(page: page, perPage: perPage)).validate().responseJSON() {
            (_, _, JSON, error) in
            
            if error == nil {
                
                let productsJson = ((JSON as! NSDictionary)
                    .valueForKey("data") as! NSDictionary)
                    .valueForKey("products") as! [NSDictionary]
                
                let products = Product.storeProductsFromJson(productsJson, managedObjectContext: self.managedObjectContext)
                
                successHandler(products)
            } else {
                println("Failed to fetch products. Error: \(error)")
                failureHandler(error!.description)
            }
        }
        
    }
    
    func createProduct(product: NSDictionary, successHandler: () -> (), failureHandler: (String) -> Void) {
        let request = Alamofire.request(ProductRouter.CreateProduct(product: product)).validate().responseJSON() {
            (request, _, JSON, error) in
            
                println(JSON)
            if error == nil {
                successHandler()
            } else {
                failureHandler(error!.description)
            }
            
        }
        
    }
    
    func setProductLikeStatusTo(liked: Bool, forProduct product: Product, successHandler:() -> (), failureHandler: (String) -> Void) {
        
    }
    
}