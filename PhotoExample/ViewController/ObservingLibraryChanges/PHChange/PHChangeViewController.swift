//
//  PHChangeViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/11/13.
//

import Foundation
import UIKit
import Photos

class PHChangeViewController: BaseTableViewController {
    // MARK: - initialization
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [PHChangeMethodType.changeDetailsForObject, PHChangeMethodType.changeDetailsForFetchResult]
        PHPhotoLibrary.shared().register(self)
        
        // 测试PHChange相册的localIdentifier A713B9CA-7A53-4090-A83A-524E0F6D1C48/L0/040
        self.lastAlbum = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: ["A713B9CA-7A53-4090-A83A-524E0F6D1C48/L0/040"], options: nil).firstObject
    }
    
    override func initView() {
        super.initView()
        self.title = "PHChange模型"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
        tableView.rowHeight = 100
    }
    
    // MARK: - Private Property
    private var lastAlbum: PHAssetCollection? = nil
    private let lastAssetsResult = PHAsset.fetchAssets(with: nil)
    private var currentPHChange: PHChange? = nil
}

extension PHChangeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        cell.textString = (dataList[indexPath.row] as? PHChangeMethodType)?.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = dataList[indexPath.row] as? PHChangeMethodType else { return }
        switch type {
        case .changeDetailsForObject:
            changeDetailsForObject(type: type)
        case .changeDetailsForFetchResult:
            changeDetailsForFetchResult(type: type)
        }
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension PHChangeViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        currentPHChange = changeInstance
        ATLog("照片库资源变化", funcName: "photoLibraryDidChange(_ changeInstance: PHChange)")
    }
}

// MARK: - Private Method
private extension PHChangeViewController {
    func changeDetailsForObject(type: PHChangeMethodType) {
        /*
         // 返回指定资产或集合的详细更改信息
         public func changeDetails<T>(for object: T) -> PHObjectChangeDetails<T>? where T : PHObject
         */
        let objectChange = self.currentPHChange?.changeDetails(for: self.lastAlbum!)
        ATLog("返回指定资产或集合的详细更改信息objectChange = \(objectChange)", funcName: type.rawValue)
    }
    
    func changeDetailsForFetchResult(type: PHChangeMethodType) {
        /*
         // 返回PHFetchResult结果的详细更改信息
         public func changeDetails<T>(for fetchResult: PHFetchResult<T>) -> PHFetchResultChangeDetails<T>? where T : PHObject
         */
        let fetchResultChange = self.currentPHChange?.changeDetails(for: self.lastAssetsResult)
        ATLog("返回PHFetchResult结果的详细更改信息fetchResultChange = \(fetchResultChange)", funcName: type.rawValue)
    }
}

private enum PHChangeMethodType: String {
    case changeDetailsForObject = "changeDetails<T>(for object: T) -> PHObjectChangeDetails<T>? where T : PHObject"
    case changeDetailsForFetchResult = "changeDetails<T>(for fetchResult: PHFetchResult<T>) -> PHFetchResultChangeDetails<T>? where T : PHObject"
}
