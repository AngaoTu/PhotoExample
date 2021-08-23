//
//  FetchAlbumViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/21.
//

import UIKit
import Photos

class FetchCollectionViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataList = [FetchAlbumType.assetCollection, FetchAlbumType.collectionList, FetchAlbumType.album, FetchAlbumType.smartAlbum, FetchAlbumType.momentAlbum]
    }
    
    override func initView() {
        super.initView()
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
    }
}

extension FetchCollectionViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        cell.textString = (dataList[indexPath.row] as? FetchAlbumType)?.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = dataList[indexPath.row] as? FetchAlbumType else { return }
        switch type {
        case .assetCollection:
            guard let albumResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil).firstObject else { return }
            let assetCollectionViewController = PHAssetCollectionViewController(assetCollection: albumResult)
            self.navigationController?.pushViewController(assetCollectionViewController, animated: true)
        case .collectionList:
            guard let collectionList = PHCollectionList.fetchCollectionLists(with: .smartFolder, subtype: .any, options: nil).firstObject else {
                return
            }
            let collectionListViewController = PHCollectionListViewController(collectionList: collectionList)
            self.navigationController?.pushViewController(collectionListViewController, animated: true)
        case .album:
            fetchAlbum()
        case .smartAlbum:
            fetchSmartAlbum()
        case .momentAlbum:
            fetchMomentAlbum()
        }
    }
}

private extension FetchCollectionViewController {
    func fetchAlbum() {
        let albumResults: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        skipAlbumListViewController(title: "我的相册", fetchResult: albumResults)
    }
    
    func fetchSmartAlbum() {
        let smartAlbumResults: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        skipAlbumListViewController(title: "智能相册", fetchResult: smartAlbumResults)
    }
    
    func fetchMomentAlbum() {
        let momentAlbumResults = PHAssetCollection.fetchAssetCollections(with: .moment, subtype: .any, options: nil)
        skipAlbumListViewController(title: "时刻相册", fetchResult: momentAlbumResults)
    }
    
    func skipAlbumListViewController(title: String, fetchResult: PHFetchResult<PHAssetCollection>) {
        let albumListViewController = AlbumListViewController(fetchResult: fetchResult)
        albumListViewController.title = title
        self.navigationController?.pushViewController(albumListViewController, animated: true)
    }
}

enum FetchAlbumType: String {
    case assetCollection = "PHAssetCollection模型"
    case collectionList = "PHCollectionList模型"
    case album = "相册"
    case smartAlbum = "智能相册"
    case momentAlbum = "时刻相册"
}

