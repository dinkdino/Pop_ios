//
//  ProductListTableViewCell.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 01/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import UIKit

protocol ProductListTableViewCellDelegate {
    func likeButtonStateChangedForCell(cell: ProductListTableViewCell, selected: Bool)
}


class ProductListTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var likeButton: UIButton!
    
    var delegate: ProductListTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        baseInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func baseInit() {
        likeButton.setImage(UIImage(named: "likeIcon"), forState: UIControlState.Normal)
        likeButton.setImage(UIImage(named: "likeSelectedIcon"), forState: UIControlState.Selected)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int(floor(scrollView.contentOffset.x / pageWidth))
        
        pageControl.currentPage = currentPage
    }
    
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        self.toggleLikeStatus()
        self.delegate?.likeButtonStateChangedForCell(self, selected: likeButton.selected)
    }
    
    func toggleLikeStatus() {
        likeButton.selected = !likeButton.selected
    }
}
