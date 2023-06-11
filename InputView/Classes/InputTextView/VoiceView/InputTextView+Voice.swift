//
//  InputTextView+Voice.swift
//  InputView
//
//  Created by V on 2023/6/9.
//

import UIKit

extension InputTextView {
    private struct AssociatedKey {
        static var action = "expressionActionView"
        static var inputView = "voiceInputView"
        static var control = "voiceContorlView"
        static var manager = "voiceManager"
    }
    
    internal var voiceActionView: InputVoiceActionView! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.action) as? InputVoiceActionView ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.action, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var voiceView: UIButton! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.inputView) as? UIButton ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.inputView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var voiceContorlView: InputVocieControlView! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.control) as? InputVocieControlView ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.control, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var voiceManager: InputVoiceManager! {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.manager) as? InputVoiceManager ?? nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.manager, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func addVoiceView<T:InputVoiceActionView,
                             O:InputVocieControlView>(
        controlView: O.Type = InputDefaultVoiceControlView.self,
        actionView: T.Type = InputDefaultVoiceActionView.self,
        keyboard: UIImage? = nil,
        voice: UIImage? = nil,
        atRight: Bool)
    {
        addViceInputView()
        
        addViceControlView(controlView)
        
        addVoiceAction(actionView: actionView, keyboard: keyboard, voice: voice, atRight: atRight)
        
        voiceManager = InputVoiceManager()
    }
    
    private func addViceInputView() {
        let button = UIButton()
        button.setTitle("按住说话", for: .normal)
        button.setTitleColor(textView.textColor, for: .normal)
        button.titleLabel?.font = textView.font
        button.layer.cornerRadius = textView.layer.cornerRadius
        button.layer.borderWidth = textView.layer.borderWidth
        button.layer.borderColor = textView.layer.borderColor
        button.backgroundColor = textView.backgroundColor
        button.isHidden = true
        
        let long = UILongPressGestureRecognizer(target: self, action: #selector(recording))
        long.minimumPressDuration = 0.2
        button.addGestureRecognizer(long)
        
        addSubview(button)
        
        voiceView = button
    }
    
    private func addViceControlView<T:InputVocieControlView>(_ control: T.Type) {
        guard let superview = superview else {
            fatalError("`InputTextView` must have a superview")
        }
        
        let view = control.init()
        view.isHidden = true
        superview.insertSubview(view, belowSubview: self)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        voiceContorlView = view
    }
    
    private func addVoiceAction<T:InputVoiceActionView>(
        actionView: T.Type = InputDefaultVoiceActionView.self,
        keyboard: UIImage? = nil,
        voice: UIImage? = nil,
        atRight: Bool)
    {
        let action = actionView.init()
        if voice != nil {
            action.voice = voice
        }
        if keyboard != nil {
            action.keyboard = keyboard
        }
        action.setImage(action.voice, for: .normal)
        action.addTarget(self, action: #selector(voiceTap), for: .touchUpInside)
        voiceActionView = action
        
        if atRight {
            addRightActionView(action)
        } else {
            addLeftActionView(action)
        }
    }
    
    @objc private func recording(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            let poiont = sender.location(in: superview)
            voiceManager.starCapture()
            voiceContorlView.isHidden = false
            voiceContorlView.pointChanged(at: poiont)
        case .changed:
            let poiont = sender.location(in: superview)
            voiceContorlView.pointChanged(at: poiont)
        case .ended:
            let poiont = sender.location(in: superview)
            voiceManager.stopCapture{ url in
                if self.voiceContorlView.needSend(at: poiont) {
                    self.delegate?.sendVoice?(url)
                } else {
                    url.removeFile()
                }
            }
            voiceContorlView.isHidden = true
        default:
            break
        }
    }
    
    @objc private func voiceTap(_ sender: UIButton) {
        guard let superview = superview else {
            fatalError("`InputTextView` must have a superview")
        }
        
        if responding {
            return
        }
        
        if let action = sender as? InputVoiceActionView {
            
            expressionActionView?.showKeyboard = false //重置表情按钮
            
            if action.showKeyboard { //当前图标为键盘
                //当前显示键盘
                inputViewResignFirstResponder()
                
                voiceView.isHidden = true
                voiceView.snp.removeConstraints()
                textView.isHidden = false
                addTextLayout()
                superview.layoutIfNeeded()
                
                textView.becomeFirstResponder()
                
                action.showKeyboard = false
            } else {
                //当前显示语音输入
                inputViewResignFirstResponder()
                textView.resignFirstResponder()
                
                textView.isHidden = true
                textView.snp.removeConstraints()
                voiceView.isHidden = false
                addVoiceLayout()
                superview.layoutIfNeeded()
                
                responderView = nil
                inputViewBecomeFirstResponder(to: .voice, at: 0)
                
                action.showKeyboard = true
            }
        }
    }
    
    private func addVoiceLayout() {
        var left: CGFloat = 8
        if leftActionStackView.width > 0 {
            left = 2*left + leftActionStackView.width
        }
        var right: CGFloat = 8
        if rightActionStackView.width > 0 {
            right = 2*right + rightActionStackView.width
        }
        
        voiceView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(left)
            make.right.equalToSuperview().inset(right)
            make.bottom.equalToSuperview().inset(5)
            make.height.equalTo(originalHeight)
            make.top.equalToSuperview().inset(5)
        }
    }
}
