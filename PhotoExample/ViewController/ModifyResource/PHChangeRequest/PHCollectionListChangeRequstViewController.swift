//
//  PHCollectionListChangeRequstViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/12/11.
//

import Foundation
import UIKit
import Photos

class PHCollectionListChangeRequestViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [[PHCollectionListChangeRequestPropertyType.placeholderForCreatedCollectionList, PHCollectionListChangeRequestPropertyType.title], [PHCollectionListChangeRequestMethodType.creationRequestForCollectionList, PHCollectionListChangeRequestMethodType.deleteCollectionLists, PHCollectionListChangeRequestMethodType.addChildCollections, PHCollectionListChangeRequestMethodType.insertChildCollections, PHCollectionListChangeRequestMethodType.removeChildCollections, PHCollectionListChangeRequestMethodType.removeChildCollectionsAtIndex, PHCollectionListChangeRequestMethodType.replaceChildCollections, PHCollectionListChangeRequestMethodType.moveChildCollections]]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHCollectionListChangRequest模型"
    }
}

extension PHCollectionListChangeRequestViewController {
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
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHCollectionListChangeRequestPropertyType else { return UITableViewCell () }
            cell.textString = "\(type)"
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHCollectionListChangeRequestMethodType else { return UITableViewCell () }
            cell.textString = "\(type.rawValue)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHCollectionListChangeRequestPropertyType else { return }
            switch type {
            case .placeholderForCreatedCollectionList:
                placeholderForCreatedCollectionList()
            case .title:
                title()
            }
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHCollectionListChangeRequestMethodType else { return }
            switch type {
            case .creationRequestForCollectionList:
                break
            case .deleteCollectionLists:
                deleteCollectionLists(type: type)
            case .addChildCollections:
                addChildCollections(type: type)
            case .insertChildCollections:
                insertChildCollections(type: type)
            case .removeChildCollections:
                removeChildCollections(type: type)
            case .removeChildCollectionsAtIndex:
                removeChildCollectionsAtIndex(type: type)
            case .replaceChildCollections:
                replaceChildCollections(type: type)
            case .moveChildCollections:
                moveChildCollections(type: type)
            }
        }
    }
}

// MARK: - Private Method
private extension PHCollectionListChangeRequestViewController {
    // MARK: Property
    func placeholderForCreatedCollectionList() {
        /*
         // 变更请求创建的资产的占位符对象
         1. 可以使用-localIdentifier在变更块完成后获取新创建的资产
         2. 它也可以直接添加到当前更改块中的集合中
         @available(iOS 8, *)
         open var placeholderForCreatedCollectionList: PHObjectPlaceholder { get }
         */
        var localId = ""
        PHPhotoLibrary.shared().performChanges {
            let request = PHCollectionListChangeRequest.creationRequestForCollectionList(withTitle: "创建一个临时文件夹")
            localId = request.placeholderForCreatedCollectionList.localIdentifier
        } completionHandler: { success, error in
            if success {
                let collectionList = PHCollectionList.fetchCollectionLists(withLocalIdentifiers: [localId], options: nil).firstObject
                ATLog("获取成功 collectionList = \(collectionList)")
            }
        }
    }
    
    func title() {
        /*
         // 集合列表名称
         @available(iOS 8, *)
         open var title: String
         */
        guard let collectionList = PHCollectionList.fetchCollectionLists(with: .folder, subtype: .any, options: nil).firstObject else {
            ATLog("get collectionList fail")
            return
        }
        let localId = collectionList.localIdentifier
        
        PHPhotoLibrary.shared().performChanges {
            let request = PHCollectionListChangeRequest(for: collectionList)
            request?.title = "collectionList 测试"
        } completionHandler: { success, error in
            if success {
                let currentCollectionList = PHCollectionList.fetchCollectionLists(withLocalIdentifiers: [localId], options: nil).firstObject
                ATLog("修改后title = \(currentCollectionList?.localizedTitle)")
            }
        }
    }
    
    // MARK: Method
    func creationRequestForCollectionList(type: PHCollectionListChangeRequestMethodType) {
        /*
         // 创建新的文件夹
         @available(iOS 8, *)
         open class func creationRequestForCollectionList(withTitle title: String) -> Self
         */
    }
    
