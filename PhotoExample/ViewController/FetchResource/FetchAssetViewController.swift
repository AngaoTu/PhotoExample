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
            break
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
    
    func fetchAllAssets() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let allAssets = PHAsset.fetchAssets(with: fetchOptions)
        skipAssetListViewController(fetchResult: allAssets)
    }
    
    func fetchImageAssets() {
        
    }
    
    func fetchVedioAssets() {
        
    }
    
    func fetchCollectionAssets() {
        
    }
    
    func fetchAsetsByLocalIdentifiers() {
        
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
//@available(iOS 8, *)
//open class func fetchAssets(in assetCollection: PHAssetCollection, options: PHFetchOptions?) -> PHFetchResult<PHAsset>
//
//@available(iOS 8, *)
//open class func fetchAssets(withLocalIdentifiers identifiers: [String], options: PHFetchOptions?) -> PHFetchResult<PHAsset> // includes hidden assets by default
//
//@available(iOS 8, *)
//open class func fetchKeyAssets(in assetCollection: PHAssetCollection, options: PHFetchOptions?) -> PHFetchResult<PHAsset>?
//
//@available(iOS 8, *)
//open class func fetchAssets(withBurstIdentifier burstIdentifier: String, options: PHFetchOptions?) -> PHFetchResult<PHAsset>
//
//
//// Fetches PHAssetSourceTypeUserLibrary assets by default (use includeAssetSourceTypes option to override)
//@available(iOS 8, *)
//open class func fetchAssets(with options: PHFetchOptions?) -> PHFetchResult<PHAsset>
//
//@available(iOS 8, *)
//open class func fetchAssets(with mediaType: PHAssetMediaType, options: PHFetchOptions?) -> PHFetchResult<PHAsset>
