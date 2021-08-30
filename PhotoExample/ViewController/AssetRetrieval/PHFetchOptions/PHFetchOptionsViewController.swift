//
//  PHFetchOptionsViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/8/25.
//

import UIKit
import Photos

class PHFetchOptionsViewController: BaseTableViewController {
    // MARK: - initialization
    init() {
        fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataList = [PHFetchOptionsPropertyType.predicate, PHFetchOptionsPropertyType.sortDescriptors, PHFetchOptionsPropertyType.includeHiddenAssets, PHFetchOptionsPropertyType.includeAllBurstAssets, PHFetchOptionsPropertyType.includeAssetSourceTypes, PHFetchOptionsPropertyType.fetchLimit, PHFetchOptionsPropertyType.wantsIncrementalChangeDetails]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHFetchOptions模型"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
        tableView.rowHeight = 60
    }
    
    // MARK: - 私有属性
    private let fetchOptions: PHFetchOptions
}

extension PHFetchOptionsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell,
              let type = dataList[indexPath.row] as? PHFetchOptionsPropertyType else {
            return UITableViewCell()
        }
        var textString = ""
        switch type {
        case .predicate:
            textString = predicate()
        case .sortDescriptors:
            textString = sortDescriptors()
        case .includeHiddenAssets:
            textString = includeHiddenAssets()
        case .includeAllBurstAssets:
            textString = includeAlBurstAssets()
        case .includeAssetSourceTypes:
            textString = includeAssetSourceTypes()
        case .fetchLimit:
            textString = fetchLimit()
        case .wantsIncrementalChangeDetails:
            textString = wantsIncrementalChangeDetails()
        }
        cell.textString = "\(type):\n\(textString)"
        return cell
    }
}

private extension PHFetchOptionsViewController {
    func predicate() -> String {
        /*
         // Some predicates / sorts may be suboptimal and we will log
         @available(iOS 8, *)
         open var predicate: NSPredicate?
         */
        return "\(String(describing: fetchOptions.predicate))"
    }
    
    func sortDescriptors() -> String {
        /*
         @available(iOS 8, *)
         open var sortDescriptors: [NSSortDescriptor]?  // 通过指定字段来进行排序
         */
        return "\(String(describing: fetchOptions.sortDescriptors))"
    }
    
    func includeHiddenAssets() -> String {
        /*
         @available(iOS 8, *)
         open var includeHiddenAssets: Bool // 是否包含隐藏图片，默认是不包含
         */
        return "\(fetchOptions.includeHiddenAssets)"
    }
    
    func includeAlBurstAssets() -> String {
        /*
         @available(iOS 8, *)
         open var includeAllBurstAssets: Bool // 是否包含连拍资源，默认是不包含
         */
        return "\(fetchOptions.includeAllBurstAssets)"
    }
    
    func includeAssetSourceTypes() -> String {
        /*
         @available(iOS 9, *)
         open var includeAssetSourceTypes: PHAssetSourceType // 获取的资源类型，默认是所有类型
         */
        return "\(fetchOptions.includeAssetSourceTypes)"
    }
    
    func fetchLimit() -> String {
        /*
         @available(iOS 9, *)
         open var fetchLimit: Int // 搜索结果数量限制，默认为0 没有限制
         */
        return "\(fetchOptions.fetchLimit)"
    }
    
    func wantsIncrementalChangeDetails() -> String {
        // TODO: 研究这个字端具体用法
        /*
         @available(iOS 8, *)
         open var wantsIncrementalChangeDetails: Bool // 用于确定app是否接收到了具体的改变信息，默认为true
         */
        return "\(fetchOptions.wantsIncrementalChangeDetails)"
    }
}

private enum PHFetchOptionsPropertyType: String {
    case predicate
    case sortDescriptors
    case includeHiddenAssets
    case includeAllBurstAssets
    case includeAssetSourceTypes
    case fetchLimit
    case wantsIncrementalChangeDetails
}
