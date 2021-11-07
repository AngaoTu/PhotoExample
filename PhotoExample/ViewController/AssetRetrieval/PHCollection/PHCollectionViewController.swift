//
//  PHCollectionViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/11/7.
//

import Foundation
import UIKit
import Photos

class PHCollectionViewController: BaseTableViewController {
    // MARK: - initialization
    init(assetCollection: PHAssetCollection) {
        // 由于不能直接使用PHCollection，因此这里使用它的子类PHAssetCollection
        self.currentAssetCollection = assetCollection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.dataList = [[PHCollectionPropertyType.canContainAssets, PHCollectionPropertyType.canContainCollections, PHCollectionPropertyType.localizedTitle], [PHCollectionMethodType.canPerform, PHCollectionMethodType.fetchCollections, PHCollectionMethodType.fetchTopLevelUserCollections]]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHCollection模型"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
        tableView.rowHeight = 80
    }
    
    // MARK: - 私有属性
    private let currentAssetCollection: PHAssetCollection
}

extension PHCollectionViewController {
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
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHCollectionPropertyType else { return UITableViewCell () }
            var textString = ""
            switch type {
            case .canContainAssets:
                textString = canContainAssets()
            case .canContainCollections:
                textString = canContainCollection()
            case .localizedTitle:
                textString = localizedTitle()
            }
            
            cell.textString = "\(type.rawValue): \(textString)"
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHCollectionMethodType else { return UITableViewCell () }
            cell.textString = "\(type.rawValue)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHCollectionMethodType else { return }
            switch type {
            case .canPerform:
                canPerform(type: type)
            case .fetchCollections:
                fetchCollections(type: type)
            case .fetchTopLevelUserCollections:
                fetchTopLevelUserCollections(type: type)
            }
        }
    }
}

// MARK: - Private Method
private extension PHCollectionViewController {
    // MARK: Property
    func canContainAssets() -> String {
        /*
         // 能否包含Assets
         open var canContainAssets: Bool { get }
         */
        return currentAssetCollection.canContainAssets ? "ture" : "false"
    }
    
    func canContainCollection() -> String {
        /*
         // 能否包含集合
         open var canContainCollections: Bool { get }
         */
        return currentAssetCollection.canContainCollections ? "true" : "false"
    }
    
    func localizedTitle() -> String {
        /*
         // 标题
         open var localizedTitle: String? { get }
         */
        return currentAssetCollection.localizedTitle ?? ""
    }
    
    // MARK: Method
    func canPerform(type: PHCollectionMethodType) {
        /*
         // 返回集合是否支持指定的编辑操作
         @available(iOS 8, *)
         open func canPerform(_ anOperation: PHCollectionEditOperation) -> Bool
         */
    }
    
    func fetchCollections(type: PHCollectionMethodType) {
        /*
         // 从指定的集合列表中检索集合
         @available(iOS 8, *)
         open class func fetchCollections(in collectionList: PHCollectionList, options: PHFetchOptions?) -> PHFetchResult<PHCollection>
         */
        guard let collectionList = PHCollectionList.fetchCollectionLists(with: .folder, subtype: .any, options: nil).firstObject else {
            return
        }
        let collections = PHCollection.fetchCollections(in: collectionList, options: nil)
        collections.enumerateObjects { (collection, index, stop) in
            ATLog("从指定的集合列表中检索集合: \(collection)", funcName: type.rawValue)
        }
    }
    
    func fetchTopLevelUserCollections(type: PHCollectionMethodType) {
        /*
         // 获取用户创建的相册或文件夹
         @available(iOS 8, *)
         open class func fetchTopLevelUserCollections(with options: PHFetchOptions?) -> PHFetchResult<PHCollection>
         */
        let collections = PHCollection.fetchTopLevelUserCollections(with: nil)
        collections.enumerateObjects { (collection, index, stop) in
            ATLog("获取用户创建的相册或文件夹：\(collection)", funcName: type.rawValue)
        }
    }
}

private enum PHCollectionPropertyType: String {
    case canContainAssets
    case canContainCollections
    case localizedTitle
}

private enum PHCollectionMethodType: String {
    case canPerform = "canPerform(_ anOperation: PHCollectionEditOperation) -> Bool"
    case fetchCollections = "fetchCollections(in collectionList: PHCollectionList, options: PHFetchOptions?) -> PHFetchResult<PHCollection>"
    case fetchTopLevelUserCollections = "fetchTopLevelUserCollections(with options: PHFetchOptions?) -> PHFetchResult<PHCollection>"
}
