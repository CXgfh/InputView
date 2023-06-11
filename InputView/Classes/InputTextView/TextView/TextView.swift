//
//  TextView.swift
//  InputView
//
//  Created by V on 2023/2/18.
//

import UIKit
import ContentSizeView
import ExpressionManager

protocol TextViewDelegate: AnyObject {
    func copy()
    func paste()
}

class TextView: ContentSizeOfTextView {
    
    weak var textViewDelegate: TextViewDelegate?
    
    override func copy(_ sender: Any?) {
        textViewDelegate?.copy()
    }
    
    override func paste(_ sender: Any?) {
        textViewDelegate?.paste()
    }
}

extension InputTextView: TextViewDelegate {
    func copy() {
        if needLoadExpression {
            UIPasteboard.general.string = textView.expressionSubRealString(textView.selectedRange)
        } else {
            let text = (textView.text as NSString).substring(with: textView.selectedRange)
            UIPasteboard.general.string = text as String
        }
    }
    
    func paste() {
        if let copy = UIPasteboard.general.string {
            var postion = textView.expressionAttributed.length //光标位置
            if let selectedTextRange = textView.selectedTextRange {
                postion = textView.offset(from: textView.beginningOfDocument, to: selectedTextRange.start)
            }
            
            if needLoadExpression {
                let length = textView.expressionAttributed.length
                
                let starAttributed = textView.expressionAttributed.attributedSubstring(from: NSRange(location: 0, length: postion))
                let endAttributed = textView.expressionAttributed.attributedSubstring(from: NSRange(location: postion, length: length-postion))
                
                var copyAttributed: NSAttributedString = ExpressionManager.loadExpression(text: copy, attributes: [.font: font, .foregroundColor: textColor])
                if copyAttributed.length + length > maxCount {
                    copyAttributed = copyAttributed.attributedSubstring(from: NSRange(location: 0, length: maxCount-length))
                }
                
                let new = NSMutableAttributedString()
                if starAttributed.length > 0 {
                    new.append(starAttributed)
                }
                new.append(copyAttributed)
                if endAttributed.length > 0 {
                    new.append(endAttributed)
                }
                
                textView.expressionAttributed = new
                
                postion += copyAttributed.length
            } else {
                let text = textView.text as NSString
                
                let starText = text.substring(with: NSRange(location: 0, length: postion))
                let endText = text.substring(with: NSRange(location: postion, length: text.length-postion))
                
                var copyText = copy
                if copy.count + text.length > maxCount {
                    copyText = (copy as NSString).substring(with: NSRange(location: 0, length: maxCount-text.length))
                }
                
                textView.text = starText + copyText + endText
                
                postion += copyText.count
            }
            
            if let newPostion = textView.position(from: textView.beginningOfDocument, offset: postion) {
                textView.selectedTextRange = textView.textRange(from: newPostion, to: newPostion)
            }
        }
        textViewDidChange(textView)
    }
}
