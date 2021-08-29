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
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataList = [PHFetchOptionsPropertyType.predicate, PHFetchOptionsPropertyType.sortDescriptors, PHFetchOptionsPropertyType.includeHiddenAssets, PHFetchOptionsPropertyType.includeAssetSourceTypes, PHFetchOptionsPropertyType.includeAssetSourceTypes, PHFetchOptionsPropertyType.fetchLimit, PHFetchOptionsPropertyType.wantsIncrementalChangeDetails]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHFetchOptions模型"
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
            break
        case .includeHiddenAssets:
            break
        case .includeAllBurstAssets:
            break
        case .includeAssetSourceTypes:
            break
        case .fetchLimit:
            break
        case .wantsIncrementalChangeDetails:
            break
        }
        cell.textString = "\(type): \(textString)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = dataList[indexPath.row] as? PHFetchOptionsPropertyType else {
            return
        }
        
        switch type {
        case .predicate:
            break
        case .sortDescriptors:
            break
        case .includeHiddenAssets:
            break
        case .includeAllBurstAssets:
            break
        case .includeAssetSourceTypes:
            break
        case .fetchLimit:
            break
        case .wantsIncrementalChangeDetails:
            break
        }
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
        return ""
    }
    
    func includeHiddenAssets() -> String {
        return ""
    }
    
    func includeAlBurstAssets() -> String {
        return ""
    }
    
    func includeAssetSourceTypes() -> String {
        return ""
    }
    
    func fetchLimit() -> String {
        return ""
    }
    
    func wantsIncrementalChangeDetails() -> String {
        return ""
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
