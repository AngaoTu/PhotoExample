//
//  AssetListCollectionViewCell.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/21.
//

import UIKit

class AssetListCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image = nil
        imageView.image = nil
    }
    
    // MARK: - 公有属性
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    // MARK: - 私有属性
    private lazy var imageView: UIImageView = {
        let temp = UIImageView()
        temp.clipsToBounds = true
        temp.contentMode = .scaleAspectFill
        return temp
    }()
}

private extension AssetListCollectionViewCell {
    func initView() {
        self.backgroundColor = .white
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
}
