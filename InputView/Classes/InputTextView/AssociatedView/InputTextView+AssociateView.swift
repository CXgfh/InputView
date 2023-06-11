//
//  InputTextView+AssociateView.swift
//  InputView
//
//  Created by V on 2023/6/9.
//

import UIKit

extension InputTextView {
    private struct AssociatedKey {
        static var current = "associateViewCurrentIdentifier"
        static var identifier = "associateViewIdentifier"
    }
    
    private var current: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.current) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.current, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var identifier: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.identifier) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.identifier, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func addAssociateView<T: InputAssociateActionView>(
        type: T.Type = InputDefaultAssociateActionView.self,
        associateView: UIView,
        height: CGFloat,
        image: UIImage?,
        atRight: Bool)
    {
        guard let superview = superview else {
            fatalError("`InputTextView` must have a superview")
        }
        superview.addSubview(associateView)
        associateView.snp.makeConstraints { make in
            make.height.equalTo(height)
            make.left.right.equalToSuperview()
            make.top.equalTo(superview.snp.bottom).offset(0)
        }
        identifier += 1
        let action = type.init()
        action.tag = identifier
        action.associateView = associateView
        action.associateViewHeight = height
        action.setImage(image, for: .normal)
        action.addTarget(self, action: #selector(associateAcitonTap), for: .touchUpInside)
        
        if atRight {
            addRightActionView(action)
        } else {
            addLeftActionView(action)
        }
    }
    
    @objc private func associateAcitonTap(_ sender: UIButton) {
        if responding {
            return
        }
        
        if responderType == .associated && sender.tag == current {
            return
        }
        
        if let action = sender as? InputAssociateActionView {
            expressionActionView?.showKeyboard = false //重置表情按钮
            voiceActionView?.showKeyboard = false //重置录音按钮
            
            current = sender.tag
            inputViewResignFirstResponder()
            textView.resignFirstResponder()
            
            responderView = action.associateView
            inputViewBecomeFirstResponder(to: .associated, at: action.associateViewHeight)
        }
    }
}
