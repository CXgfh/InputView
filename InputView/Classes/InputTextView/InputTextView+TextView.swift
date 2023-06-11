//
//  InputTextView+TextView.swift
//  InputView
//
//  Created by V on 2023/6/8.
//

import UIKit

extension InputTextView {
    private struct AssociatedKey {
        static var font = "textFont"
        static var textColor = "textColor"
        static var returnKeyType = "returnKeyType"
    }
    
    public var text: String {
        return textView.text
    }
    
    internal var font: UIFont {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.font) as? UIFont ?? UIFont.systemFont(ofSize: 13)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.font, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var textColor: UIColor {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.textColor) as? UIColor ?? UIColor.black
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.textColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var returnKeyType: UIReturnKeyType {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.returnKeyType) as? UIReturnKeyType ?? .default
        }
        set {
            textView.returnKeyType = newValue
            objc_setAssociatedObject(self, &AssociatedKey.returnKeyType, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
