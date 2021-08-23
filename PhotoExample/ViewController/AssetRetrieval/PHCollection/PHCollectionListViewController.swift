//
//  PHCollectionListViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/8/12.
//

import UIKit
import Photos

class PHCollectionListViewController: BaseTableViewController {
    // MARK: - initialization
    init(collectionList: PHCollectionList) {
        self.currentCollectionList = collectionList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataList = [PHCollectionListPropertyType.collectionListType, PHCollectionListPropertyType.collectionListSubtype, PHCollectionListPropertyType.starDate, PHCollectionListPropertyType.endDate, PHCollectionListPropertyType.localizedLocationNames]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHAssetCollection模型"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
        tableView.backgroundColor = .white
    }
    
    // MARK: - Private Property
    private let currentCollectionList: PHCollectionList
}

extension PHCollectionListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell,
              let type = dataList[indexPath.row] as? PHCollectionListPropertyType else {
            return UITableViewCell()
        }
        var textString = ""
        switch type {
        case .collectionListType:
            textString = collectionListType()
        case .collectionListSubtype:
            textString = collectionListSubtype()
        case .starDate:
            textString = startDate()
        case .endDate:
            textString = endDate()
        case .localizedLocationNames:
            textString = localizedLocationNames()
        }
        cell.textString = "\(type): \(textString)"
        return cell
    }
}

private extension PHCollectionListViewController {
    func collectionListType() -> String {
        /*
         @available(iOS 8, *)
         open var collectionListType: PHCollectionListType { get }
         
         @available(iOS 8, iOS 8, *)
         public enum PHCollectionListType : Int {

             @available(iOS, introduced: 8, deprecated: 13, message: "Will be removed in a future release")
             case momentList = 1 // 包含了PHAssetCollectionTypeMoment类型的资源集合的列表

             @available(iOS 8, *)
             case folder = 2 // 包含了PHAssetCollectionTypeAlbum类型或PHAssetCollectionTypeSmartAlbum类型的资源集合的列表

             @available(iOS 8, *)
             case smartFolder = 3 // 同步到设备的智能文件夹的列表
         }
         */
        var typeString = ""
        switch currentCollectionList.collectionListType {
        case .momentList:
            typeString = "momentList"
        case .folder:
            typeString = "folder"
        case .smartFolder:
            typeString = "smartFolder"
        default:
            break
        }
        return typeString
    }
    
    func collectionListSubtype() -> String {
        /*
         @available(iOS 8, *)
         open var collectionListSubtype: PHCollectionListSubtype { get }
         
         @available(iOS 8, iOS 8, *)
         public enum PHCollectionListSubtype : Int {
             // PHCollectionListTypeMomentList subtypes
             @available(iOS, introduced: 8, deprecated: 13, message: "Will be removed in a future release")
             case momentListCluster = 1 // 时刻
             @available(iOS, introduced: 8, deprecated: 13, message: "Will be removed in a future release")
             case momentListYear = 2 // 年度

             // PHCollectionListTypeFolder subtypes
             @available(iOS 8, *)
             case regularFolder = 100 // 包含了其他文件夹或者相薄的文件夹
             
             // PHCollectionListTypeSmartFolder subtypes
             @available(iOS 8, *)
             case smartFolderEvents = 200 // 包含了一个或多个从iPhone同步的事件的智能文件夹

             @available(iOS 8, *)
             case smartFolderFaces = 201 // 包含了一个或多个从iPhone同步的面孔（人物）的智能文件夹

             // Used for fetching if you don't care about the exact subtype
             @available(iOS 8, *)
             case any = 9223372036854775807 // 如果你不关心子类型是什
         }
        */
        var typeString = ""
        switch currentCollectionList.collectionListSubtype {
        case .momentListCluster:
            typeString = "momentListCluster"
        case .momentListYear:
            typeString = "momentListYear"
        case .regularFolder:
            typeString = "regularFolder"
        case .smartFolderFaces:
            typeString = "smartFolderFaces"
        case .smartFolderEvents:
            typeString = "smartFolderEvents"
        default:
            break
        }
        
        return typeString
    }
    
    func startDate() -> String {
        guard let creationDate = currentCollectionList.startDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd号 HH:mm:ss"
        return formatter.string(from: creationDate)
    }
    
    func endDate() -> String {
        guard let creationDate = currentCollectionList.endDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd号 HH:mm:ss"
        return formatter.string(from: creationDate)
    }
    
    func localizedLocationNames() -> String {
        /*
         // 位置名称集合
         open var localizedLocationNames: [String] { get }
         */
        let array = currentCollectionList.localizedLocationNames
        var locations = ""
        for item in array {
            locations += "\(item),"
        }
        return locations
    }
}

private enum PHCollectionListPropertyType: String {
    case collectionListType
    case collectionListSubtype
    case starDate
    case endDate
    case localizedLocationNames
}
