//
//  AttributesListViewController.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 06/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import UIKit

class AttributesListViewController: UITableViewController {
    
    var attributes: [Attribute]!
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return attributes.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currentItem = attributes[section]
        return currentItem.name
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let attributeValues = attributes[section].values
        return attributeValues.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("attributesCell") as! UITableViewCell
        
        let values = attributes[indexPath.section].values
        let value = values.allObjects[indexPath.row] as! AttributeValue
        
        cell.textLabel?.text = value.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let values = attributes[indexPath.section].values
        let value = values.allObjects[indexPath.row] as! AttributeValue
        println(value.name)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
