//
//  AssetResourceViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/12/15.
//

import Foundation
import UIKit

class AssetResourceViewController: BaseTableViewController {
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [ResourceManagerType.PHAssetResource, ResourceManagerType.PHAssetResourceRequestOptions, ResourceManagerType.PHAssetResourceManager]
    }
    
    override func initView() {
        super.initView()
        self.title = "Asset资源管理"
    }
}

extension AssetResourceViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell,
              let type = dataList[indexPath.row] as? ResourceManagerType else {
            return UITableViewCell()
        }
        cell.textString = type.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = dataList[indexPath.row] as? ResourceManagerType else { return }
        switch type {
        case .PHAssetResource:
            let assetResourceViewController = PHAssetResourceViewController()
            self.navigationController?.pushViewController(assetResourceViewController, animated: true)
        case .PHAssetResourceRequestOptions:
            break
        case .PHAssetResourceManager:
            let assetResourceManagerViewController = PHAssetResourceManagerViewController()
            self.navigationController?.pushViewController(assetResourceManagerViewController, animated: true)
        }
    }
}

private enum ResourceManagerType: String {
    case PHAssetResource
    case PHAssetResourceRequestOptions
    case PHAssetResourceManager
}
