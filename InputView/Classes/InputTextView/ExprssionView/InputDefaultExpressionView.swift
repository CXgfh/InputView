//
//  expressionInputView.swift
//  InputView
//
//  Created by V on 2023/2/18.
//

import UIKit
import Util_V
import SnapKit
import ExpressionManager
import ContentSizeView

public protocol InputExpressionView: UIView {
    var hasContent: Bool { get set }
    var delegate: ExpressionInputViewDelegate? { get set }
}

public protocol ExpressionInputViewDelegate: UIView {
    func add(_ model: ExpressionModel)
    func del()
    func send()
}

open class InputDefaultExpressionView: UIView, InputExpressionView {
    
    public var hasContent: Bool {
        get {
            return false
        }
        set {
            stackView.isUserInteractionEnabled = newValue
            stackView.alpha = newValue ? 1 : 0.5
        }
    }
  
    weak public var delegate: ExpressionInputViewDelegate?

    private lazy var dataSource = ExpressionManager.dic
    
    private lazy var collectionLayout: ContentSizeOfFlowLayout = {
        let layout = ContentSizeOfFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        layout.itemInset = .init(top: 1, left: 1, bottom: 1, right: 1)
        let width = floor((UIScreen.main.bounds.width - 16 - 10*2)/10)
        layout.itemSize = CGSize(width: width, height: width)
        return layout
    }()
    
    private lazy var collectionView: ContentSizeOfCollectionView = {
        let collection = ContentSizeOfCollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.backgroundColor = .init(hex: 0xF2F2F2)
        collection.delegate = self
        collection.dataSource = self
        collection.register(InputDefaultExpressionCollectionViewCell.self)
        return collection
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 5
        stack.addArrangedSubviews(delButton, sendButton)
        stack.alpha = 0.5
        stack.isUserInteractionEnabled = false
        return stack
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.setTitle("发送", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = .init(hex: 0xBD8DFF)
        button.addTarget(self, action: #selector(sendTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var delButton: UIButton = {
        let button = UIButton()
        var image: UIImage?
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "delete.left")?.dyeing(by: .black)
        } else {
            image = UIImage(named: "delete.left")
        }
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.backgroundColor = .white
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(delTap), for: .touchUpInside)
        return button
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, stackView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.height.equalTo(36)
            make.width.equalTo(125)
            make.bottom.equalToSuperview().inset(34)
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InputDefaultExpressionView {
    @objc private func delTap() {
        delegate?.del()
    }
    
    @objc private func sendTap() {
        delegate?.send()
    }
}
 
extension InputDefaultExpressionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withCellClass: InputDefaultExpressionCollectionViewCell.self, for: indexPath)
        cell.image = ExpressionManager.loadImage(item: dataSource[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        delButton.layoutIfNeeded()
        return CGSize(width: 0, height: 32+delButton.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.add(dataSource[indexPath.row])
    }
}
