//
//  File.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 01/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import UIKit
import CoreData
import SnapKit

class SellViewController: UIViewController {
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var sidebarButton: UIBarButtonItem!
    var managedObjectContext: NSManagedObjectContext!
    var currentImagePicker: ImagePickerView?
    
    var categoryService: CategoryService!
    
    var categories = [Category]()
    
    var attributedProductsTableView: UITableView?
    
    @IBOutlet weak var categoryWrapperView: UIView!
    
    @IBOutlet weak var imagesWrapperView: UIView!
    
    var numberOfImages: CGFloat = 4
    
    var imagePickers = [ImagePickerView]()
    
    var categoryWrapperViewHeightConstraint: Constraint? = nil
    var categoryWrapperHeight: CGFloat!
    
    @IBOutlet weak var priceTextField: UITextField!
    var attributedProductViews = [AttributedProductView]()
    
    @IBOutlet weak var descriptionTextView: UITextView!
    let descriptionPlaceholderText = "Write some details about your item and add some #hashtags to make it easier for others to find it."
    
    @IBOutlet weak var locationLabel: UILabel!
    
    var mapTask: MapTask? {
        didSet {
            locationLabel.text = mapTask?.fetchedFormattedAddress ?? "Select product location"
        }
    }
    
    var selectedCategory: Category? {
        didSet {
            
            categoryWrapperHeight = 80
            addAttributedProduct()
        }
    }
    
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
        
        addImagePickers()
        
        categoryService = CategoryService(managedObjectContext: self.managedObjectContext)
        categoryService.fetchCategoriesWithAttributes(successHandler: { (categories) -> () in
            self.categories = categories
        }) { (message) -> () in
            println(message)
        }
        
