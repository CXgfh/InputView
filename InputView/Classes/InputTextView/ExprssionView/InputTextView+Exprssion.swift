//
//  InputView+Exprssion.swift
//  InputView
//
//  Created by V on 2023/2/18.
//

import UIKit
import SnapKit
import ExpressionManager

extension InputTextView {
    private struct AssociatedKey {
        static var needLoad = "needLoadExpression"
        static var height = "expressionViewHeight"
        static var view = "expressionView"
        static var action = "expressionActionView"
    }
    
    internal var needLoadExpression: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.needLoad) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.needLoad, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var expressionViewHeight: CGFloat {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.height) as? CGFloat ?? 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.height, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var expressionView: InputExpressionView! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.view) as? InputExpressionView ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.view, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var expressionActionView: InputExpressionActionView! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.action) as? InputExpressionActionView ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.action, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func addExpressionView<T: InputExpressionView,
                                  O: InputExpressionActionView>(
        expressionView: T.Type = InputDefaultExpressionView.self,
        expressionHeight: CGFloat = 300,
        actionView: O.Type = InputDefautlExpressionActionView.self,
        keyboard: UIImage? = nil,
        expression: UIImage? = nil,
        atRight: Bool)
    {
        self.needLoadExpression = true
        self.expressionViewHeight = expressionHeight
        
        addExpressionView(expressionView)
        addExpressionActionView(actionView, keyboard: keyboard, expression: expression, atRight: atRight)
    }
    
    private func addExpressionView<T: InputExpressionView>(_ expressionView: T.Type) {
        guard let superview = superview else {
            fatalError("`InputView` must have a superview")
        }
        
        self.expressionView = expressionView.init()
        self.expressionView.delegate = self
        
        superview.addSubview(self.expressionView)
        self.expressionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(self.expressionViewHeight)
            make.top.equalTo(superview.snp.bottom).offset(0)
        }
        superview.layoutIfNeeded()
    }
    
    private func addExpressionActionView<T: InputExpressionActionView>(
        _ actionView: T.Type,
        keyboard: UIImage?,
        expression: UIImage?,
        atRight: Bool)
    {
        let action = actionView.init()
        if expression != nil {
            action.expression = expression
        }
        if keyboard != nil {
            action.keyboard = keyboard
        }
        action.setImage(action.expression, for: .normal)
        action.addTarget(self, action: #selector(expressionTap), for: .touchUpInside)
        expressionActionView = action
        
        if atRight {
            addRightActionView(action)
        } else {
            addLeftActionView(action)
        }
    }
    
    @objc private func expressionTap(_ sender: UIButton) {
        if responding {
            return
        }
        
        if let action = sender as? InputExpressionActionView {
            voiceActionView?.showKeyboard = false //重置录音按钮
            
            if action.showKeyboard { //当前图标为键盘
                //当前显示键盘
                inputViewResignFirstResponder()
                
                textView.becomeFirstResponder()
                
                action.showKeyboard = false
            } else {
                //当前显示表情
                inputViewResignFirstResponder()
                textView.resignFirstResponder()
                
                responderView = expressionView
                inputViewBecomeFirstResponder(to: .expression, at: expressionViewHeight)
                
                action.showKeyboard = true
            }
        }
    }
}

extension InputTextView: ExpressionInputViewDelegate {
    public func send() {
        delegate?.inputTextViewSend?(textView.expressionRealString, at: self)
        textView.expressionAttributed = NSMutableAttributedString()
        count = 0
    }
    
    public func add(_ model: ExpressionModel) {
        if count < maxCount {
            textView.expression.addOneExpression(item: model, attributes: [.font: font, .foregroundColor: textColor])
            textView.textColor = textColor
            textView.font = font
            textViewDidChange(textView)
        }
    }
    
    public func del() {
        if count > 0 {
            textView.expression.del()
            textView.font = font
            textView.textColor = textColor
            textViewDidChange(textView)
        }
    }
}

