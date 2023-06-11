//
//  ViewController.swift
//  InputView
//
//  Created by V on 02/21/2023.
//  Copyright (c) 2023 V. All rights reserved.
//

import UIKit
import InputView
import SnapKit
import ExpressionManager

class ViewController: UIViewController {
    
    private lazy var associatedView: UIView = {
        let object = UIView()
        object.backgroundColor = .random
        return object
    }()
    
    private lazy var config: InputTextConfig = {
        var config = InputTextConfig()
        config.tintColor = .blue
        config.backgroundColor = .white
        config.borderColor = UIColor.clear.cgColor
        config.borderWidth = 1
        config.font = .systemFont(ofSize: 18)
        config.radius = 8
        config.textColor = .black
        return config
    }()
    
    private lazy var textView: InputTextView = {
        let textView = InputTextView(config: config, autoHeight: true, maximumDisplayHeight: 120, maxCount: .max)
        textView.returnKeyType = .send
        textView.delegate = self
        return textView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.center.left.right.equalToSuperview()
        }
        textView.bindKeyBoard() //将移除原有约束
        
        ExpressionManager.loadDefaultData()
        textView.addExpressionView(atRight: true)
        
        textView.addAssociateView(associateView: associatedView, height: 300, image: UIColor.random.image(CGSize(width: 20, height: 20)), atRight: true)
        
        textView.addActionView(image: UIColor.random.image(CGSize(width: 20, height: 20)), atRight: false) { action in
            print(1111)
        }
        
        textView.addVoiceView(atRight: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        _ = textView.resignFirstResponder()
    }
}

extension ViewController: InputTextViewDelegate {
    func inputTextViewSend(_ text: String, at: InputTextView) {
        
    }
    
    func inputTextViewSendVoice(_ url: URL, at: InputTextView) {
        
    }
    
    func inputTextViewChanged(at: InputTextView) {
        
    }
    
    func inputTextViewDidEndEditing(at: InputTextView) {
        
    }
    
    func inputTextViewShouldBeginEditing(at: InputTextView) {
        
    }
}
