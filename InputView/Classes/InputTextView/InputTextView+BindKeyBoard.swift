//
//  InputTextView+BindKeyBoard.swift
//  InputView
//
//  Created by V on 2023/6/8.
//

import UIKit
import Util_V
import SnapKit

extension InputTextView {
    private struct AssociatedKey {
        static var isBind = "isbindingKeyBoard"
    }
    
    internal var isBindingKeyBoard: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.isBind) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.isBind, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func bindKeyBoard() {
        if !isBindingKeyBoard {
            isBindingKeyBoard = true
            addLayout()
        }
    }
    
    private func addLayout() {
        guard let superview = superview else {
            fatalError("`InputTextView` must have a superview")
        }
        superview.insertSubview(additionView, at: 0)
        additionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        self.snp.removeConstraints()
        self.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(superview.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                make.bottom.equalTo(superview.snp.bottom).offset(0)
            }
        }
    }
    
    internal func addNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if textView.isFirstResponder { //设置text类型为第一响应
            inputViewResignFirstResponder()
            inputViewBecomeFirstResponder(to: .text, at: notification.endFrame?.height ?? 0)
        }
    }
    
    @objc private func keyboardWillHide() {
        if responderType == .text { //如果当前是text类型的响应，辞去第一响应
            inputViewResignFirstResponder()
        }
    }
}

internal extension NSNotification {
    var timeInterval: TimeInterval? {
        guard let value = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return nil }
        return TimeInterval(truncating: value)
    }
    
    var animationCurve: UIView.AnimationCurve? {
        guard let index = (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue else { return nil }
        guard index >= 0 && index <= 3 else { return .linear }
        return UIView.AnimationCurve.init(rawValue: index) ?? .linear
    }
    
    var animationOptions: UIView.AnimationOptions {
        guard let curve = animationCurve else { return [] }
        switch curve {
        case .easeIn:
            return .curveEaseIn
        case .easeOut:
            return .curveEaseOut
        case .easeInOut:
            return .curveEaseInOut
        case .linear:
            return .curveLinear
        @unknown default:
            return .curveLinear
        }
    }
    
    var startFrame: CGRect? {
        return (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
    }
    
    var endFrame: CGRect? {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
    
    var isForCurrentApp: Bool? {
        return (userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue
    }
    
}


