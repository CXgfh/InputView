//
//  ExpressionManager.swift
//  ExpressionManager
//
//  Created by Vick on 2022/10/19.
//

import UIKit

public struct ExpressionModel: Codable {
    public var text: String
    public var imageName: String
}

public class ExpressionManager {
    public static var dic: [ExpressionModel] = []
    
    internal static var imagesBundle: Bundle?
    
    internal static var pattern = "\\[[\\u4e00-\\u9fa5\\w]+\\]"
    
    public static func loadDefaultData() {
        pattern = "\\[[\\u4e00-\\u9fa5\\w]+\\]"
        
        if let url = Bundle(for: ExpressionManager.self).url(forResource: "Expression", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let value = try? JSONDecoder().decode([ExpressionModel].self, from: data) {
            dic = value
        } else {
            fatalError("loadDefaultData has not been implemented")
        }
        if let url = Bundle(for: ExpressionManager.self).url(forResource: "Expression", withExtension: "bundle") {
            imagesBundle = Bundle(url: url)
        }
    }
    
    public static func loadUseData(pattern: String = "\\[[\\u4e00-\\u9fa5\\w]+\\]",
                                   dic: URL?,
                                   images: URL?) {
        ExpressionManager.pattern = pattern
        if let url = dic,
           let data = try? Data(contentsOf: url),
           let value = try? JSONDecoder().decode([ExpressionModel].self, from: data) {
            ExpressionManager.dic = value
        } else {
            fatalError("loadUseData has not been implemented")
        }
        if let url = images {
            imagesBundle = Bundle(url: url)
        }
    }
}

//外部访问图片资源
public extension ExpressionManager {
    static func loadImage(text: String) -> UIImage? {
        if let item = ExpressionManager.dic.first(where: { $0.text == text }) {
            return loadImage(item: item)
        }
        return nil
    }
    
    static func loadImage(item: ExpressionModel) -> UIImage? {
        if let bundle = ExpressionManager.imagesBundle {
            return UIImage(named: item.imageName, in: bundle, compatibleWith: nil)
        } else {
            return UIImage(named: item.imageName)
        }
    }
}

public extension ExpressionManager {
    static func loadExpression(image: UIImage,
                               attributes: [NSAttributedString.Key : Any]? = nil) -> NSAttributedString {
        let attachment = ExpressionAttachment()
        attachment.image = image
        attachment.font = attributes?[.font] as? UIFont
        return NSAttributedString(attachment: attachment)
    }
    
    static func loadExpression(text: String,
                               attributes: [NSAttributedString.Key : Any]? = nil) -> NSMutableAttributedString {
        let regulars = text.regular(ExpressionManager.pattern)
        if regulars.count == 0 {
            return NSMutableAttributedString(string: text, attributes: attributes)
        } else {
            let tem = text as NSString
            var location = 0
            var results = [RegularResult]()
            for regular in regulars {
                results.append(.text(tem.substring(with: NSRange(location: location, length: regular.range.location-location))))
                results.append(.image(tem.substring(with: regular.range)))
                location = regular.range.location + regular.range.length
            }
            if location < tem.length {
                results.append(.text(tem.substring(with: NSRange(location: location, length: tem.length-location))))
            }
            let attributed = NSMutableAttributedString()
            for result in results {
                switch result {
                case .text(let content):
                    attributed.append(NSAttributedString(string: content, attributes: attributes))
                case .image(let text):
                    let image = ExpressionManager.loadOneExpression(text: text, attributes: attributes)
                    attributed.append(image)
                }
            }
            return attributed
        }
    }
    
    
}

extension ExpressionManager {
    static func loadOneExpression(text: String,
                                  attributes: [NSAttributedString.Key : Any]? = nil) -> NSAttributedString {
        if let item = ExpressionManager.dic.first(where: { $0.text == text }) {
            return loadOneExpression(item: item, attributes: attributes)
        }
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    static func loadOneExpression(item: ExpressionModel,
                                  attributes: [NSAttributedString.Key : Any]? = nil) -> NSAttributedString {
        if let image = loadImage(item: item) {
            let size = (attributes?[.font] as? UIFont)?.lineHeight ?? .zero
            let attachment = ExpressionAttachment()
            attachment.image = image
            attachment.text = item.text
            attachment.font = attributes?[.font] as? UIFont
//            attachment.bounds = CGRect(x: 0, y: 0, width: size, height: size)
            return NSMutableAttributedString(attachment: attachment)
        }
        return NSAttributedString(string: item.text, attributes: attributes)
    }
}

class ExpressionAttachment: NSTextAttachment {
    
    var font: UIFont?
    
    var text: String = ""
    
    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        if let font = font {
            return CGRect(x: 0, y: font.descender, width: font.lineHeight, height: font.lineHeight)
        }
        return super.attachmentBounds(for: textContainer, proposedLineFragment: lineFrag, glyphPosition: position, characterIndex: charIndex)
    }
}
