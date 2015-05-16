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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                attributedProductView.attributes = selectedCategory.attributes.allObjects as! [Attribute]
                
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
        println("Description: \(self.descriptionTextView.text)")
        println("Price: ₹\(self.priceTextField.text)")
        println("Location: \(self.locationLabel.text)")
        println("Images -----")
        for imagePicker in imagePickers {
            println("Image: \(imagePicker.image)")
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