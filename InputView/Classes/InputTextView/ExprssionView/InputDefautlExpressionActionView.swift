//
//  ContentSizeOfInputSendView.swift
//  ContentSizeView
//
//  Created by V on 2023/2/16.
//

import UIKit

open class InputDefautlExpressionActionView: UIButton, InputExpressionActionView {
   
    public var handler: InputActionViewHandler?
    
    public var actionHeight: CGFloat {
        return 36
    }
    
    public var actionWidth: CGFloat {
        return 42
    }
    
    public var showKeyboard = false {
        didSet {
            showKeyboard ? setImage(keyboard, for: .normal) : setImage(expression, for: .normal)
        }
    }
    
    public var keyboard: UIImage? = UIImage(input: "input_keyboard")
    
    public var expression: UIImage? = UIImage(input: "input_expression")
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
