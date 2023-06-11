//
//  InputDefaultExpressionCollectionViewCell.swift
//  InputView
//
//  Created by V on 2023/2/18.
//

import UIKit
import SnapKit

class InputDefaultExpressionCollectionViewCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
