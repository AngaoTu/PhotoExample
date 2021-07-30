//
//  FetchAssetViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/21.
//

import UIKit
import Photos

class FetchAssetViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    // MARK: - 私有属性
    private lazy var tableView: UITableView = {
        let temp = UITableView()
        temp.delegate = self
        temp.dataSource = self
        temp.rowHeight = 44
        temp.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
        return temp
    }()
    
    private let dataList: [FetchAssetType] = [.assetModel, .fetchAllAssets, .fetchImageAssets, .fetchVedioAssets, .fetchCollectionAssets, .fetchAssetsByLocalIdentifiers]
}

extension FetchAssetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        cell.textString = dataList[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataList[indexPath.row] {
        case .assetModel:
            assetModel()
        case .fetchAllAssets:
            fetchAllAssets()
        case .fetchImageAssets:
            fetchImageAssets()
        case .fetchVedioAssets:
            fetchVedioAssets()
        case .fetchCollectionAssets:
            fetchCollectionAssets()
        case .fetchAssetsByLocalIdentifiers:
            fetchAsetsByLocalIdentifiers()
        }
    }
}

private extension FetchAssetViewController {
    func initView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func assetModel() {
        guard let asset = PHAsset.fetchAssets(with: .image, options: nil).firstObject else { return }
        let assetModelViewController = PHAssetViewController(asset: asset)
        self.navigationController?.pushViewController(assetModelViewController, animated: true)
    }
    
    func fetchAllAssets() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let allAssets = PHAsset.fetchAssets(with: fetchOptions)
        skipAssetListViewController(fetchResult: allAssets)
    }
    
    func fetchImageAssets() {
        let imageAssets = PHAsset.fetchAssets(with: .image, options: nil)
        skipAssetListViewController(fetchResult: imageAssets)
    }
    
    func fetchVedioAssets() {
        let vedioAssets = PHAsset.fetchAssets(with: .video, options: nil)
        skipAssetListViewController(fetchResult: vedioAssets)
    }
    
    func fetchCollectionAssets() {
        // 先获取一个相册
        guard let lastAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil).lastObject else { return }
        // 然后再获取该相册中图片
        let assets = PHAsset.fetchAssets(in: lastAlbum, options: nil)
        skipAssetListViewController(fetchResult: assets)
    }
    
    func fetchAsetsByLocalIdentifiers() {
        // 这是为了举一个通过localIdentifier来获取PHAsset例子，由于没有现成的localIdentifier，所以采用以下方式绕了一个圈
        // 先获取一个相册
        guard let firstAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil).firstObject else { return }
        // 先获取该相册所有asset
        let assets = PHAsset.fetchAssets(in: firstAlbum, options: nil)
        // 再获取该相册中所有图片的localIdentifier
        var localIdentifiers: [String] = []
        for i in 0..<assets.count {
            let asset = assets[i]
            localIdentifiers.append(asset.localIdentifier)
        }
        // 再通过localIdentifers来获取对应的图片
        let assetsByLocalIdentifiers = PHAsset.fetchAssets(withLocalIdentifiers: localIdentifiers, options: nil)
        skipAssetListViewController(fetchResult: assetsByLocalIdentifiers)
    }
    
    func skipAssetListViewController(fetchResult: PHFetchResult<PHAsset>) {
        let assetListViewController = AssetListViewController(fetchResult: fetchResult)
        self.navigationController?.pushViewController(assetListViewController, animated: true)
    }
}

enum FetchAssetType: String {
    case assetModel = "PHAsset模型"
    case fetchAllAssets = "拉取所有资源"
    case fetchImageAssets = "拉取图片"
    case fetchVedioAssets = "拉取视频"
    case fetchCollectionAssets = "拉取相册中资源"
    case fetchAssetsByLocalIdentifiers = "通过LocalId拉取资源"
}
