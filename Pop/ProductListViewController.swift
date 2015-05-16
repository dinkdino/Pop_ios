//
//  ViewController.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 30/04/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import UIKit
import CoreData

class ProductListViewController: UIViewController {

    var managedObjectContext: NSManagedObjectContext!
    var service: ProductsService!
    
    var products = [Product]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service = ProductsService(managedObjectContext: self.managedObjectContext)
        service.fetchProductsForPage(page: 1, perPage: 10, successHandler: { (products: [Product]) -> Void in
            self.products = products
            self.tableView.reloadData()
        }, failureHandler: { (message: String) in
                
        })
    }
    

}

// MARK: TableView

extension ProductListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("productListCell") as! ProductListTableViewCell
        
        let product = products[indexPath.row]
        
        cell.nameLabel.text = product.name
        
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        cell.priceLabel.text = currencyFormatter.stringFromNumber(product.price)
        
        
        // Shadow
        cell.bottomView.layer.shadowOpacity = 0.25;
        cell.bottomView.layer.shadowRadius = 3.0;
        cell.bottomView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.bottomView.layer.shadowColor = UIColor.blackColor().CGColor
        
        return cell
    }
    
}

