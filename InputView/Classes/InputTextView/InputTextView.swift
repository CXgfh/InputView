//
//  InputView.swift
//
//
//  Created by V on 2023/2/16.
//

import UIKit
import SnapKit
import Util_V

public class InputTextView: UIView {
    
    public weak var delegate: InputTextViewDelegate?
    
    private var autoHeight: Bool = true
    
    private var maximumDisplayHeight: CGFloat = 36
    
    internal var originalHeight: CGFloat = 0
    
    internal lazy var leftActionStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = leftActionViewSpacing
        stack.backgroundColor = .clear
        return stack
    }()
    
    internal lazy var textView: TextView = {
        let textView = TextView()
        textView.textViewDelegate = self
        return textView
    }()
    
    internal lazy var placeholderStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = placeholderSpacing
        stack.addArrangedSubviews(placeholderImageView, placeholderLabel)
        return stack
    }()
    
    internal lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    internal lazy var placeholderLabel = UILabel()
    
    internal lazy var rightActionStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = rightActionViewSpacing
        stack.backgroundColor = .clear
        return stack
    }()
    
    public var additionView = UIView()
    
    public init(config: InputTextConfig,
                autoHeight: Bool = true,
                maximumDisplayHeight: CGFloat = 36,
                maxCount: Int = .max) {
        super.init(frame: .zero)
        self.autoHeight = autoHeight
        self.maximumDisplayHeight = maximumDisplayHeight
        self.maxCount = maxCount
        backgroundColor = .init(hex: 0xE0E0E0)
        additionView.backgroundColor = .init(hex: 0xE0E0E0)
        
        setupUI(config: config)
        
        addNotification()
    }
    
    public override func resignFirstResponder() -> Bool {
        inputViewResignFirstResponder()
        textView.resignFirstResponder()
        expressionActionView?.showKeyboard = false //重置表情按钮
        voiceActionView?.showKeyboard = false //重置录音按钮
        
        responderView = nil
        inputViewBecomeFirstResponder(to: .none, at: 0)
        return true
    }

    public override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension InputTextView {
    private func setupUI(config: InputTextConfig) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if autoHeight {
            textView.maximumDisplayHeight = maximumDisplayHeight
            originalHeight = ceil(config.font.lineHeight + 16)
        } else {
            originalHeight = maximumDisplayHeight
        }
        
        font = config.font
        textColor = config.textColor
        
        textView.delegate = self
        textView.tintColor = config.tintColor
        textView.keyboardType = config.keyboardType
        
        textView.font = config.font
        textView.textColor = config.textColor
        textView.layer.cornerRadius = config.radius
        textView.layer.borderWidth = config.borderWidth
        textView.layer.borderColor = config.borderColor
        textView.backgroundColor = config.backgroundColor
        
        addSubviews(textView, placeholderStackView, leftActionStackView, rightActionStackView)
        
        leftActionStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(5)
            make.height.equalTo(originalHeight)
        }
        
        placeholderStackView.snp.makeConstraints { make in
            make.top.equalTo(textView).offset(8)
            make.left.equalTo(textView).offset(6)
        }
        
        rightActionStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(5)
            make.height.equalTo(originalHeight)
        }
        
        addTextLayout()
    }
    
    internal func addTextLayout() {
        var left: CGFloat = 8
        if leftActionStackView.width > 0 {
            left = 2*left + leftActionStackView.width
        }
        var right: CGFloat = 8
        if rightActionStackView.width > 0 {
            right = 2*right + rightActionStackView.width
        }
        
        textView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(left)
            make.right.equalToSuperview().inset(right)
            if autoHeight {
                make.top.greaterThanOrEqualToSuperview().inset(5)
                make.bottom.lessThanOrEqualToSuperview().inset(5)
            } else {
                make.bottom.equalToSuperview().inset(5)
                make.height.equalTo(maximumDisplayHeight)
                make.top.equalToSuperview().inset(5)
            }
        }
    }
    
    internal func updateTextLayout() {
        var left: CGFloat = 8
        if leftActionStackView.width > 0 {
            left = 2*left + leftActionStackView.width
        }
        var right: CGFloat = 8
        if rightActionStackView.width > 0 {
            right = 2*right + rightActionStackView.width
        }
        
        textView.snp.updateConstraints { make in
            make.left.equalToSuperview().inset(left)
            make.right.equalToSuperview().inset(right)
        }
    }
}

extension UIImage {
    convenience init?(input named: String) {
        if let url = Bundle(for: InputTextView.self).url(forResource: "InputView", withExtension: "bundle") {
            self.init(named: named, in: Bundle(url: url), compatibleWith: nil)
        } else {
            self.init(named: named, in: Bundle(for: InputTextView.self), compatibleWith: nil)
        }
    }
}
