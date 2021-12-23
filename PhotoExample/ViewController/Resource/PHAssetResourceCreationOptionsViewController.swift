//
//  PHAssetResourceCreationOptionsViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/12/19.
//

import Foundation
import UIKit
import Photos

class PHAssetResourceCreationOptionsViewController: BaseTableViewController {
    // MARK: - initialization
    init() {
        self.currentResourceCreationOptions = PHAssetResourceCreationOptions()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [PHAssetResourceCreationOptionsPropertyType.originalFilename, PHAssetResourceCreationOptionsPropertyType.uniformTypeIdentifier, PHAssetResourceCreationOptionsPropertyType.shouldMoveFile]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHAssetResourceCreationOptions模型"
    }
    
    // MARK: - Private Property
    private let currentResourceCreationOptions: PHAssetResourceCreationOptions?
}

extension PHAssetResourceCreationOptionsViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        
        guard let type = dataList[indexPath.row] as? PHAssetResourceCreationOptionsPropertyType else { return UITableViewCell () }
        var textString = ""
        switch type {
        case .originalFilename:
            textString = originalFilename(type: type)
        case .uniformTypeIdentifier:
            textString = uniformTypeIdentifier(type: type)
        case .shouldMoveFile:
            textString = shouldMoveFile(type: type)
        }
        cell.textString = "\(type): \n\(textString)"
        return cell
    }
}

// MARK: - Private Method
private extension PHAssetResourceCreationOptionsViewController {
    // MARK: Property
    func originalFilename(type: PHAssetResourceCreationOptionsPropertyType) -> String {
        /*
         // 正在创建的资产资源的文件名
         // 如果你没有为这个属性指定一个值，并且使用addResource(使用:fileURL:options:)方法来创建一个资源，Photos会从该方法的fileURL参数中推断文件名。否则，照片会自动生成一个文件名。
         // 即使您使用addResource(使用:data:options:)方法从数据而不是从文件创建资源。在创建资产之后，这个信息在相应的PHAssetResource对象的originalFilename属性中可用
         @available(iOS 9, *)
         open var originalFilename: String?
         */
        return "\(currentResourceCreationOptions?.originalFilename)"
    }
    
    func uniformTypeIdentifier(type: PHAssetResourceCreationOptionsPropertyType) -> String {
        /*
         // 资源的统一类型标识符
         // 如果您没有为这个属性指定一个值，当您将资源添加到创建请求时，Photos会从您指定的PHAssetResourceType值推断出数据类型。

         @available(iOS 9, *)
         open var uniformTypeIdentifier: String?
         */
        return "\(currentResourceCreationOptions?.uniformTypeIdentifier)"
    }
    
    func shouldMoveFile(type: PHAssetResourceCreationOptionsPropertyType) -> String {
        /*
         // 用于确定在创建assetResource时 Photos 是移动还是复制文件
         // 此属性仅适用于使用addResource(使用:fileURL:options:)方法创建资产资源时。如果该值为true, Photos将指定的文件移动到Photos库中以创建资产资源，在成功创建资产后删除原始文件。当使用此选项时，Photos不会对资源数据进行中间拷贝，因此不需要额外的存储空间。如果该值为false(默认值)，Photos将原始文件的内容复制到Photos库中。
         @available(iOS 9, *)
         open var shouldMoveFile: Bool
         */

        let asset = PHAsset.fetchAssets(with: nil).firstObject
        let creationOptions = PHAssetResourceCreationOptions()
        
        PHImageManager.default().requestImageDataAndOrientation(for: asset!, options: nil) { data, _, _, _ in
            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                
                
                creationOptions.shouldMoveFile = true
                // 对addResource(with type: PHAssetResourceType, fileURL: URL, options: PHAssetResourceCreationOptions?)不起作用
                creationRequest.addResource(with: .photo, data: data!, options: creationOptions)
            } completionHandler: { success, error in
                if success {
                    ATLog("使用指定的数据向正在创建的PHAsset添加数据资源", funcName: type.rawValue)
                }
            }
        }
        return "\(creationOptions.shouldMoveFile)"
    }
}

private enum PHAssetResourceCreationOptionsPropertyType: String {
    case originalFilename
    case uniformTypeIdentifier
    case shouldMoveFile
}
