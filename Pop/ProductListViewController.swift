//
//  ViewController.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 30/04/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class ProductListViewController: UIViewController {

    var managedObjectContext: NSManagedObjectContext!
    var service: ProductsService!
    
    var products = [Product]()

    @IBOutlet weak var tableView: UITableView!
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
        }
        
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
        
        cell.delegate = self
        cell.imagesScrollView.delegate = cell
        
        cell.nameLabel.text = product.desc
        
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        cell.priceLabel.text = currencyFormatter.stringFromNumber(product.price)
        
        var imageCount = 0
        
        cell.imagesScrollView.subviews.map({ $0.removeFromSuperview() })
        for productImage in product.images {
            Alamofire.request(.GET, productImage.name!)
                .response { (request, response, data, error) in
                    if data == nil {
                        return
                    }
                    
                    let imageView = UIImageView(image: UIImage(data: data as! NSData))
                    imageView.frame = CGRect(x: cell.imagesScrollView.frame.width * CGFloat(imageCount), y: 0, width: cell.imagesScrollView.frame.width, height: cell.imagesScrollView.frame.height)
                    cell.imagesScrollView.addSubview(imageView)
                    
                    imageCount++
                    cell.imagesScrollView.contentSize.width = cell.imagesScrollView.frame.width * CGFloat(imageCount)
                    cell.pageControl.numberOfPages = imageCount
            }
        }
        
        cell.pageControl.currentPage = 1
        
        
        // Shadow
        cell.bottomView.layer.shadowOpacity = 0.25;
        cell.bottomView.layer.shadowRadius = 3.0;
        cell.bottomView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.bottomView.layer.shadowColor = UIColor.blackColor().CGColor
        
        return cell
    }
    
    
}

extension ProductListViewController: ProductListTableViewCellDelegate {
    
    func likeButtonStateChangedForCell(cell: ProductListTableViewCell, selected: Bool) {
        let indexPath = tableView.indexPathForCell(cell)
        
        if let indexPath = indexPath {
            let product = products[indexPath.row]
            
            service.setProductLikeStatusTo(selected, forProduct: product, successHandler: { () -> () in
            }, failureHandler: { (message) -> Void in
                cell.toggleLikeStatus()
                println("Failed to update like status. Error: \(message)")
            })
        }
    }
}



