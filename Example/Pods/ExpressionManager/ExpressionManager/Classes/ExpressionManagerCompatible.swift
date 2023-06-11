//
//  ExpressionManagerWrapper.swift
//  ExpressionManager
//
//  Created by Vick on 2022/10/20.
//

import UIKit
import Util_V

public protocol ExpressionManagerCompatible {
    associatedtype ExpressionManagerCompatibleType
    var expression: ExpressionManagerCompatibleType { get }
    
    var expressionAttributed: NSMutableAttributedString { get set }
    var expressionRealString: String { get }
    func match(_ string: String) -> [NSRange]
    func expressionSubRealString(_ rang: NSRange) -> String
}

public extension ExpressionManagerCompatible {
    var expression: ExpressionManagerWrapper<Self> {
        return ExpressionManagerWrapper(self)
    }
}

extension UILabel: ExpressionManagerCompatible {
    
    public func expressionSubRealString(_ rang: NSRange) -> String {
        let attributed = expressionAttributed.attributedSubstring(from: rang)
        return transitionRealString(attributed)
    }
    
    public func match(_ string: String) -> [NSRange] {
        return starMatch(expressionRealString, string: string)
    }
    
    public var expressionRealString: String {
        get {
            transitionRealString(expressionAttributed)
        }
    }
    
    public var expressionAttributed: NSMutableAttributedString {
        get {
            if let old = attributedText {
                return NSMutableAttributedString(attributedString: old)
            }
            return NSMutableAttributedString()
        }
        set {
            attributedText = newValue
        }
    }
}

extension UITextField: ExpressionManagerCompatible {
    
    public func expressionSubRealString(_ rang: NSRange) -> String {
        let attributed = expressionAttributed.attributedSubstring(from: rang)
        return transitionRealString(attributed)
    }
    
    public func match(_ string: String) -> [NSRange] {
        return starMatch(expressionRealString, string: string)
    }
    
    public var expressionRealString: String {
        get {
            transitionRealString(expressionAttributed)
        }
    }
    
    public var expressionAttributed: NSMutableAttributedString {
        get {
            if let old = attributedText {
                return NSMutableAttributedString(attributedString: old)
            }
            return NSMutableAttributedString()
        }
        set {
            attributedText = newValue
        }
    }
}

extension UITextView: ExpressionManagerCompatible {
    
    public func expressionSubRealString(_ rang: NSRange) -> String {
        let attributed = expressionAttributed.attributedSubstring(from: rang)
        return transitionRealString(attributed)
    }
    
    public func match(_ string: String) -> [NSRange] {
        return starMatch(expressionRealString, string: string)
    }
    
    
    public var expressionRealString: String {
        get {
            transitionRealString(expressionAttributed)
        }
    }
    
    public var expressionAttributed: NSMutableAttributedString {
        get {
            if let old = attributedText {
                return NSMutableAttributedString(attributedString: old)
            }
            return NSMutableAttributedString()
        }
        set {
            attributedText = newValue
        }
    }
}

private func transitionRealString(_ attributed: NSAttributedString) -> String {
    var result = ""
    let aString = attributed.string as NSString
    attributed.enumerateAttribute(.attachment, in: NSRange(location: 0, length: attributed.length)) { value, range, _ in
        if let attachment = value as? ExpressionAttachment {
            result += attachment.text
        } else {
            result += aString.substring(with: range)
        }
    }
    return result
}

private func starMatch(_ realString: String, string: String) -> [NSRange] {
    var str = realString as NSString
    
    var withStr = "X"
    if withStr == string {
        withStr = withStr.lowercased()
    }
    
    let regulars = realString.regular(ExpressionManager.pattern)
    for index in regulars {
        str = str.replacingCharacters(in: NSMakeRange(index.range.location, index.range.length), with: withStr) as NSString
    }
    
    var allRange = [NSRange]()
    withStr = [String](repeating: withStr, count: string.count).joined()
    
    while str.range(of: string).location != NSNotFound {
        let range = str.range(of: string)
        allRange.append(NSRange(location: range.location,length: range.length))
        str = str.replacingCharacters(in: NSMakeRange(range.location, range.length), with: withStr) as NSString
    }
    return allRange
}
