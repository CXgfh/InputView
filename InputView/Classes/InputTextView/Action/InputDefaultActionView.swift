//
//  InputDefaultActionView.swift
//  InputView
//
//  Created by V on 2023/6/9.
//

import UIKit

open class InputDefaultActionView: UIButton, InputActionView {
    public var actionHeight: CGFloat {
        return 36
    }
    
    public var actionWidth: CGFloat {
        return 42
    }
    
    public var handler: InputActionViewHandler?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
