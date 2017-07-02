//
//  MyViewController.swift
//  Reflection
//
//  Translated by OOPer in cooperation with shlab.jp, on 2015/9/28.
//
//
/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:
 Main view controller for displaying the image, reflection and slider table.
 */

import UIKit

@objc(MyViewController)
class MyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var reflectionView: UIImageView!
    @IBOutlet private var slidersTableView: UITableView!
    @IBOutlet private var reflectionViewHeightConstraint: NSLayoutConstraint!
    
    
    //MARK: -
    
    // image reflection
    private let kDefaultReflectionFraction: CGFloat = 0.65
    private let kDefaultReflectionOpacity: CGFloat = 0.40
    
    private let kCellID = "CellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = UIImage(named: "scene.jpg")
        
        self.slidersTableView.register(SliderCell.self, forCellReuseIdentifier: kCellID)
        
        self.slidersTableView.backgroundColor = UIColor.white
        
        self.view.autoresizesSubviews = true
        self.view.isUserInteractionEnabled = true
        
        // determine the size of the reflection to create
        let reflectionHeight = Int(self.imageView.bounds.size.height * kDefaultReflectionFraction)
        
        // create the reflection image and assign it to the UIImageView
        self.reflectionView.image = self.reflectedImage(self.imageView, withHeight: reflectionHeight)
        self.reflectionView.alpha = kDefaultReflectionOpacity
    }
    
    
    //MARK: - slider action methods
    
    @IBAction func sizeSlideAction(_ slider: UISlider) {
        let val = CGFloat(slider.value)
        
        // change the height constraint of our reflected image view
        let reflectionHeight = 180 * val    // 180 is the original maximum height of the reflected image
        self.reflectionViewHeightConstraint.constant = reflectionHeight
        
        // create the reflection image, assign it to the UIImageView and add the image view to the containerView
        self.reflectionView.image = self.reflectedImage(self.imageView, withHeight: Int(reflectionHeight))
        
        // get the alpha slider value, keep it set on the reflection
        let alphaSlider = self.slidersTableView.cellForRow(at: IndexPath(row:1, section:0))!.contentView.viewWithTag(kSliderTag)! as! UISlider
        self.reflectionView.alpha = CGFloat(alphaSlider.value)
        
        let sliderCell = self.slidersTableView.cellForRow(at: IndexPath(row:0, section:0))
        sliderCell!.detailTextLabel!.text = String(format: "%0.2f", Double(val))
    }
    
    @IBAction func alphaSlideAction(_ slider: UISlider) {
        let val = CGFloat(slider.value)
        self.reflectionView.alpha = val
        
        self.slidersTableView.cellForRow(at: IndexPath(row: 1, section: 0))!.detailTextLabel!.text = String(format: "%0.2f", val)
    }
    
    
    //MARK: - Image Reflection
    
    private func CreateGradientImage(_ pixelsWide: Int, _ pixelsHigh: Int) -> CGImage? {
        var theCGImage: CGImage? = nil
        
        // gradient is always black-white and the mask must be in the gray colorspace
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        // create the bitmap context
        let gradientBitmapContext = CGContext(data: nil, width: pixelsWide, height: pixelsHigh,
            bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        
        // define the start and end grayscale values (with the alpha, even though
        // our bitmap context doesn't support alpha the gradient requires it)
        let colors: [CGFloat] = [0.0, 1.0, 1.0, 1.0]
        
        // create the CGGradient and then release the gray color space
        let grayScaleGradient = CGGradient(colorSpace: colorSpace, colorComponents: colors, locations: nil, count: 2)
        
        // create the start and end points for the gradient vector (straight down)
        let gradientStartPoint = CGPoint.zero
        let gradientEndPoint = CGPoint(x: 0, y: CGFloat(pixelsHigh))
        
        // draw the gradient into the gray bitmap context
        gradientBitmapContext?.drawLinearGradient(grayScaleGradient!, start: gradientStartPoint,
            end: gradientEndPoint,  options: CGGradientDrawingOptions.drawsAfterEndLocation)
        
        // convert the context into a CGImageRef and release the context
        theCGImage = gradientBitmapContext?.makeImage()
        
        // return the imageref containing the gradient
        return theCGImage
    }
    
    private func MyCreateBitmapContext(_ pixelsWide: Int, _ pixelsHigh: Int) -> CGContext? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // create the bitmap context
        let bitmapContext = CGContext(data: nil, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8,
            bytesPerRow: 0, space: colorSpace,
            // this will give us an optimal BGRA format for the device:
            bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        return bitmapContext
    }
    
    private func reflectedImage(_ fromImage: UIImageView, withHeight height: NSInteger) -> UIImage? {
        guard height > 0 else {
            return nil
        }
        
        // create a bitmap graphics context the size of the image
        let mainViewContentContext = MyCreateBitmapContext(Int(fromImage.bounds.size.width), height)
        
        // create a 2 bit CGImage containing a gradient that will be used for masking the
        // main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
        // function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
        let gradientMaskImage = CreateGradientImage(1, height)
        
        // create an image by masking the bitmap of the mainView content with the gradient view
        // then release the  pre-masked content bitmap and the gradient bitmap
        mainViewContentContext?.clip(to: CGRect(x: 0.0, y: 0.0, width: fromImage.bounds.size.width, height: CGFloat(height)), mask: gradientMaskImage!)
        
        // In order to grab the part of the image that we want to render, we move the context origin to the
        // height of the image that we want to capture, then we flip the context so that the image draws upside down.
        mainViewContentContext?.translateBy(x: 0.0, y: CGFloat(height))
        mainViewContentContext?.scaleBy(x: 1.0, y: -1.0)
        
        // draw the image into the bitmap context
        mainViewContentContext?.draw(fromImage.image!.cgImage!, in: fromImage.bounds)
        
        // create CGImageRef of the main view bitmap content, and then release that bitmap context
        let reflectionImage = mainViewContentContext?.makeImage()
        
        // convert the finished reflection image to a UIImage
        let theImage = UIImage(cgImage: reflectionImage!)
        
        // image is retained by the property setting above, so we can release the original
        
        return theImage
    }
    
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellID)
        if let slider = cell?.contentView.viewWithTag(kSliderTag) as? UISlider {
            if indexPath.row == 0 {
                cell!.textLabel!.text = "Size"
                slider.value = Float(kDefaultReflectionFraction)
                slider.addTarget(self, action: #selector(MyViewController.sizeSlideAction(_:)), for: .valueChanged)
                cell!.detailTextLabel!.text = String(format: "%0.2f", Double(slider.value))
            } else {
                cell!.textLabel!.text = "Alpha"
                slider.value = Float(kDefaultReflectionOpacity)
                slider.addTarget(self, action: #selector(MyViewController.alphaSlideAction(_:)), for: .valueChanged)
                cell!.detailTextLabel!.text = String(format: "%0.2f", Double(slider.value))
            }
        }
        
        return cell!
    }
    
}
