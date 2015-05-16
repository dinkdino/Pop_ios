//
//  AttributedProductView.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 08/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import UIKit
import SnapKit

class AttributedProductView: UIView {
    
    var attributes = [Attribute]() {
        didSet {
            setupViews()
        }
    }
    
    var selectedAttributeValues = [Attribute : AttributeValue]()
    var quantity = 1
    
    // View props
    let rowHeight: CGFloat = 30
    let margin: CGFloat = 0
    
    // Views
    var attributeRows = [AttributeRowView]()
    var quantityRow = QuantityRowView()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
        
        //bounds = self.superview!.bounds
    }
    
    private func setupViews() {
        
        
        var previousRow: AttributeRowView?
        for attribute in attributes {
            let row = AttributeRowView()
            row.attribute = attribute
            addSubview(row)
            row.attributeLabel.text = attribute.name
            row.attributeValueLabel.text = "Select"
            
            attributeRows.append(row)
            setupRowConstraint(row, previousRow: previousRow)
            previousRow = row
        }
        
        addSubview(quantityRow)
        quantityRow.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(self.snp_leading).offset(self.margin)
            make.trailing.equalTo(self.snp_trailing).offset(self.margin)
            make.height.equalTo(rowHeight)
            
            if let previousRow = previousRow {
                make.top.equalTo(previousRow.snp_bottom).offset(self.margin)
            } else {
                make.top.equalTo(self.snp_top).offset(self.margin)
            }
        }
        
        println(self.subviews.count)
    }
    
    private func setupRowConstraint(row: AttributeRowView, previousRow: AttributeRowView?) {
        
        row.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(self.snp_leading).offset(self.margin)
            make.trailing.equalTo(self.snp_trailing).offset(self.margin)
            make.height.equalTo(rowHeight)
            
            if let previousRow = previousRow {
                make.top.equalTo(previousRow.snp_bottom).offset(self.margin)
            } else {
                make.top.equalTo(self.snp_top).offset(self.margin)
            }
        }
    }

}

