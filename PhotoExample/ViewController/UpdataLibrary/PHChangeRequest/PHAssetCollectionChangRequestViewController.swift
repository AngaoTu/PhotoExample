//
//  PHAssetCollectionChangRequest.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/12/11.
//

import Foundation
import UIKit
import Photos

class PHAssetCollectionChangeRequestViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [[PHAssetCollectionChangeRequestPropertyType.placeholderForCreatedAssetCollection, PHAssetCollectionChangeRequestPropertyType.title], [PHAssetColletionChangeRequestMethodType.creationRequestForAssetCollection, PHAssetColletionChangeRequestMethodType.deleteAssetCollections, PHAssetColletionChangeRequestMethodType.addAssets, PHAssetColletionChangeRequestMethodType.insertAssets, PHAssetColletionChangeRequestMethodType.removeAssets, PHAssetColletionChangeRequestMethodType.removeAssetsAtIndex, PHAssetColletionChangeRequestMethodType.replaceAssets, PHAssetColletionChangeRequestMethodType.moveAssets]]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHAssetCollectionChangeRequest模型"
    }
}

extension PHAssetCollectionChangeRequestViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        } else {
            return 80
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = dataList[section] as? [Any] else {
            return 0
        }
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.section == 0 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetCollectionChangeRequestPropertyType else { return UITableViewCell () }
            cell.textString = "\(type)"
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetColletionChangeRequestMethodType else { return UITableViewCell () }
            cell.textString = "\(type.rawValue)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetCollectionChangeRequestPropertyType else { return }
            switch type {
            case .placeholderForCreatedAssetCollection:
                placeholderForCreatedAssetCollection()
            case .title:
                title()
            }
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetColletionChangeRequestMethodType else { return }
            switch type {
            case .creationRequestForAssetCollection:
                creationRequestForAssetCollection(type: type)
            case .deleteAssetCollections:
                deleteAssetCollections(type: type)
            case .addAssets:
                addAssets(type: type)
            case .insertAssets:
                insertAssets(type: type)
            case .removeAssets:
                removeAssets(type: type)
            case .removeAssetsAtIndex:
                removeAssetsAtIndex(type: type)
            case .replaceAssets:
                replaceAssets(type: type)
            case .moveAssets:
                moveAssets(type: type)
            }
        }
    }
}

