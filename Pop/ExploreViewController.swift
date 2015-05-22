//
//  ExploreViewController.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 21/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import UIKit
import CoreData

class ExploreViewController: UIViewController {

    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var sidebarButton: UIBarButtonItem!
    
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
        
        if self.revealViewController() != nil {
            sidebarButton.target = self.revealViewController()
            sidebarButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
