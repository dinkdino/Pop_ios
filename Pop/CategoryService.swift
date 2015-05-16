//
//  CategoryService.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 06/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import Foundation
import CoreData
import Alamofire


class CategoryService {
    
    let managedObjectContext: NSManagedObjectContext!
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func fetchCategoriesWithAttributes(#successHandler: ([Category]) -> (), failureHandler: (String) -> ()) {
        
        Alamofire.request(CategoryRouter.CategoriesWithAttributes()).validate().responseJSON() {
            (_, _, JSON, error) in
            
            if error == nil {
                
                let categoriesJSON = ((JSON as! NSDictionary)
                                    .valueForKey("data") as! NSDictionary)
                                    .valueForKey("categories") as! [NSDictionary]
                
                let categories = self.parseJSONIntoCategoriesWithAttributes(categoriesJSON)
                
                successHandler(categories)
                
            } else {
                println("Failed to get categories. Error \(error)")
                failureHandler(error!.localizedDescription)
            }
        }
    }
    
    private func parseJSONIntoCategoriesWithAttributes(json: [NSDictionary]) -> [Category] {
        let categories: [Category] = createCategoriesFromJSON(json, withParentCategory: nil)
        return categories
    }
    
    private func createCategoriesFromJSON(json: [NSDictionary], withParentCategory parent: Category?) -> [Category] {
        
        return json.map {
            let entity = NSEntityDescription.entityForName("Category", inManagedObjectContext: self.managedObjectContext)!
            let category = Category(entity: entity, insertIntoManagedObjectContext: nil)
            
            category.id = $0["id"] as! NSNumber
            category.name = ($0["name"] ?? "") as! String
            
            if let parent = parent {
                category.parent = parent
            }
            
            if let subCategories = $0["sub_categories"] as? [NSDictionary] {
                category.children = NSSet(array: self.createCategoriesFromJSON(subCategories, withParentCategory: category))
            }
            
            if let attributes = $0["attributes"] as? [NSDictionary] {
                category.attributes = NSSet(array: self.createAttributesFromJSON(attributes, forCategory: category))
            }
            
            return category
            
        }
    }
    
    private func createAttributesFromJSON(json: [NSDictionary], forCategory category: Category?) -> [Attribute] {
        
        return json.map {
            
            let entity = NSEntityDescription.entityForName("Attribute", inManagedObjectContext: self.managedObjectContext)!
            let attribute = Attribute(entity: entity, insertIntoManagedObjectContext: nil)
            
            attribute.id = $0["id"] as! NSNumber
            attribute.name = $0["name"] as! String
            
            if let category = category {
                var categories = attribute.mutableSetValueForKey("category")
                categories.addObject(category)
            }
            
            if let values = $0["values"] as? [NSDictionary] {
                attribute.values = NSSet(array: self.createAttributeValuesFromJSON(values, forAttribute: attribute))
            }
            
            
            return attribute
        }
    }
    
    private func createAttributeValuesFromJSON(json: [NSDictionary], forAttribute attribute: Attribute) -> [AttributeValue] {
        
        return json.map {
            
            let entity = NSEntityDescription.entityForName("AttributeValue", inManagedObjectContext: self.managedObjectContext)!
            let attributeValue = AttributeValue(entity: entity, insertIntoManagedObjectContext: nil)
            
            attributeValue.id = $0["id"] as! NSNumber
            attributeValue.name = $0["name"] as! String
            
            attributeValue.attribute = attribute
            
            return attributeValue
        }
    }
}