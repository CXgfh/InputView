//
//  InputDefaultVoiceControlView.swift
//  InputView
//
//  Created by V on 2023/6/12.
//

import UIKit
import SnapKit

open class InputDefaultVoiceControlView: UIView, InputVocieControlView {
    public func pointChanged(at piont: CGPoint) {
        
    }
    
    public func needSend(at piont: CGPoint) -> Bool {
        return true
    }
    
    private lazy var label: UILabel = {
        let label = UILabel(font: .systemFont(ofSize: 17, weight: .regular), textColor: .black)
        label.text = "松开发送"
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
