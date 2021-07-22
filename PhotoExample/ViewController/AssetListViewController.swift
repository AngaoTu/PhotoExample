//
//  AssetListViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/21.
//

import UIKit
import Photos

class AssetListViewController: UIViewController {
    // MARK: - initialization
    init(fetchResult: PHFetchResult<PHAsset>) {
        super.init(nibName: nil, bundle: nil)
        self.dataList = fetchResult
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    // MARK: - 私有属性
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 40) / 3
        flowLayout.itemSize = CGSize(width: width, height: width)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        let temp = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        temp.delegate = self
        temp.dataSource = self
        temp.backgroundColor = .white
        temp.register(AssetListCollectionViewCell.self, forCellWithReuseIdentifier: "AssetListCollectionViewCell")
        return temp
    }()
    
    private var dataList: PHFetchResult<PHAsset>?
}

extension AssetListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.dataList?.count else {
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssetListCollectionViewCell", for: indexPath) as? AssetListCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let asset = dataList?[indexPath.row] else { return UICollectionViewCell() }
        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.isSynchronous = false
        options.deliveryMode = .opportunistic
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 320, height: 320), contentMode: .aspectFill, options: options) { image, infos in
            cell.image = image
        }
        return cell
    }
    
}

private extension AssetListViewController {
    func initView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        title = "图库"
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
