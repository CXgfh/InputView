//
//  InputTextView+Action.swift
//  InputView
//
//  Created by V on 2023/6/9.
//

import UIKit
import SnapKit

extension InputTextView {
    public var leftActionViewSpacing: CGFloat {
        get {
            return 4
        }
        set {
            leftActionStackView.spacing = newValue
            leftActionStackView.layoutIfNeeded()
            updateTextLayout()
        }
    }
    
    public var rightActionViewSpacing: CGFloat {
        get {
            return 4
        }
        set {
            rightActionStackView.spacing = newValue
            rightActionStackView.layoutIfNeeded()
            updateTextLayout()
        }
    }
    
    internal func addLeftActionView(_ view: InputActionView) {
        leftActionStackView.addArrangedSubview(view)
        view.snp.makeConstraints { make in
            make.width.equalTo(view.actionWidth)
            make.height.equalTo(view.actionHeight)
        }
        leftActionStackView.layoutIfNeeded()
        updateTextLayout()
    }
    
    internal func addRightActionView(_ view: InputActionView) {
        rightActionStackView.addArrangedSubview(view)
        view.snp.makeConstraints { make in
            make.width.equalTo(view.actionWidth)
            make.height.equalTo(view.actionHeight)
        }
        rightActionStackView.layoutIfNeeded()
        updateTextLayout()
    }
}
