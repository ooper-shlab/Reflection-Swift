//
//  SliderCell.swift
//  Reflection
//
//  Translated by OOPer in cooperation with shlab.jp, on 2015/9/28.
//
//
/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:
 UITableViewCell to host a slider, its label and value.
 */

import UIKit

let kSliderTag = 1337

@objc(SliderCell)
class SliderCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value1, reuseIdentifier: reuseIdentifier)
        // Label for type of slider
        self.textLabel!.backgroundColor = UIColor.clearColor()
        self.textLabel!.font = UIFont.boldSystemFontOfSize(14.0)
        self.textLabel!.textColor = UIColor.blackColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        // Slider
        let slider =
        UISlider(frame: CGRectMake(self.contentView.bounds.origin.x + 55.0, 0.0,
            self.contentView.bounds.size.width - 110.0, 40.0))
        slider.continuous = true
        slider.tag = kSliderTag
        self.contentView.addSubview(slider)
        
        // Label for slider values
        self.detailTextLabel!.backgroundColor = UIColor.clearColor()
        self.detailTextLabel!.font = UIFont.boldSystemFontOfSize(12.0)
        self.detailTextLabel!.textColor = UIColor.blackColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}