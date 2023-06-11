//
//  InputTextView.swift
//  InputTextView
//
//  Created by V on 2023/6/8.
//

import UIKit

extension InputTextView {
    private struct AssociatedKeys {
        static var spacing = "placeholderSpacing"
        static var image = "placeholderImage"
        static var text = "placeholderText"
    }
    
    public var placeholderSpacing: CGFloat {
        get {
            return 4
        }
        set {
            placeholderStackView.spacing = newValue
            placeholderStackView.layoutIfNeeded()
        }
    }
    
    
    public var placeholderImage: UIImage? {
        get {
            return nil
        }
        set {
            placeholderImageView.image = newValue
        }
    }
    
    public var placeholderText: String {
        get {
            return ""
        }
        set {
            placeholderAttributedText =  NSAttributedString(string: newValue, attributes: [.font: UIFont.systemFont(ofSize: font.pointSize, weight: .regular), .foregroundColor: UIColor.init(hex: 0x999999)])
        }
    }
    
    public var placeholderAttributedText: NSAttributedString? {
        get {
            return nil
        }
        set {
            placeholderLabel.attributedText = newValue
        }
    }
}
