//
//  QuantityRowView.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 08/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import UIKit

class QuantityRowView: UIView {
    
    var quantity = 1
    
    var quantityLabel: UILabel!
    var quantityTextField: UITextField!
    
    let margin: CGFloat = 16
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseInit()
    }
    
    func baseInit() {
        
        // Quantity label
        quantityLabel = UILabel()
        quantityLabel.text = "Quantity"
        quantityLabel.font = UIFont(name: "Helvetica-Neue", size: 14)
        quantityLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(quantityLabel)
        
        // Quantity Textfield
        quantityTextField = UITextField()
        quantityTextField.text = "\(quantity)"
        quantityTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        quantityTextField.font = UIFont(name: "Helvetica-Neue", size: 14)
        addSubview(quantityTextField)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupConstraints()
    }
    
    
    func setupConstraints() {
        
        // Quantity Label
        quantityLabel.snp_updateConstraints { (make) -> Void in
            make.leading.equalTo(self.snp_leading).offset(self.margin)
            make.width.equalTo(self.snp_width).multipliedBy(0.5)
            make.centerY.equalTo(self)
        }
        
        // Quantity Textfield
        quantityTextField.snp_updateConstraints { (make) -> Void in
            make.leading.equalTo(quantityLabel.snp_trailing).offset(self.margin)
            make.trailing.equalTo(self.snp_trailing).offset(-self.margin)
            make.centerY.equalTo(self)
        }
    }
}