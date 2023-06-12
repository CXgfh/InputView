//
//  InputTextView+UITextViewDelegate.swift
//
//
//  Created by V on 2023/2/16.
//

import UIKit
import SnapKit

extension InputTextView: UITextViewDelegate {
    
    private struct AssociatedKey {
        static var count = "textViewCurrentWordsCount"
        static var maxCount = "textViewMaxWordsCount"
    }
    
    public internal(set) var count: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.count) as? Int ?? 0
        }
        set {
            placeholderStackView.isHidden = newValue > 0
            if needLoadExpression {
                expressionView.hasContent = newValue > 0
            }
            objc_setAssociatedObject(self, &AssociatedKey.count, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var maxCount: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.maxCount) as? Int ?? .max
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.maxCount, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func sendText() -> String? {
        let text = textView.text
        textView.text = ""
        return text
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        delegate?.inputTextViewShouldBeginEditing?(at: self)
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.inputTextViewDidEndEditing?(at: self)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if let textRang = textView.markedTextRange, let _ = textView.position(from: textRang.start, offset: 0) {
            // 如果在变化中是高亮部分在变，就不要计算字符
            placeholderStackView.isHidden = true
            return
        }
        
        let text = textView.attributedText ?? NSAttributedString()
        if text.length > maxCount {
            textView.attributedText = text.attributedSubstring(from: NSRange(location: 0, length: maxCount))
            count = maxCount
        } else {
            count = text.length
        }
        
        delegate?.inputTextViewChanged?(at: self)
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.returnKeyType == .send,
            text == "\n" {
            if textView.text.count > 0 {
                if needLoadExpression {
                    delegate?.inputTextViewSend?(textView.expressionRealString, at: self)
                    textView.expressionAttributed = NSMutableAttributedString()
                } else {
                    delegate?.inputTextViewSend?(textView.text, at: self)
                    textView.text = ""
                }
                count = 0
            }
            return false
        }
        if text == "" { //删除
            return true
        } else if maxCount <= count {
            return false
        }
        return true
    }
}
