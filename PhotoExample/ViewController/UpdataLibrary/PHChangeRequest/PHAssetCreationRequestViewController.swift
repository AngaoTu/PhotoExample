//
//  PHAssetCreationRequestViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/12/19.
//

import Foundation
import UIKit
import Photos

class PHAssetCreationRequestViewController: BaseTableViewController {
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [PHAssetCreationRequestMethodType.forAsset, PHAssetCreationRequestMethodType.supportsAssetResourceTypes, PHAssetCreationRequestMethodType.addResourceWithData, PHAssetCreationRequestMethodType.addResourceWithFile]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHAssetCreationRequest模型"
    }
}

extension PHAssetCreationRequestViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        guard let type = dataList[indexPath.row] as? PHAssetCreationRequestMethodType else { return UITableViewCell () }
        cell.textString = "\(type.rawValue)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let type = dataList[indexPath.row] as? PHAssetCreationRequestMethodType else { return }
            switch type {
            case .forAsset:
                forAsset(type: type)
            case .supportsAssetResourceTypes:
                supportsAssetResourceTypes(type: type)
            case .addResourceWithData:
                addResourceWithData(type: type)
            case .addResourceWithFile:
                addResourceWithFile(type: type)
            }
        }
    }
}

// MARK: - Private Method
private extension PHAssetCreationRequestViewController {
    // MARK: Method
    func forAsset(type: PHAssetCreationRequestMethodType) {
        /*
         // 创建通过assetResource向照片库添加新资产的请求
         @available(iOS 9, *)
         open class func forAsset() -> Self
         */
        PHPhotoLibrary.shared().performChanges({
            ATLog("创建通过assetResource向照片库添加新资产的请求 = \(PHAssetCreationRequest.forAsset())",funcName: type.rawValue)
        }, completionHandler: nil)
    }
    
    func supportsAssetResourceTypes(type: PHAssetCreationRequestMethodType) {
        /*
         // 表示photos是否支持使用指定的资源类型组合创建asset
         // 当你请求从resourceData中创建一个PHAsset时，照片不会验证资源是否可以构建一个完整的PHAsset，直到完整的PHPhotoLibrary performChanges(_:completionHandler:)更改块执行。(如果一个资产不能从提供的资源构建，照片调用completionHandler你在该方法中提供的错误描述失败。)若要在执行资产创建请求之前执行预验证，请使用此方法验证您希望从中创建PHAsset的资源类型集是否正确。
         
         此方法只验证资产资源类型的集合是否有效(例如，确保您不会尝试在没有图像数据的情况下构造照片资产)，因此如果数据本身不完整或无效，资产创建请求仍然可能失败。然而，通过使用此方法调用，您可以在执行读取(并可能下载或传输)资产资源数据的昂贵操作之前避免某些类型的资产创建失败。
         @available(iOS 9, *)
         open class func supportsAssetResourceTypes(_ types: [NSNumber]) -> Bool
         */
        let isSupport = PHAssetCreationRequest.supportsAssetResourceTypes([NSNumber(value: PHAssetResourceType.photo.rawValue), NSNumber(value: PHAssetResourceType.fullSizePhoto.rawValue), NSNumber(value: PHAssetResourceType.alternatePhoto.rawValue)])
        ATLog("表示照片是否支持使用指定的资源类型组合创建asset isSupport = \(isSupport)", funcName: type.rawValue)
    }
    
    func addResourceWithData(type: PHAssetCreationRequestMethodType) {
        /*
         // 使用指定的数据向正在创建的PHAsset添加数据资源
         @available(iOS 9, *)
         open func addResource(with type: PHAssetResourceType, fileURL: URL, options: PHAssetResourceCreationOptions?)
         */
        let asset = PHAsset.fetchAssets(with: nil).firstObject
        
        PHImageManager.default().requestImageDataAndOrientation(for: asset!, options: nil) { data, _, _, _ in
            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: data!, options: nil)
            } completionHandler: { success, error in
                if success {
                    ATLog("使用指定的数据向正在创建的PHAsset添加数据资源", funcName: type.rawValue)
                }
            }
        }
    }
    
    func addResourceWithFile(type: PHAssetCreationRequestMethodType) {
        /*
         // 使用位于指定URL的文件将数据资源添加到正在创建的PHAsset
         @available(iOS 9, *)
         open func addResource(with type: PHAssetResourceType, data: Data, options: PHAssetResourceCreationOptions?)
         */
    }
}

private enum PHAssetCreationRequestMethodType: String {
    case forAsset = "forAsset() -> Self"
    case supportsAssetResourceTypes = "supportsAssetResourceTypes(_ types: [NSNumber]) -> Bool"
    case addResourceWithData = "addResource(with type: PHAssetResourceType, fileURL: URL, options: PHAssetResourceCreationOptions?)"
    case addResourceWithFile = "addResource(with type: PHAssetResourceType, data: Data, options: PHAssetResourceCreationOptions?)"
}