        categoryWrapperHeight = self.categoryWrapperView.bounds.size.height
        categoryWrapperView.snp_makeConstraints { (make) -> Void in
            self.categoryWrapperViewHeightConstraint = make.height.equalTo(categoryWrapperHeight).constraint
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedCategory = selectedCategory {
            categoryButton.titleLabel?.text = selectedCategory.name
        }
    }
    
    
    func addImagePickers() {
        
        let containerWidth = view.bounds.size.width
        let totalImagesWidth = containerWidth * 0.8
        let imageSeparator = (containerWidth - totalImagesWidth) / (numberOfImages + 1)
        let eachImageWidth = totalImagesWidth / numberOfImages
        
        var leftConstraintItem = imagesWrapperView.snp_leading
        
        for num in 0..<Int(numberOfImages) {
            let imagePicker = ImagePickerView()
            imagePicker.setTranslatesAutoresizingMaskIntoConstraints(false)
            imagesWrapperView.addSubview(imagePicker)
            imagePickers.append(imagePicker)
            
            imagePicker.snp_makeConstraints({ (make: ConstraintMaker) -> Void in
                make.leading.equalTo(leftConstraintItem).offset(imageSeparator)
                make.centerY.equalTo(imagesWrapperView)
                make.width.equalTo(eachImageWidth)
                make.height.equalTo(eachImageWidth)
            })
            
            leftConstraintItem = imagePicker.snp_trailing
            
            imagePicker.addTarget(self, action: "pickImage:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
    }
    
    func addAttributedProduct() {
        
        for view in attributedProductViews {
            view.removeFromSuperview()
        }
        
        if let selectedCategory = selectedCategory {
            
            
                var attributedProductView = AttributedProductView()
                categoryWrapperView.addSubview(attributedProductView)
                attributedProductViews.removeAll(keepCapacity: false)
            
                attributedProductViews.append(attributedProductView)
                attributedProductView.attributes = selectedCategory.attributes.array as! [Attribute]
                
                let margin = 16
                attributedProductView.snp_makeConstraints({ (make: ConstraintMaker) -> Void in
                    make.leading.equalTo(categoryWrapperView.snp_leading).offset(margin)
                    make.trailing.equalTo(categoryWrapperView.snp_trailing).offset(-margin)
                    make.top.equalTo(categoryButton.snp_bottom).offset(0)
                    make.height.equalTo(attributedProductView.rowHeight * CGFloat(attributedProductView.attributes.count + 1))
                })
                
                let heightOfAttributeViews = getHeightOfAttributeViews()
                
                categoryWrapperView.snp_updateConstraints({ (make: ConstraintMaker) -> Void in
                    make.height.equalTo(heightOfAttributeViews + categoryWrapperHeight)
                })
                
            
        } else {
            
            
                categoryWrapperView.snp_updateConstraints({ (make: ConstraintMaker) -> Void in
                    make.height.equalTo(80)
                })
        }
    }
    
    private func getHeightOfAttributeViews() -> CGFloat {
        var height: CGFloat = 0
        
        for attributedProductView in attributedProductViews {
            height += (CGFloat(attributedProductView.attributes.count) + 1) * attributedProductView.rowHeight
        }
        
        println(height)
        return height
    }
    
    @IBAction func pickImage(imagePicker: ImagePickerView) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        currentImagePicker = imagePicker
        
        let alert = UIAlertController(title: "Select a picture", message: "", preferredStyle:
        UIAlertControllerStyle.ActionSheet)
        
        // Library
        let libraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (alert) -> Void in
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePickerController.allowsEditing = true
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
        
        alert.addAction(libraryAction)
        
        
        // Camera
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            let cameraAction = UIAlertAction(title: "Take a photo", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(imagePickerController, animated: true, completion: nil)
            })
            
            alert.addAction(cameraAction)
        }
        
        
        // Cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (alert) -> Void in
            
        }
        
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        println(self.navigationController)
        if segue.identifier == "categoriesListSegue" {
            let desVC = segue.destinationViewController as! CategoriesListViewController
            desVC.categories = self.categories
            desVC.delegate = self
        } else if segue.identifier == "locationSegue" {
            let desVC = segue.destinationViewController as! MapSearchViewController
            desVC.delegate = self
        }
    }
    
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        var product = [String: AnyObject]()
        product["description"] = descriptionTextView.text
        product["price"] = priceTextField.text
        product["location"] = locationLabel.text
        
        
        // Attributes
        var attributedProducts = [NSDictionary]()
        for attributedProductView in attributedProductViews {
            var attributes = [NSNumber]()
            for attributeRow in attributedProductView.attributeRows {
                if let selectedValue = attributeRow.selectedValueId {
                    attributes.append(selectedValue)
                }
            }
            attributedProducts.append(["attributes": attributes, "quantity": attributedProductView.quantityRow.quantityTextField.text])
        }
        
        product["attributed_products"] = attributedProducts
        
        // Image
        var images = [NSDictionary]()
        var imageCount = 0
        for imagePicker in imagePickers {
            if let image = imagePicker.image {
                let imageData = UIImageJPEGRepresentation(image, 0.9)
                let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
                let imageName = "img\(imageCount)"
                images.append(["name": imageName, "data": base64String])
                imageCount++
            }
        }
        
        product["images"] = images
        
        let productService = ProductsService(managedObjectContext: managedObjectContext)
        productService.createProduct(product, successHandler: { () -> () in
            println("product created successfully")
        }) { (message) -> Void in
            println("Failed to create new product. Error: \(message)")
        }
        
    }
}


// MARK: ImagePicker

extension SellViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        dismissViewControllerAnimated(true, completion: nil)
        self.currentImagePicker!.image = editingInfo[UIImagePickerControllerOriginalImage] as! UIImage
        println("EditingInfo: \(editingInfo)")
    }
}


// MARK: CategoriesListViewControllerDelegate

extension SellViewController: CategoriesListViewControllerDelegate {
    
    func selectedCategory(category: Category) {
        selectedCategory = category
    }
}


// MARK: UITableView

extension SellViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("attCell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "attCell")
        }
        
        cell!.textLabel?.text = "asdasd"
        
        return cell!
    }
}


// MARK: MapSearch

extension SellViewController: MapSearchViewControllerDelegate {
    
    func selectedLocation(mapTask: MapTask) {
        self.mapTask = mapTask
    }
}


// MARK: TextView

extension SellViewController: UITextViewDelegate {
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if descriptionTextView.text == descriptionPlaceholderText {
            descriptionTextView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = descriptionPlaceholderText
        }
    }
}