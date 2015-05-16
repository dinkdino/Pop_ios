//
//  CategoriesListViewController.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 06/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import UIKit

protocol CategoriesListViewControllerDelegate {
    func selectedCategory(category: Category)
}

class CategoriesListViewController: UITableViewController {
    
    var categories = [Category]()
    
    var delegate: CategoriesListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("categoriesCell") as! UITableViewCell
        
        let currentItem = categories[indexPath.row]
        
        cell.textLabel?.text = currentItem.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentItem = categories[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        if currentItem.children.count > 0 {
            let categoriesController = storyboard.instantiateViewControllerWithIdentifier("categoriesListViewController") as! CategoriesListViewController
            categoriesController.delegate = delegate
            categoriesController.categories = currentItem.children.allObjects as! [Category]
            
            self.navigationController?.pushViewController(categoriesController, animated: true)
        } else {
            delegate?.selectedCategory(currentItem)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
    }
}
