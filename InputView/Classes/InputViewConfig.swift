//
//  InputViewConfig.swift
//  VTextView
//
//  Created by V on 2022/11/14.
//

import UIKit



public struct InputTextConfig {
    public var font: UIFont = .systemFont(ofSize: 17, weight: .medium)
    public var textColor: UIColor = .black
    public var tintColor: UIColor = .blue
    
    public var radius: CGFloat = 6
    public var backgroundColor: UIColor = .clear
    public var borderWidth: CGFloat = 0
    public var borderColor: CGColor = UIColor.clear.cgColor
    public var keyboardType: UIKeyboardType = .default
    
    public init() { }
}



