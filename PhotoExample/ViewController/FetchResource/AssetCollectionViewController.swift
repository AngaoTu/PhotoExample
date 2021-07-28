//
//  AssetCollectionViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/28.
//

import UIKit
import Photos

class AssetCollectionViewController: UIViewController {
    // MARK: - initialization
    init(assetCollection: PHAssetCollection) {
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
    }
    
    // MARK: - 私有属性
    private lazy var tableView: UITableView = {
        let temp = UITableView()
        temp.delegate = self
        temp.dataSource = self
        temp.rowHeight = 88
        temp.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
        return temp
    }()
    
    private let dataList: [PHAssetCollectionPropertyType] = [.canContainAssets, .canContainCollection, .localizedTitle, .assetCollectionType, .assetCollectionSubtype, .estimatedAssetCount, .startDate, .endDate, .approximatedLocation, .localizedLocationNames]
    
    private let currentAssetCollection: PHAssetCollection
}

extension AssetCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        var textString = ""
        switch dataList[indexPath.row] {
        case .canContainAssets:
            textString = canContainAssets()
        case .canContainCollection:
            textString = canCpntainCollection()
        case .localizedTitle:
            textString = localizedTitle()
        case .assetCollectionType:
            break
        case .assetCollectionSubtype:
            break
        case .estimatedAssetCount:
            break
        case .startDate:
            break
        case .endDate:
            break
        case .approximatedLocation:
            break
        case .localizedLocationNames:
            break
        default:
            break
        }
        cell.textString = "\(dataList[indexPath.row].rawValue): \(textString)"
        return cell
    }
}

private extension AssetCollectionViewController {
    func initView() {
        view.backgroundColor = .white
        self.title = "获取资源"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func canContainAssets() -> String {
        /*
         // 能否包含Assets
         open var canContainAssets: Bool { get }
         */
        return currentAssetCollection.canContainAssets ? "ture" : "false"
    }
    
    func canCpntainCollection() -> String {
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
    
    func assetCollectionType() -> String {
        /*
         // 集合类型
         open var assetCollectionType: PHAssetCollectionType { get }
         
         public enum PHAssetCollectionType : Int {
             @available(iOS 8, *)
             case album = 1

             @available(iOS 8, *)
             case smartAlbum = 2
             
             @available(iOS, introduced: 8, deprecated: 13, message: "Will be removed in a future release")
             case moment = 3
         }
         */
        
        
        return ""
    }
}

private enum PHAssetCollectionPropertyType: String {
    // 继承于PHCollection属性
    case canContainAssets
    case canContainCollection
    case localizedTitle
    // PHAssetCollection属性
    case assetCollectionType
    case assetCollectionSubtype
    case estimatedAssetCount
    case startDate
    case endDate
    case approximatedLocation
    case localizedLocationNames
}


