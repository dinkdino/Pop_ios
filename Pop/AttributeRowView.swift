//
//  AttributeRow.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 08/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class AttributeRowView: UIControl {
    
    var attribute: Attribute!
    
    var attributeLabel: UILabel!
    var attributeValueLabel: UILabel!
    
    var selectedValueId: NSNumber?
    
    let margin: CGFloat = 16
    
    var valuesPicker: ActionSheetStringPicker!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseInit()
    }
    
    func baseInit() {
        
        // Attribute label
        attributeLabel = UILabel()
        attributeLabel.font = UIFont(name: "Helvetica-Neue", size: 14)
        attributeLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(attributeLabel)
        
        // Attribute value
        attributeValueLabel = UILabel()
        attributeValueLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        attributeValueLabel.font = UIFont(name: "Helvetica-Neue", size: 14)
        addSubview(attributeValueLabel)
        
        
        self.addTarget(self, action: "pickValue", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        var names = (attribute.values.array as! [AttributeValue]).map { return $0.name }
        valuesPicker = ActionSheetStringPicker(title: attribute.name, rows: names , initialSelection: 0, doneBlock: { (picker, selectedIndex, _) -> Void in
            self.attributeValueLabel.text = (self.attribute.values.objectAtIndex(selectedIndex) as! AttributeValue).name
            self.selectedValueId = (self.attribute.values.objectAtIndex(selectedIndex) as! AttributeValue).id
            }, cancelBlock: nil, origin: self.superview)
        
        
        setupConstraints()
    }
    
    func pickValue() {
        valuesPicker.showActionSheetPicker()
    }
    
    func setupConstraints() {
        
        // Attribute Label
        attributeLabel.snp_updateConstraints { (make) -> Void in
            make.leading.equalTo(self.snp_leading).offset(self.margin)
            make.width.equalTo(self.snp_width).multipliedBy(0.5)
            make.centerY.equalTo(self)
        }
        
        // AttributeValue Label
        attributeValueLabel.snp_updateConstraints { (make) -> Void in
            make.leading.equalTo(attributeLabel.snp_trailing).offset(self.margin)
            make.trailing.equalTo(self.snp_trailing).offset(-self.margin)
            make.centerY.equalTo(self)
        }
    }
}
