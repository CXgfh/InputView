//
//  InputTextView+CustomAciton.swift
//  InputView
//
//  Created by V on 2023/6/9.
//

import UIKit

extension InputTextView {
    public func addActionView<T: InputActionView>(
        type: T.Type = InputDefaultActionView.self,
        image: UIImage?,
        atRight: Bool,
        handler: InputActionViewHandler?)
    {
        let action = type.init()
        action.handler = handler
        action.setImage(image, for: .normal)
        action.addTarget(self, action: #selector(customAcitonTap), for: .touchUpInside)
        if atRight {
            addRightActionView(action)
        } else {
            addLeftActionView(action)
        }
    }
    
    @objc private func customAcitonTap(_ sender: UIButton) {
        if responding {
            return
        }
        
        if let action = sender as? InputActionView {
            
            expressionActionView?.showKeyboard = false //重置表情按钮
            voiceActionView?.showKeyboard = false //重置录音按钮
            
            inputViewResignFirstResponder()
            textView.resignFirstResponder()
            
            responderView = nil
            inputViewBecomeFirstResponder(to: .none, at: 0)
            
            action.handler?(action)
        }
    }
}
