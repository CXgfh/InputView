//
//  InputTextView+.swift
//  InputView
//
//  Created by V on 2023/6/8.
//

import UIKit

extension InputTextView {
    private struct AssociatedKey {
        static var type = "InputViewCurrentState"
        static var responding = "InputViewResponding"
        static var responderView = "InputViewCurrentResponderView"
    }
    
    public enum InputViewResponderType {
        case none
        case text
        case expression
        case associated
        case voice
    }
    
    public internal(set) var responderType: InputViewResponderType {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.type) as? InputViewResponderType ?? .none
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.type, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var responding: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.responding) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.responding, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var responderView: UIView? {
        get {
           return objc_getAssociatedObject(self, &AssociatedKey.responderView) as? UIView ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.responderView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //设置第一响应，并抬高当前响应视图的高度
    internal func inputViewBecomeFirstResponder(to new: InputViewResponderType,
                                                at height: CGFloat) {
        guard let superview = superview else {
            fatalError("`InputTextView` must have a superview")
        }
        responding = true
        UIView.animate(withDuration: 0.25, delay: 0) {
            if self.isBindingKeyBoard {
                self.snp.updateConstraints { make in
                   if #available(iOS 11.0, *) {
                       let offset = (new == .none || new == .voice) ? 0 : superview.safeAreaInsets.bottom
                       make.bottom.equalTo(superview.safeAreaLayoutGuide.snp.bottom).offset(offset-height)
                   } else {
                       make.bottom.equalTo(superview.snp.bottom).offset(-height)
                   }
                }
            }
            self.responderView?.snp.updateConstraints { make in
                make.top.equalTo(superview.snp.bottom).offset(-height)
            }
            superview.layoutIfNeeded()
        } completion: { _ in
            self.responding = false
            if new == .text { //可能通过点击textView触发
                self.expressionActionView?.showKeyboard = false
                self.voiceActionView?.showKeyboard = false
            }
            self.responderType = new
        }
    }
    
    internal func inputViewResignFirstResponder() {
        guard let superview = superview else {
            fatalError("`InputTextView` must have a superview")
        }
        
        self.responderView?.snp.updateConstraints { make in
            make.top.equalTo(superview.snp.bottom).offset(0)
        }
        superview.layoutIfNeeded()
        
        if responderType == .voice {
            voiceView.isHidden = true
            voiceView.snp.removeConstraints()
            textView.isHidden = false
            addTextLayout()
            superview.layoutIfNeeded()
        }
        
        responderType = .none
        responderView = nil
    }
}
