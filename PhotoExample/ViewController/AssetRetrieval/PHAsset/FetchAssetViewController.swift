//
//  FetchAssetViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/21.
//

import UIKit
import Photos

class FetchAssetViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataList = [FetchAssetType.assetModel, FetchAssetType.fetchAllAssets, FetchAssetType.fetchImageAssets, FetchAssetType.fetchVedioAssets, FetchAssetType.fetchCollectionAssets, FetchAssetType.fetchAssetsByLocalIdentifiers]
    }
    
    override func initView() {
        super.initView()
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
    }
}

extension FetchAssetViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        cell.textString = (dataList[indexPath.row] as? FetchAssetType)?.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = dataList[indexPath.row] as? FetchAssetType else { return }
        switch type {
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
    func assetModel() {
        guard let asset = PHAsset.fetchAssets(with: .image, options: nil).firstObject else { return }
        let assetModelViewController = PHAssetViewController(asset: asset, isShowMethod: true)
        self.navigationController?.pushViewController(assetModelViewController, animated: true)
    }
    
    func fetchAllAssets() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let allAssets = PHAsset.fetchAssets(with: fetchOptions)
        skipAssetListViewController(fetchResult: allAssets)
    }
    
    func fetchImageAssets() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let imageAssets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        skipAssetListViewController(fetchResult: imageAssets)
    }
    
    func fetchVedioAssets() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let vedioAssets = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        skipAssetListViewController(fetchResult: vedioAssets)
    }
    
    func fetchCollectionAssets() {
        // ?????????????????????
        guard let lastAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil).lastObject else { return }
        // ?????????????????????????????????
        let assets = PHAsset.fetchAssets(in: lastAlbum, options: nil)
        skipAssetListViewController(fetchResult: assets)
    }
    
    func fetchAsetsByLocalIdentifiers() {
        // ???????????????????????????localIdentifier?????????PHAsset??????????????????????????????localIdentifier??????????????????????????????????????????
        // ?????????????????????
        guard let firstAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil).firstObject else { return }
        // ????????????????????????asset
        let assets = PHAsset.fetchAssets(in: firstAlbum, options: nil)
        // ????????????????????????????????????localIdentifier
        var localIdentifiers: [String] = []
        for i in 0..<assets.count {
            let asset = assets[i]
            localIdentifiers.append(asset.localIdentifier)
        }
        // ?????????localIdentifers????????????????????????
        let assetsByLocalIdentifiers = PHAsset.fetchAssets(withLocalIdentifiers: localIdentifiers, options: nil)
        skipAssetListViewController(fetchResult: assetsByLocalIdentifiers)
    }
    
    func skipAssetListViewController(fetchResult: PHFetchResult<PHAsset>) {
        let assetListViewController = AssetListViewController(fetchResult: fetchResult)
        self.navigationController?.pushViewController(assetListViewController, animated: true)
    }
}

enum FetchAssetType: String {
    case assetModel = "PHAsset??????"
    case fetchAllAssets = "??????????????????"
    case fetchImageAssets = "????????????"
    case fetchVedioAssets = "????????????"
    case fetchCollectionAssets = "?????????????????????"
    case fetchAssetsByLocalIdentifiers = "??????LocalId????????????"
}
