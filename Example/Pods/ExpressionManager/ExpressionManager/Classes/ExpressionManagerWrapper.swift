//
//  ExpressionManagerWrapper.swift
//  ExpressionManager
//
//  Created by Vick on 2022/10/20.
//

import Util_V
import UIKit

enum RegularResult {
    case text(_ content: String)
    case image(_ name: String)
}

public class ExpressionManagerWrapper<Base> {
    var base: Base
    
    init(_ base: Base) {
        self.base = base
    }
}

public extension ExpressionManagerWrapper where Base: ExpressionManagerCompatible {
    public func del() {
        let new = base.expressionAttributed
        if new.length >= 1 {
            new.deleteCharacters(in: NSRange(location: new.length-1, length: 1))
        }
        base.expressionAttributed = new
    }
    
    public func addOneExpression(text: String,
                                 attributes: [NSAttributedString.Key : Any]? = nil) -> Bool {
        if let item = ExpressionManager.dic.first(where: { $0.text == text }) {
            addOneExpression(item: item, attributes: attributes)
            return true
        } else {
            let new = base.expressionAttributed
            new.append(NSAttributedString(string: text, attributes: attributes))
            base.expressionAttributed = new
            return false
        }
    }
    
    public func addOneExpression(item: ExpressionModel,
                                 attributes: [NSAttributedString.Key : Any]? = nil) {
        let new = base.expressionAttributed
        let image = ExpressionManager.loadOneExpression(item: item, attributes: attributes)
        new.append(image)
        base.expressionAttributed = new
    }
    
    public func load(text: String,
                     attributes: [NSAttributedString.Key : Any]? = nil) {
        let new = base.expressionAttributed
        new.append(ExpressionManager.loadExpression(text: text, attributes: attributes))
        base.expressionAttributed = new
    }
    
    public func reload(text: String,
                       attributes: [NSAttributedString.Key : Any]? = nil) {
        base.expressionAttributed = ExpressionManager.loadExpression(text: text, attributes: attributes)
    }
}



