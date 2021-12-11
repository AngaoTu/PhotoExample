//
//  PHAssetCollectionChangRequest.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/12/11.
//

import Foundation
import UIKit

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
                break
            case .deleteAssetCollections:
                break
            case .addAssets:
                break
            case .insertAssets:
                break
            case .removeAssets:
                break
            case .removeAssetsAtIndex:
                break
            case .replaceAssets:
                break
            case .moveAssets:
                break
            }
        }
    }
}

// MARK: - Private Method
extension PHAssetCollectionChangeRequestViewController {
    // MARK: Property
    func placeholderForCreatedAssetCollection() {
        
    }
    
    func title() {
        
    }
    
    // MARK: Method
}

private enum PHAssetCollectionChangeRequestPropertyType: String {
    case placeholderForCreatedAssetCollection
    case title
}

private enum PHAssetColletionChangeRequestMethodType: String {
    case creationRequestForAssetCollection = "creationRequestForAssetCollection(withTitle title: String) -> Self"
    case deleteAssetCollections = "deleteAssetCollections(_ assetCollections: NSFastEnumeration)"
    
    case addAssets = "addAssets(_ assets: NSFastEnumeration)"
    case insertAssets = "insertAssets(_ assets: NSFastEnumeration, at indexes: IndexSet)"
    case removeAssets = "removeAssets(_ assets: NSFastEnumeration)"
    case removeAssetsAtIndex = "removeAssets(at indexes: IndexSet)"
    case replaceAssets = "replaceAssets(at indexes: IndexSet, withAssets assets: NSFastEnumeration)"
    case moveAssets = "moveAssets(at fromIndexes: IndexSet, to toIndex: Int)"
}
