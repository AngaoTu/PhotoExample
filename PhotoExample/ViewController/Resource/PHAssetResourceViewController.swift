//
//  PHAssetResourceViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/12/18.
//

import Foundation
import UIKit
import Photos

class PHAssetResourceViewController: BaseTableViewController {
    // MARK: - initialization
    init() {
//        guard let lastAsset = PHAsset.fetchAssets(with: nil).firstObject else { return }
        let lastAsset = PHAsset.fetchAssets(withLocalIdentifiers: ["B84E8479-475C-4727-A4A4-B77AA9980897/L0/001"], options: nil).firstObject
        
        // 一个PHAsset 对应多个 PHAssetResource
        self.currentAssetResource = PHAssetResource.assetResources(for: lastAsset!).first
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [[PHAssetResourcePropertyType.type, PHAssetResourcePropertyType.assetLocalIdentifier, PHAssetResourcePropertyType.uniformTypeIdentifier, PHAssetResourcePropertyType.originalFilename],[PHAssetResourceMethodType.assetResourcesForAsset, PHAssetResourceMethodType.assetResourcesForLivePhoto]]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHAssetResource模型"
    }
    
    // MARK: - Private Property
    private var currentAssetResource: PHAssetResource?
}

extension PHAssetResourceViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetResourcePropertyType else { return UITableViewCell () }
            var textString = ""
            switch type {
            case .type:
                textString = assetResourceType()
            case .assetLocalIdentifier:
                textString = assetLocalIdentifier()
            case .uniformTypeIdentifier:
                textString = uniformTypeIdentifier()
            case .originalFilename:
                textString = originalFilename()
            }
            cell.textString = "\(type): \n\(textString)"
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetResourceMethodType else { return UITableViewCell () }
            cell.textString = "\(type.rawValue)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetResourceMethodType else { return }
            switch type {
            case .assetResourcesForAsset:
                assetResourcesForAsset(type: type)
            case .assetResourcesForLivePhoto:
                assetResourcesForLivePhoto(type: type)
            }
        }
    }
}

// MARK: - Private Method
private extension PHAssetResourceViewController {
    // MARK: Property
    func assetResourceType() -> String {
        /*
         // 此assetResource与其拥有PHAsset的关系
         @available(iOS 9, *)
         open var type: PHAssetResourceType { get }
         
         @available(iOS 9, iOS 8, *)
         public enum PHAssetResourceType : Int {
             @available(iOS 8, *)
             case photo = 1 // 为其PHAsset提供原始照片数据

             @available(iOS 8, *)
             case video = 2 // 为其PHAsset提供原始视频数据

             @available(iOS 8, *)
             case audio = 3 // 为其PHAsset提供原始音频数据

             @available(iOS 8, *)
             case alternatePhoto = 4 // 提供不是其PHAsset主要形式的照片数据

             @available(iOS 8, *)
             case fullSizePhoto = 5 // 提供原始照片PHAsset的修改版本

             @available(iOS 8, *)
             case fullSizeVideo = 6 // 提供原始视频PHAsset的修改版本

             @available(iOS 8, *)
             case adjustmentData = 7 // 提供数据以用于重建对其PHAsset的最近编辑

             @available(iOS 8, *)
             case adjustmentBasePhoto = 8 // 提供其照片PHAsset的未更改版本，用于重建最近的编辑

             @available(iOS 9.1, *)
             case pairedVideo = 9 // 提供LivePhoto的原始视频数据组件

             @available(iOS 10, *)
             case fullSizePairedVideo = 10 // 提供LivePhoto照片资产的当前视频数据组件

             @available(iOS 10, *)
             case adjustmentBasePairedVideo = 11 // 提供其视频PHAsset的未更改版本

             @available(iOS 13, *)
             case adjustmentBaseVideo = 12 // 为LivePhoto提供未更改的视频数据版本，用于重建最近的编辑
         }
         */

        var textString = ""
        switch currentAssetResource!.type {
        case .photo:
            textString = "photo"
        case .video:
            textString = "video"
        case .audio:
            textString = "audio"
        case .alternatePhoto:
            textString = "alternatePhoto"
        case .fullSizePhoto:
            textString = "fullSizePhoto"
        case .fullSizeVideo:
            textString = "fullSizeVideo"
        case .adjustmentData:
            textString = "adjustmentData"
        case .adjustmentBasePhoto:
            textString = "adjustmentBasePhoto"
        case .pairedVideo:
            textString = "pairedVideo"
        case .fullSizePairedVideo:
            textString = "fullSizePairedVideo"
        case .adjustmentBasePairedVideo:
            textString = "adjustmentBasePairedVideo"
        case .adjustmentBaseVideo:
            textString = "adjustmentBaseVideo"
        @unknown default:
            textString = ""
        }
        return textString
    }
    
    func assetLocalIdentifier() -> String {
        /*
         // 此assetResource关联的PHAsset对应的唯一标识符(PHAsset.localIdentifier)
         @available(iOS 9, *)
         open var assetLocalIdentifier: String { get }
         */
        return "\(currentAssetResource?.assetLocalIdentifier)"
    }
    
    func uniformTypeIdentifier() -> String {
        /*
         // assetResource图片或视频数据的统一类型标识符
         // https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/understanding_utis/understand_utis_conc/understand_utis_conc.html#//apple_ref/doc/uid/TP40001319-CH202-SW1
         @available(iOS 9, *)
         open var uniformTypeIdentifier: String { get }
         */
        return "\(currentAssetResource?.uniformTypeIdentifier)"
    }
    
    func originalFilename() -> String {
        /*
         // assetResource在创建时倒入的原始名称
         @available(iOS 9, *)
         open var originalFilename: String { get }
         */
        return "\(currentAssetResource?.originalFilename)"
    }
    
    // MARK: Method
    func assetResourcesForAsset(type: PHAssetResourceMethodType) {
        /*
         // 返回与PHAsset关联的asset资源列表
         @available(iOS 9, *)
         open class func assetResources(for asset: PHAsset) -> [PHAssetResource]
         */
        
        let lastAsset = PHAsset.fetchAssets(withLocalIdentifiers: ["B84E8479-475C-4727-A4A4-B77AA9980897/L0/001"], options: nil).firstObject
        
        // 一个PHAsset 对应多个 PHAssetResource
        let resourceList = PHAssetResource.assetResources(for: lastAsset!)
        for item in resourceList {
            ATLog("assetResource = \(item)", funcName: type.rawValue)
        }
    }
    
    func assetResourcesForLivePhoto(type: PHAssetResourceMethodType) {
        /*
         TODO: PHLivePhoto
         // 返回与PHLivePhoto关联的livePhoto资源列表
         @available(iOS 9.1, *)
         open class func assetResources(for livePhoto: PHLivePhoto) -> [PHAssetResource]
         */
    }
}

private enum PHAssetResourcePropertyType: String {
    case type
    case assetLocalIdentifier
    case uniformTypeIdentifier
    case originalFilename
}

private enum PHAssetResourceMethodType: String {
    case assetResourcesForAsset = "assetResources(for asset: PHAsset) -> [PHAssetResource]"
    case assetResourcesForLivePhoto = "assetResources(for livePhoto: PHLivePhoto) -> [PHAssetResource]"
}
