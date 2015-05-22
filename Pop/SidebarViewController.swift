//
//  SidebarViewController.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 21/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import UIKit
import CoreData

class SidebarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Outlets
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    //---------
    
    var managedObjectContext: NSManagedObjectContext!

    let menuItems = [
            [ "name": "Home", "icon": "homeIcon"],
            [ "name": "Explore", "icon": "exploreIcon"],
            [ "name": "Sell", "icon": "sellIcon"]
        ]
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        baseInit()
    }
    
    func baseInit() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseId = "sidebarCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseId, forIndexPath: indexPath) as! SidebarTableViewCell
        
        cell.titleLabel.text = menuItems[indexPath.row]["name"]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedItem = self.menuItems[indexPath.row]
        
        
        switch selectedItem["name"]! {
        case "Home":
            performSegueWithIdentifier("homeSegue", sender: nil)
        case "Explore":
            performSegueWithIdentifier("exploreSegue", sender: nil)
        case "Sell":
            performSegueWithIdentifier("sellSegue", sender: nil)
        default:
            return
        }
        
    }
    
}
