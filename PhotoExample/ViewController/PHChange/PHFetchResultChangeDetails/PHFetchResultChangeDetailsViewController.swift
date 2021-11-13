//
//  PHFetchResultChangeDetailsViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/11/13.
//

import Foundation
import UIKit
import Photos

class PHFetchResultChangeDetailsViewController: BaseTableViewController {
    // MARK: - initialization
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [[PHFetchResultChangeDetailsPropertyType.fetchResultBeforeChanges, PHFetchResultChangeDetailsPropertyType.fetchResultAfterChanges, PHFetchResultChangeDetailsPropertyType.hasIncrementalChanges, PHFetchResultChangeDetailsPropertyType.removedIndexes, PHFetchResultChangeDetailsPropertyType.removedObjects, PHFetchResultChangeDetailsPropertyType.insertedIndexes, PHFetchResultChangeDetailsPropertyType.insertedObjects, PHFetchResultChangeDetailsPropertyType.changedIndexes, PHFetchResultChangeDetailsPropertyType.changedObjects, PHFetchResultChangeDetailsPropertyType.hasMoves], [PHFetchResultChangeDetailsMethodType.enumerateMoves]]
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
        PHPhotoLibrary.shared().register(self)
    }
    
    override func initView() {
        super.initView()
        self.title = "PHFetchResultChangeDetails模型"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
        tableView.rowHeight = 140
    }
    
    // MARK: - Private Property
    private let lastAssetsResult = PHAsset.fetchAssets(with: nil)
    private var currentFetchResultChangeDetails: PHFetchResultChangeDetails<PHAsset>? = nil
}

extension PHFetchResultChangeDetailsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = dataList[section] as? [Any] else {
            return 0
        }
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHFetchResultChangeDetailsPropertyType else { return UITableViewCell () }
            
            var textString = ""
            switch type {
            case .fetchResultBeforeChanges:
                textString = fetchResultBeforeChanges()
            case .fetchResultAfterChanges:
                textString = fetchResultAfterChanges()
            case .hasIncrementalChanges:
                textString = hasIncrementalChanges()
            case .removedIndexes:
                textString = removedIndexes()
            case .removedObjects:
                textString = removedObjects()
            case .insertedIndexes:
                textString = insertedIndexes()
            case .insertedObjects:
                textString = insertedObjects()
            case .changedIndexes:
                textString = changedIndexes()
            case .changedObjects:
                textString = changedObjects()
            case .hasMoves:
                textString = hasMoes()
            }
            
            cell.textString = "\(type.rawValue): \(textString)"
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHFetchResultChangeDetailsMethodType else { return UITableViewCell () }
            cell.textString = "\(type.rawValue)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHFetchResultChangeDetailsMethodType else { return }
            switch type {
            case .enumerateMoves:
                enumerateMoves(type: type)
            }
        }
    }
}

// MARK: - PHPhotoLibraryChangeObserver
extension PHFetchResultChangeDetailsViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changeDetails = changeInstance.changeDetails(for: self.lastAssetsResult) else { return }
        self.currentFetchResultChangeDetails = changeDetails
        if self.currentFetchResultChangeDetails != nil {
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        } else {
             return
        }
        ATLog("照片库资源变化", funcName: "photoLibraryDidChange(_ changeInstance: PHChange)")
    }
}

// MARK: - Private Method
private extension PHFetchResultChangeDetailsViewController {
    // MARK: Property
    func fetchResultBeforeChanges() -> String {
        /*
         // 原始获取结果，最近没有更改
         @available(iOS 8, *)
         open var fetchResultBeforeChanges: PHFetchResult<ObjectType> { get }
         */
        return "\(self.currentFetchResultChangeDetails?.fetchResultBeforeChanges)"
    }
    
    func fetchResultAfterChanges() -> String {
        /*
         // 当前获取结果，包含最近的更改
         @available(iOS 8, *)
         open var fetchResultAfterChanges: PHFetchResult<ObjectType> { get }
         */
        return "\(self.currentFetchResultChangeDetails?.fetchResultAfterChanges)"
    }
    