    func deleteCollectionLists(type: PHCollectionListChangeRequestMethodType) {
        /*
         // 删除指定的文件夹
         // 删除集合列表也会删除其中包含的任何子集合。要保留这些集合，请在删除它们之前从集合列表中删除它们(使用removeChildCollections(_:)或removeChildCollections(at:)方法)。删除集合列表不会删除其子集合中包含的资产。
         @available(iOS 8, *)
         open class func deleteCollectionLists(_ collectionLists: NSFastEnumeration)
         */
        let collectionList = PHCollectionList.fetchCollectionLists(with: .folder, subtype: .any, options: nil)
        var list: [PHCollectionList] = []
        collectionList.enumerateObjects { collectionList, index, stop in
            if collectionList.localizedTitle == "创建一个临时文件夹" {
                list.append(collectionList)
            }
        }
        
        PHPhotoLibrary.shared().performChanges {
            PHCollectionListChangeRequest.deleteCollectionLists(list as NSFastEnumeration)
        } completionHandler: { success, error in
            if success {
                ATLog("删除指定文件夹成功", funcName: type.rawValue)
                let collectionList = PHCollectionList.fetchCollectionLists(with: .folder, subtype: .any, options: nil)
                collectionList.enumerateObjects { collectionList, index, stop in
                    ATLog("collectionList = \(collectionList)")
                }
            }
        }
    }
    
    func addChildCollections(type: PHCollectionListChangeRequestMethodType) {
        /*
         // 添加指定的集合作为文件夹的子项
         @available(iOS 8, *)
         open func addChildCollections(_ collections: NSFastEnumeration)
         */
        
        let collectionListResult = PHCollectionList.fetchCollectionLists(with: .folder, subtype: .any, options: nil)
        var currentCollectionList: PHCollectionList? = nil
        collectionListResult.enumerateObjects { collectionList, index, stop in
            if collectionList.localizedTitle == "collectionList 测试" {
                currentCollectionList = collectionList
            }
        }
        PHPhotoLibrary.shared().performChanges {
            let request = PHCollectionListChangeRequest(for: currentCollectionList!)
            let collectionListPlaceholder = PHCollectionListChangeRequest.creationRequestForCollectionList(withTitle: "测试addChildCollections").placeholderForCreatedCollectionList
            request?.addChildCollections([collectionListPlaceholder] as NSFastEnumeration)
        } completionHandler: { success, error in
            if success {
                ATLog("添加指定的集合作为文件夹的子项成功", funcName: type.rawValue)
                let collectionList = PHCollectionList.fetchCollectionLists(with: .folder, subtype: .any, options: nil)
                collectionList.enumerateObjects { collectionList, index, stop in
                    ATLog("collectionList = \(collectionList)")
                }
            }
        }
    }
    
    func insertChildCollections(type: PHCollectionListChangeRequestMethodType) {
        /*
         // 将指定的集合添加到文件夹指定索引处
         // 为了确保您指定的索引集是有效的，即使从获取集合列表以来已经发生了更改，在插入子集合之前，使用init(for:childCollections:)方法创建一个更改请求，其中包含集合列表内容的快照。
         @available(iOS 8, *)
         open func insertChildCollections(_ collections: NSFastEnumeration, at indexes: IndexSet)
         */
        
        let collectionListResult = PHCollectionList.fetchCollectionLists(with: .folder, subtype: .any, options: nil)
        var currentCollectionList: PHCollectionList? = nil
        collectionListResult.enumerateObjects { collectionList, index, stop in
            if collectionList.localizedTitle == "collectionList 测试" {
                currentCollectionList = collectionList
            }
        }
        
        // 获取该文件夹的子集合
        let childCollectionListReusult = PHCollection.fetchCollections(in: currentCollectionList!, options: nil)
        
        PHPhotoLibrary.shared().performChanges {
            let request = PHCollectionListChangeRequest(for: currentCollectionList!, childCollections: childCollectionListReusult)
            let collectionListPlaceholder = PHCollectionListChangeRequest.creationRequestForCollectionList(withTitle: "测试insertChildCollections index = 1").placeholderForCreatedCollectionList
            request?.insertChildCollections([collectionListPlaceholder] as NSFastEnumeration, at: IndexSet(integer: 1))
        } completionHandler: { success, error in
            if success {
                ATLog("将指定的集合添加到文件夹指定索引处", funcName: type.rawValue)
                let collectionList = PHCollectionList.fetchCollectionLists(with: .folder, subtype: .any, options: nil)
                collectionList.enumerateObjects { collectionList, index, stop in
                    ATLog("collectionList = \(collectionList)")
                }
            }
        }
    }
    
