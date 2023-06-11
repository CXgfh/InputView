//
//  InputDefaultVoiceActionView.swift
//  InputView
//
//  Created by V on 2023/6/9.
//

import UIKit

open class InputDefaultVoiceActionView: UIButton, InputVoiceActionView {
    
    public var handler: InputActionViewHandler?
    
    public var actionHeight: CGFloat {
        return 36
    }
    
    public var actionWidth: CGFloat {
        return 42
    }
    
    public var showKeyboard = false {
        didSet {
            showKeyboard ? setImage(keyboard, for: .normal) : setImage(voice, for: .normal)
        }
    }
    
    public var keyboard: UIImage? = UIImage(input: "input_keyboard")
    
    public var voice: UIImage? = UIImage(input: "input_wave.3.left.circle")
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
