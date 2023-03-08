//
//  CustomTextField.swift
//  CombineTest
//
//  Created by 劉陶恩 on 2023/1/9.
//

import UIKit
//@IBDesignable
class CustomTextField: UITextField {
    
    @IBInspectable var leftImage: UIImage? { didSet { updateImage() }}
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var rightPadding: CGFloat = 0
    @IBInspectable var color: UIColor = UIColor.lightGray {didSet {updateImage()}}
    
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var leftImageRect = super.leftViewRect(forBounds: bounds)
        leftImageRect.origin.x += leftPadding
        return leftImageRect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rightImageRect = super.leftViewRect(forBounds: bounds)
        rightImageRect.origin.x -= rightPadding
        return rightImageRect
    }
    
    func updateImage(){
        if let image = leftImage{
            leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = color
            leftView = imageView
        }else{
            leftViewMode = .never
            leftView = nil
        }
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "",attributes: [NSAttributedString.Key.foregroundColor : color])
    }
}
    
    
    
//    @IBInspectable var leftImage: UIImage? { didSet { updateView() } }
//    @IBInspectable var leftPadding: CGFloat = 0
//    @IBInspectable var rightPadding: CGFloat = 0
//    @IBInspectable var color: UIColor = UIColor.lightGray { didSet { updateView() } }
//
//    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
//        var leftTextRect = super.leftViewRect(forBounds: bounds)
//        leftTextRect.origin.x += leftPadding
//        return leftTextRect
//    }
//
//    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
//        var rightTextRect = super.rightViewRect(forBounds: bounds)
//        rightTextRect.origin.x -= rightPadding
//        return rightTextRect
//    }
//
//    func updateView() {
//        if let image = leftImage {
//            leftViewMode = UITextField.ViewMode.always
//            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//            imageView.contentMode = .scaleAspectFit
//            imageView.image = image
//            imageView.tintColor = color
//            leftView = imageView
//        }
//        else{
//            leftViewMode = UITextField.ViewMode.never
//            leftView = nil
//        }
//        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
//    }
//}
