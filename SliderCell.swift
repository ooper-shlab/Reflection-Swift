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
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        // Label for type of slider
        self.textLabel!.backgroundColor = UIColor.clear
        self.textLabel!.font = UIFont.boldSystemFont(ofSize: 14.0)
        self.textLabel!.textColor = UIColor.black
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        // Slider
        let slider =
        UISlider(frame: CGRect(x: self.contentView.bounds.origin.x + 55.0, y: 0.0,
            width: self.contentView.bounds.size.width - 110.0, height: 40.0))
        slider.isContinuous = true
        slider.tag = kSliderTag
        self.contentView.addSubview(slider)
        
        // Label for slider values
        self.detailTextLabel!.backgroundColor = UIColor.clear
        self.detailTextLabel!.font = UIFont.boldSystemFont(ofSize: 12.0)
        self.detailTextLabel!.textColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
