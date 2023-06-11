//
//  InputViewProtocol.swift
//  InputView
//
//  Created by V on 2023/6/9.
//

import UIKit

public typealias InputActionViewHandler = (_ action: InputActionView)->Void

public protocol InputActionView: UIButton {
    var actionHeight: CGFloat { get }
    var actionWidth: CGFloat { get }
    var handler: InputActionViewHandler? { get set }
}

public protocol InputVocieControlView: UIView {
    func pointChanged(at piont: CGPoint)
    func needSend(at piont: CGPoint) -> Bool
}

public protocol InputAssociateActionView: InputActionView {
    var associateView: UIView { get set }
    var associateViewHeight: CGFloat { get set }
}

public protocol InputVoiceActionView: InputActionView {
    var showKeyboard: Bool { get set }
    var keyboard: UIImage? { get set }
    var voice: UIImage? { get set }
}

public protocol InputExpressionActionView: InputActionView {
    var showKeyboard: Bool { get set }
    var keyboard: UIImage? { get set }
    var expression: UIImage? { get set }
}

@objc public protocol InputTextViewDelegate: AnyObject {
    @objc optional func inputTextViewSend(_ text: String, at: InputTextView)
    @objc optional func inputTextViewSendVoice(_ url: URL, at: InputTextView)
    @objc optional func inputTextViewChanged(at: InputTextView)
    @objc optional func inputTextViewShouldBeginEditing(at: InputTextView)
    @objc optional func inputTextViewDidEndEditing(at: InputTextView)
}