    func removeChildCollections(type: PHCollectionListChangeRequestMethodType) {
        /*
         // 从文件夹中删除指定的集合
         @available(iOS 8, *)
         open func removeChildCollections(_ collections: NSFastEnumeration)
         */
        let collectionListResult = PHCollectionList.fetchCollectionLists(with: .folder, subtype: .any, options: nil)
        var currentCollectionList: PHCollectionList? = nil
        collectionListResult.enumerateObjects { collectionList, index, stop in
            if collectionList.localizedTitle == "collectionList 测试" {
                currentCollectionList = collectionList
            }
        }
        
        // 获取该文件夹的子集合
        let childCollectionListReusult = PHCollection.fetchCollections(in: currentCollectionList!, options: nil)
        var removeCollection: PHCollection? = nil
        childCollectionListReusult.enumerateObjects { collectionList, index, stop in
            if collectionList.localizedTitle == "测试addChildCollections" {
                removeCollection = collectionList
            }
        }
        
        PHPhotoLibrary.shared().performChanges {
            let request = PHCollectionListChangeRequest(for: currentCollectionList!)
            request?.removeChildCollections([removeCollection] as NSFastEnumeration)
        } completionHandler: { success, error in
            if success {
                ATLog("从文件夹中删除指定的集合", funcName: type.rawValue)
                let collectionList = PHCollectionList.fetchCollectionLists(with: .folder, subtype: .any, options: nil)
                collectionList.enumerateObjects { collectionList, index, stop in
                    ATLog("collectionList = \(collectionList)")
                }
            }
        }
    }
    
    func removeChildCollectionsAtIndex(type: PHCollectionListChangeRequestMethodType) {
        /*
         // 从文件夹中删除指定索引处的集合
         // 为了确保您指定的索引集是有效的，即使从获取集合列表以来已经发生了更改，在删除子集合之前，使用init(for:childCollections:)方法创建一个更改请求，其中包含集合列表内容的快照。要根据对象的标识(不考虑它们在集合中的索引)删除对象，请使用removeChildCollections(_:)方法。
         @available(iOS 8, *)
         open func removeChildCollections(at indexes: IndexSet)
         */
        let collectionListResult = PHCollectionList.fetchCollectionLists(with: .folder, subtype: .any, options: nil)
        var currentCollectionList: PHCollectionList? = nil
        collectionListResult.enumerateObjects { collectionList, index, stop in
            if collectionList.localizedTitle == "collectionList 测试" {
                currentCollectionList = collectionList
            }
        }
        
        // 获取该文件夹的子集合
        let childCollectionListReusult = PHCollection.fetchCollections(in: currentCollectionList!, options: nil)
        
        PHPhotoLibrary.shared().performChanges {
            let request = PHCollectionListChangeRequest(for: currentCollectionList!, childCollections: childCollectionListReusult)
            request?.removeChildCollections(at: IndexSet(integer: 1))
        } completionHandler: { success, error in
            if success {
                ATLog("从文件夹中删除指定索引处的集合", funcName: type.rawValue)
                let collectionList = PHCollectionList.fetchCollectionLists(with: .folder, subtype: .any, options: nil)
                collectionList.enumerateObjects { collectionList, index, stop in
                    ATLog("collectionList = \(collectionList)")
                }
            }
        }
        
    }
    