// MARK: - Private Method
private extension PHAssetCollectionChangeRequestViewController {
    // MARK: Property
    func placeholderForCreatedAssetCollection() {
        /*
         // 变更请求创建的资产的占位符对象
         1. 可以使用-localIdentifier在变更块完成后获取新创建的资产
         2. 它也可以直接添加到当前更改块中的集合中
         @available(iOS 8, *)
         open var placeholderForCreatedAssetCollection: PHObjectPlaceholder { get }
         */
        
        var localId = ""
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "创建assetCollection")
            localId = request.placeholderForCreatedAssetCollection.localIdentifier
        } completionHandler: { success, error in
            if success {
                let assetCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [localId], options: nil).firstObject
                ATLog("获取成功 assetCollection = \(assetCollection)")
            }
        }
    }
    
    func title() {
        /*
         // 资产集合的名称
         @available(iOS 8, *)
         open var title: String
         */
        let assetCollectionResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        var currentAssetCollection:PHAssetCollection? = nil
        assetCollectionResult.enumerateObjects { assetCollection, index, stop in
            if assetCollection.localizedTitle == "创建assetCollection" {
                currentAssetCollection = assetCollection
            }
        }
        
        PHPhotoLibrary.shared().performChanges {
            let requet = PHAssetCollectionChangeRequest(for: currentAssetCollection!)
            requet?.title = "Test assetCollection"
        } completionHandler: { success, error in
            if success {
                let assetCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [currentAssetCollection!.localIdentifier], options: nil).firstObject
                ATLog("修改后title = \(assetCollection?.localizedTitle)")
            }
        }
    }
    
    // MARK: Method
    func creationRequestForAssetCollection(type: PHAssetColletionChangeRequestMethodType) {
        /*
         // 创建新的集合
         @available(iOS 8, *)
         open class func creationRequestForAssetCollection(withTitle title: String) -> Self
         */
    }
    
    func deleteAssetCollections(type: PHAssetColletionChangeRequestMethodType) {
        /*
         // 删除指定集合
         @available(iOS 8, *)
         open class func deleteAssetCollections(_ assetCollections: NSFastEnumeration)
         */
        
        let assetCollectionResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        var deleteAssetCollection:PHAssetCollection? = nil
        assetCollectionResult.enumerateObjects { assetCollection, index, stop in
            if assetCollection.localizedTitle == "Test assetCollection" {
                deleteAssetCollection = assetCollection
            }
        }
        
        PHPhotoLibrary.shared().performChanges {
            PHAssetCollectionChangeRequest.deleteAssetCollections([deleteAssetCollection!] as NSFastEnumeration)
        } completionHandler: { success, error in
            if success {
                ATLog("删除指定集合", funcName: type.rawValue)
                let assetCollection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
                assetCollection.enumerateObjects { assetCollection, index, stop in
                    ATLog("assetCollection = \(assetCollection)")
                }
            }
        }
    }
    
    func addAssets(type: PHAssetColletionChangeRequestMethodType) {
        /*
         // 将指定资产添加到集合中
         @available(iOS 8, *)
         open func addAssets(_ assets: NSFastEnumeration)
         */
        let assetCollectionResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        var currentAssetCollection:PHAssetCollection? = nil
        assetCollectionResult.enumerateObjects { assetCollection, index, stop in
            if assetCollection.localizedTitle == "Test assetCollection" {
                currentAssetCollection = assetCollection
            }
        }
        
        let lastAsset = PHAsset.fetchAssets(with: .image, options: nil).lastObject
        
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetCollectionChangeRequest(for: currentAssetCollection!)
            request?.addAssets([lastAsset!] as NSFastEnumeration)
        } completionHandler: { success, error in
            if success {
                ATLog("将指定资产添加到集合中", funcName: type.rawValue)
            }
        }
    }
    
    func insertAssets(type: PHAssetColletionChangeRequestMethodType) {
        /*
         // 将指定的资产插入到指定索引处的集合中
         @available(iOS 8, *)
         open func insertAssets(_ assets: NSFastEnumeration, at indexes: IndexSet)
         */
        let assetCollectionResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        var currentAssetCollection:PHAssetCollection? = nil
        assetCollectionResult.enumerateObjects { assetCollection, index, stop in
            if assetCollection.localizedTitle == "Test assetCollection" {
                currentAssetCollection = assetCollection
            }
        }
        
        // 取出这个集合的assets
        guard let currentAssetCollectionAssets = PHAsset.fetchKeyAssets(in: currentAssetCollection!, options: nil) else { return }
        
        let asset = PHAsset.fetchAssets(with: .image, options: nil).firstObject
        
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetCollectionChangeRequest(for: currentAssetCollection!, assets: currentAssetCollectionAssets)
            request?.insertAssets([asset] as NSFastEnumeration, at: IndexSet(integer: 0))
        } completionHandler: { success, error in
            if success {
                ATLog("将指定资产添加到集合中", funcName: type.rawValue)
            }
        }
    }
    
    func removeAssets(type: PHAssetColletionChangeRequestMethodType) {
        /*
         // 从集合中移除指定的资产
         @available(iOS 8, *)
         open func removeAssets(_ assets: NSFastEnumeration)
         */
        let assetCollectionResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        var currentAssetCollection:PHAssetCollection? = nil
        assetCollectionResult.enumerateObjects { assetCollection, index, stop in
            if assetCollection.localizedTitle == "Test assetCollection" {
                currentAssetCollection = assetCollection
            }
        }
        
        // 取出这个集合的firstAsset
        guard let firstAsset = PHAsset.fetchKeyAssets(in: currentAssetCollection!, options: nil)?.firstObject else { return }
        
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetCollectionChangeRequest(for: currentAssetCollection!)
            request?.removeAssets([firstAsset] as NSFastEnumeration)
        } completionHandler: { success, error in
            if success {
                ATLog("从集合中移除指定的资产", funcName: type.rawValue)
            }
        }
    }
    
    func removeAssetsAtIndex(type: PHAssetColletionChangeRequestMethodType) {
        /*
         // 从集合中删除指定索引处的资产
         @available(iOS 8, *)
         open func removeAssets(at indexes: IndexSet)
         */
        let assetCollectionResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        var currentAssetCollection:PHAssetCollection? = nil
        assetCollectionResult.enumerateObjects { assetCollection, index, stop in
            if assetCollection.localizedTitle == "Test assetCollection" {
                currentAssetCollection = assetCollection
            }
        }
        
        // 取出这个集合的assets
        guard let currentAssetCollectionAssets = PHAsset.fetchKeyAssets(in: currentAssetCollection!, options: nil) else { return }
        
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetCollectionChangeRequest(for: currentAssetCollection!, assets: currentAssetCollectionAssets)
            request?.removeAssets(at: IndexSet(integer: 0))
        } completionHandler: { success, error in
            if success {
                ATLog("从集合中删除指定索引处的资产", funcName: type.rawValue)
            }
        }
    }
    
    func replaceAssets(type: PHAssetColletionChangeRequestMethodType) {
        /*
         // 用指定的资产替换集合中指定索引处的资产
         @available(iOS 8, *)
         open func replaceAssets(at indexes: IndexSet, withAssets assets: NSFastEnumeration)
         */
        let assetCollectionResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        var currentAssetCollection:PHAssetCollection? = nil
        assetCollectionResult.enumerateObjects { assetCollection, index, stop in
            if assetCollection.localizedTitle == "Test assetCollection" {
                currentAssetCollection = assetCollection
            }
        }
        
        // 取出这个集合的assets
        guard let currentAssetCollectionAssets = PHAsset.fetchKeyAssets(in: currentAssetCollection!, options: nil) else { return }
        
        let firstAsset = PHAsset.fetchAssets(with: .image, options: nil).firstObject
        
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetCollectionChangeRequest(for: currentAssetCollection!, assets: currentAssetCollectionAssets)
            request?.replaceAssets(at: IndexSet(integer: 0), withAssets: [firstAsset] as NSFastEnumeration)
        } completionHandler: { success, error in
            if success {
                ATLog("用指定的资产替换集合中指定索引处的资产", funcName: type.rawValue)
            }
        }
    }
    
    func moveAssets(type: PHAssetColletionChangeRequestMethodType) {
        /*
         // 将集合中指定索引处的资产移动到新索引
         @available(iOS 8, *)
         open func moveAssets(at fromIndexes: IndexSet, to toIndex: Int)
         */
        let assetCollectionResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        var currentAssetCollection:PHAssetCollection? = nil
        assetCollectionResult.enumerateObjects { assetCollection, index, stop in
            if assetCollection.localizedTitle == "Test assetCollection" {
                currentAssetCollection = assetCollection
            }
        }
        
        // 取出这个集合的assets
        guard let currentAssetCollectionAssets = PHAsset.fetchKeyAssets(in: currentAssetCollection!, options: nil) else { return }
        
        
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetCollectionChangeRequest(for: currentAssetCollection!, assets: currentAssetCollectionAssets)
            request?.moveAssets(at: IndexSet(integer: 0), to: 1)
        } completionHandler: { success, error in
            if success {
                ATLog("将集合中指定索引处的资产移动到新索引", funcName: type.rawValue)
            }
        }
    }
}

private enum PHAssetCollectionChangeRequestPropertyType: String {
    case placeholderForCreatedAssetCollection
    case title
}

private enum PHAssetColletionChangeRequestMethodType: String {
    // 管理资产集合
    case creationRequestForAssetCollection = "creationRequestForAssetCollection(withTitle title: String) -> Self"
    case deleteAssetCollections = "deleteAssetCollections(_ assetCollections: NSFastEnumeration)"
    
    // 管理资产
    case addAssets = "addAssets(_ assets: NSFastEnumeration)"
    case insertAssets = "insertAssets(_ assets: NSFastEnumeration, at indexes: IndexSet)"
    case removeAssets = "removeAssets(_ assets: NSFastEnumeration)"
    case removeAssetsAtIndex = "removeAssets(at indexes: IndexSet)"
    case replaceAssets = "replaceAssets(at indexes: IndexSet, withAssets assets: NSFastEnumeration)"
    case moveAssets = "moveAssets(at fromIndexes: IndexSet, to toIndex: Int)"
}
