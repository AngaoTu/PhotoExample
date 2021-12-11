//
//  PHCollectionListChangeRequstViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/12/11.
//

import Foundation
import UIKit

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
                break
            case .addChildCollections:
                break
            case .insertChildCollections:
                break
            case .removeChildCollections:
                break
            case .removeChildCollectionsAtIndex:
                break
            case .replaceChildCollections:
                break
            case .moveChildCollections:
                break
            }
        }
    }
}

// MARK: - Private Method
private extension PHCollectionListChangeRequestViewController {
    // MARK: Property
    func placeholderForCreatedCollectionList() {
        
    }
    
    func title() {
        /*
         // 集合列表名称
         @available(iOS 8, *)
         open var title: String
         */
        
    }
    
    // MARK: Method
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