    func replaceChildCollections(type: PHCollectionListChangeRequestMethodType) {
        /*
         // 用指定的集合替换文件夹中指定索引处集合
         // 为了确保您指定的索引集是有效的，即使从获取集合列表以来已经发生了更改，在删除子集合之前，使用init(for:childCollections:)方法创建一个更改请求，其中包含集合列表内容的快照。要根据对象的标识(不考虑它们在集合中的索引)删除对象，请使用removeChildCollections(_:)方法。
         @available(iOS 8, *)
         open func replaceChildCollections(at indexes: IndexSet, withChildCollections collections: NSFastEnumeration)
         */
        
        let collectionListResult = PHCollectionList.fetchCollectionLists(with: .folder, subtype: .any, options: nil)
        var currentCollectionList: PHCollectionList? = nil
        collectionListResult.enumerateObjects { collectionList, index, stop in
            if collectionList.localizedTitle == "collectionList 测试" {
                currentCollectionList = collectionList
            }
        }
        
        // 获取该文件夹的子集合
        let childCollectionListReusult = PHCollection.fetchCollections(in: currentCollectionList!, options: nil)
        
        PHPhotoLibrary.shared().performChanges {
            let request = PHCollectionListChangeRequest(for: currentCollectionList!, childCollections: childCollectionListReusult)
            let collectionListPlaceholder = PHCollectionListChangeRequest.creationRequestForCollectionList(withTitle: "测试replaceChildCollections").placeholderForCreatedCollectionList
            request?.replaceChildCollections(at: IndexSet(integer: 0), withChildCollections: [collectionListPlaceholder] as NSFastEnumeration)
        } completionHandler: { success, error in
            if success {
                ATLog("用指定的集合替换文件夹中指定索引处集合", funcName: type.rawValue)
            }
        }
    }
    
    func moveChildCollections(type: PHCollectionListChangeRequestMethodType) {
        /*
         // 将文件夹中指定索引处的集合移动到新的索引处
         // 当调用此方法时，Photos首先从集合中删除索引参数中的项，然后将它们插入toIndex参数指定的位置。
         // 为了确保您指定的索引集是有效的，即使从获取集合列表以来已经发生了更改，在重新安排子集合之前，使用init(for:childCollections:)方法创建一个更改请求，其中包含集合列表内容的快照。
         @available(iOS 8, *)
         open func moveChildCollections(at indexes: IndexSet, to toIndex: Int)
         */
        
        let collectionListResult = PHCollectionList.fetchCollectionLists(with: .folder, subtype: .any, options: nil)
        var currentCollectionList: PHCollectionList? = nil
        collectionListResult.enumerateObjects { collectionList, index, stop in
            if collectionList.localizedTitle == "collectionList 测试" {
                currentCollectionList = collectionList
            }
        }
        
        // 获取该文件夹的子集合
        let childCollectionListReusult = PHCollection.fetchCollections(in: currentCollectionList!, options: nil)
        
        PHPhotoLibrary.shared().performChanges {
            let request = PHCollectionListChangeRequest(for: currentCollectionList!, childCollections: childCollectionListReusult)
            request?.moveChildCollections(at: IndexSet(integer: 2), to: 0)
        } completionHandler: { success, error in
            if success {
                ATLog("将文件夹中指定索引处的集合移动到新的索引处", funcName: type.rawValue)
            }
        }
    }
}

private enum PHCollectionListChangeRequestPropertyType: String {
    case placeholderForCreatedCollectionList
    case title
}

private enum PHCollectionListChangeRequestMethodType: String {
    // 管理集合列表
    case creationRequestForCollectionList = "creationRequestForCollectionList(withTitle title: String) -> Self"
    case deleteCollectionLists = "deleteCollectionLists(_ collectionLists: NSFastEnumeration)"
    
    // 管理集合
    case addChildCollections = "addChildCollections(_ collections: NSFastEnumeration)"
    case insertChildCollections = "insertChildCollections(_ collections: NSFastEnumeration, at indexes: IndexSet)"
    case removeChildCollections = "removeChildCollections(_ collections: NSFastEnumeration)"
    case removeChildCollectionsAtIndex = "removeChildCollections(at indexes: IndexSet)"
    case replaceChildCollections = "replaceChildCollections(at indexes: IndexSet, withChildCollections collections: NSFastEnumeration)"
    case moveChildCollections = "moveChildCollections(at indexes: IndexSet, to toIndex: Int)"
}
