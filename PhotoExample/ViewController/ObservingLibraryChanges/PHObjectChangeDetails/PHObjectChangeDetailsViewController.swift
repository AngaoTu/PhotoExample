//
//  PHObjectChangeDetailsViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/11/13.
//

import Foundation
import UIKit
import Photos

class PHObjectChangeDetailsViewController: BaseTableViewController {
    // MARK: - initialization
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [PHObjectChangeDetailsPropertyType.objectBeforeChanges, PHObjectChangeDetailsPropertyType.objectAfterChanges, PHObjectChangeDetailsPropertyType.assetContentChanged, PHObjectChangeDetailsPropertyType.objectWasDeleted]
        PHPhotoLibrary.shared().register(self)
        
        // 测试PHChange相册的localIdentifier A713B9CA-7A53-4090-A83A-524E0F6D1C48/L0/040
        self.lastAlbum = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: ["A713B9CA-7A53-4090-A83A-524E0F6D1C48/L0/040"], options: nil).firstObject
        
        // 测试图片lcoalIdentidier A713B9CA-7A53-4090-A83A-524E0F6D1C48/L0/040
        self.lastAsset = PHAsset.fetchAssets(withLocalIdentifiers: ["F83DDBC0-80E3-4CBE-997E-34869510A4F0/L0/001"], options: nil).firstObject
    }
    
    override func initView() {
        super.initView()
        self.title = "PHObjectChangeDetails模型"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
        tableView.rowHeight = 140
    }
    
    // MARK: - Private Property
    private var lastAlbum: PHAssetCollection? = nil
    private var lastAsset: PHAsset? = nil
    private var currentObjectChangeDetails: PHObjectChangeDetails? = nil
}

extension PHObjectChangeDetailsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell, let type = dataList[indexPath.row] as? PHObjectChangeDetailsPropertyType else {
            return UITableViewCell()
        }
        
        var textString = ""
        switch type {
        case .objectBeforeChanges:
            textString = objectBeforeChanges()
        case .objectAfterChanges:
            textString = objectAfterChanges()
        case .assetContentChanged:
            textString = assetContentChanged()
        case .objectWasDeleted:
            textString = objectWasDeleted()
        }
        cell.textString = "\(type): \(textString)"
        return cell
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension PHObjectChangeDetailsViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        ATLog("照片库资源变化", funcName: "photoLibraryDidChange(_ changeInstance: PHChange)")
//        self.currentObjectChangeDetails = changeInstance.changeDetails(for: self.lastAlbum!)
        self.currentObjectChangeDetails = changeInstance.changeDetails(for: self.lastAsset!)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Private Method
private extension PHObjectChangeDetailsViewController {
    func objectBeforeChanges() -> String {
        /*
         // 反映其代表的资产或集合的原始状态的对象。
         @available(iOS 8, *)
         open var objectBeforeChanges: ObjectType { get }
         */
        return "\(self.currentObjectChangeDetails?.objectBeforeChanges)"
    }
    
    func objectAfterChanges() -> String {
        /*
         // 反映其代表的资产或集合的当前状态的对象。
         @available(iOS 8, *)
         open var objectAfterChanges: ObjectType? { get }
         */
        return "\(self.currentObjectChangeDetails?.objectAfterChanges)"
    }
    
    func assetContentChanged() -> String {
        /*
         // 一个布尔值，指示资产的照片或视频内容是否已更改
         @available(iOS 8, *)
         open var assetContentChanged: Bool { get }
         */
        return "\(self.currentObjectChangeDetails?.assetContentChanged)"
    }
    
    func objectWasDeleted() -> String {
        /*
         // 一个布尔值，指示对象是否已从照片库中删除
         @available(iOS 8, *)
         open var objectWasDeleted: Bool { get }
         */
        return "\(self.currentObjectChangeDetails?.objectWasDeleted)"
    }
}

private enum PHObjectChangeDetailsPropertyType: String {
    case objectBeforeChanges
    case objectAfterChanges
    case assetContentChanged
    case objectWasDeleted
}