    func hasIncrementalChanges() -> String {
        /*
         // 一个布尔值，指示是否可以增量描述对获取结果的更改
         // 如果该值为true，则使用insertedindex、removedIndexes和changedIndexes属性(或insertedObjects、removedObjects和changedObjects属性)来查找获取结果中添加、删除或更新了哪些对象。你也可以使用hasMoves属性和enumerateMoves(_:)方法来找出取回结果中哪些对象被重新安排了。这些属性对于更新集合视图或显示获取结果内容的类似界面非常有用。
         // 如果该值为false，则获取结果与原始状态差别太大，增量更改信息没有意义。使用fetchResultAfterChanges属性获取获取结果的当前成员。(如果显示获取结果的内容，请重新加载用户界面以匹配新的获取结果。)
         @available(iOS 8, *)
         open var hasIncrementalChanges: Bool { get }
         */
        return "\(currentFetchResultChangeDetails?.hasIncrementalChanges)"
    }
    
    func removedIndexes() -> String {
        /*
         // 已删除对象的索引
         // 对应与取回结果 befor状态，如果hasIncrementalChanges为false则返回nil
         @available(iOS 8, *)
         open var removedIndexes: IndexSet? { get }
         */
        return "\(currentFetchResultChangeDetails?.removedIndexes)"
    }
    
    func removedObjects() -> String {
        /*
         // 已删除的对象
         // 如果hasIncrementalChanges为false则返回nil
         @available(iOS 8, *)
         open var removedObjects: [ObjectType] { get }
         */
        return "\(currentFetchResultChangeDetails?.removedObjects)"
    }
    
    func insertedIndexes() -> String {
        /*
         // 插入对象的索引
         // 对于应用removedIndexes后的fetch结果的'before'状态，如果hasIncrementalChanges为false则返回nil
         @available(iOS 8, *)
         open var insertedIndexes: IndexSet? { get }
         */
        return "\(currentFetchResultChangeDetails?.insertedIndexes)"
    }
    
    func insertedObjects() -> String {
        /*
         // 插入的对象
         // 如果hasIncrementalChanges为false则返回nil
         @available(iOS 8, *)
         open var insertedObjects: [ObjectType] { get }
         */
        return "\(currentFetchResultChangeDetails?.insertedObjects)"
    }
    
    func changedIndexes() -> String {
        /*
         // 获取结果中内容或元数据已更新的对象的索引
         // 相对于获取结果的'after'状态, 如果hasIncrementalChanges为false则返回nil
         @available(iOS 8, *)
         open var changedIndexes: IndexSet? { get }
         */
        return "\(currentFetchResultChangeDetails?.changedIndexes)"
    }
    
    func changedObjects() -> String {
        /*
         // 获取结果中内容或元数据已更新的对象
         // 如果hasIncrementalChanges为false则返回nil
         @available(iOS 8, *)
         open var changedObjects: [ObjectType] { get }
         */
        return "\(currentFetchResultChangeDetails?.changedObjects)"
    }
    
    func hasMoes() -> String {
        /*
         // 一个布尔值，表示对象是否已在提取结果中重新排列。
         // 如果hasIncrementalChanges为false则返回nil
         // 如果该值为true，则使用enumerateMoves(_:)方法来找出哪些元素被移动了，以及它们的新索引是什么。
         @available(iOS 8, *)
         open var hasMoves: Bool { get }
         */
        return "\(currentFetchResultChangeDetails?.hasMoves)"
    }
    
    // MARK: Method
    func enumerateMoves(type: PHFetchResultChangeDetailsMethodType) {
        /*
         // 为每个对象在获取结果中从一个索引移动到另一个索引的情况运行指定的块
         // 在应用removedIndexes和insertedindex之后，相对于获取结果的'before'状态，枚举移动项的索引
         @available(iOS 8, *)
         open func enumerateMoves(_ handler: @escaping (Int, Int) -> Void)
         */
        guard let bool = currentFetchResultChangeDetails?.hasMoves else { return }
        if bool {
            self.currentFetchResultChangeDetails?.enumerateMoves({ beforIndex, afterIndex in
                ATLog("为每个对象在获取结果中从一个索引移动到另一个索引的情况运行指定的块 beforIndex = \(beforIndex) afterIndex = \(afterIndex)", funcName: type.rawValue)
            })
        }
    }
}

private enum PHFetchResultChangeDetailsPropertyType: String {
    case fetchResultBeforeChanges
    case fetchResultAfterChanges
    case hasIncrementalChanges
    case removedIndexes
    case removedObjects
    case insertedIndexes
    case insertedObjects
    case changedIndexes
    case changedObjects
    case hasMoves
}

private enum PHFetchResultChangeDetailsMethodType: String {
    case enumerateMoves = "enumerateMoves(_ handler: @escaping (Int, Int) -> Void)"
}
