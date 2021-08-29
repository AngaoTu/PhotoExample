//
//  FetchResourceViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/21.
//

import UIKit
import Photos

class AssetRetrievalViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataList = [FetchResourceType.album, FetchResourceType.asset, FetchResourceType.fetchResult]
    }
    
    override func initView() {
        super.initView()
        self.title = "获取资源"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
    }
}

extension AssetRetrievalViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        cell.textString = (dataList[indexPath.row] as? FetchResourceType)?.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = dataList[indexPath.row] as? FetchResourceType else { return }
        switch type {
        case .album:
            let fetchAlbumViewController = FetchCollectionViewController()
            self.navigationController?.pushViewController(fetchAlbumViewController, animated: true)
        case .asset:
            let fetchAssetViewController = FetchAssetViewController()
            self.navigationController?.pushViewController(fetchAssetViewController, animated: true)
        case .fetchResult:
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            let allAssets = PHAsset.fetchAssets(with: fetchOptions)
            let fetchResultViewController = PHFetchResultViewController(fetchResult: allAssets)
            self.navigationController?.pushViewController(fetchResultViewController, animated: true)
        case .fetchOptions:
            let fetchOptionsViewController = PHFetchOptionsViewController()
            self.navigationController?.pushViewController(fetchOptionsViewController, animated: true)
        }
    }
}

enum FetchResourceType: String {
    case album = "相册资源"
    case asset = "照片资源"
    case fetchResult = "PHFetchResult"
    case fetchOptions = "PHFetchOptions"
}
