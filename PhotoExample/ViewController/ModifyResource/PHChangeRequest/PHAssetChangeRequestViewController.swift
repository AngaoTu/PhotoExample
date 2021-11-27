//
//  PHAssetChangeRequestViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/11/27.
//

import UIKit
import Photos

class PHAssetChangeReuqestViewController: BaseTableViewController {
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [[PHAssetChangeRequestPropertyType.placeholderForCreatedAsset, PHAssetChangeRequestPropertyType.creationDate, PHAssetChangeRequestPropertyType.location, PHAssetChangeRequestPropertyType.isFavorite, PHAssetChangeRequestPropertyType.isHidden, PHAssetChangeRequestPropertyType.contentEditingOutput], [PHAssetChangeRequestMethodType.creationRequestForAsset, PHAssetChangeRequestMethodType.creationRequestForAssetFromImage, PHAssetChangeRequestMethodType.creationRequestForAssetFromVideo, PHAssetChangeRequestMethodType.deleteAssets, PHAssetChangeRequestMethodType.initForAsset, PHAssetChangeRequestMethodType.revertAssetContentToOriginal]]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHAssetChangeRequest模型"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
    }
}

extension PHAssetChangeReuqestViewController {
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
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetChangeRequestPropertyType else { return UITableViewCell () }
            var textString = ""
            switch type {
            case .placeholderForCreatedAsset:
                textString = placeholderForCreatedAsset()
            case .creationDate:
                textString = creationDate()
            case .location:
                textString = location()
            case .isFavorite:
                textString = isFavorite()
            case .isHidden:
                textString = isHidden()
            case .contentEditingOutput:
                textString = contentEditingOutput()
            }
            
            cell.textString = "\(type): \(textString)"
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetChangeRequestMethodType else { return UITableViewCell () }
            cell.textString = "\(type.rawValue)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetChangeRequestMethodType else { return }
            switch type {
            case .creationRequestForAsset:
                break
            case .creationRequestForAssetFromImage:
                break
            case .creationRequestForAssetFromVideo:
                break
            case .deleteAssets:
                break
            case .initForAsset:
                break
            case .revertAssetContentToOriginal:
                break
            }
        }
    }
}

// MARK: - Private Method
private extension PHAssetChangeReuqestViewController {
    // MARK: Property
    func placeholderForCreatedAsset() -> String {
        /*
         // 变更请求创建的资产的占位符对象
         @available(iOS 8, *)
         open var placeholderForCreatedAsset: PHObjectPlaceholder? { get }
         */
        var localId = ""
        PHPhotoLibrary.shared().performChanges {
            let asset = PHAsset.fetchAssets(with: nil).firstObject
            let request = PHAssetChangeRequest(for: asset!)
            localId = request.placeholderForCreatedAsset!.localIdentifier
        } completionHandler: { success, error in
            
        }

        return ""
    }
    
    func creationDate() -> String {
        return ""
    }
    
    func location() -> String {
        return ""
    }
    
    func isFavorite() -> String {
        return ""
    }
    
    func isHidden() -> String {
        return ""
    }
    
    func contentEditingOutput() -> String {
        return ""
    }
    
    // MARK: Method
    
}

private enum PHAssetChangeRequestPropertyType: String {
    // 添加资产
    case placeholderForCreatedAsset
    
    // 修改资产
    case creationDate
    case location
    case isFavorite
    case isHidden
    
    // 编辑资产内容
    case contentEditingOutput
}

private enum PHAssetChangeRequestMethodType: String {
    // 添加资产
    case creationRequestForAsset = "creationRequestForAsset(from image: UIImage) -> Self"
    case creationRequestForAssetFromImage = "creationRequestForAssetFromImage(atFileURL fileURL: URL) -> Self?"
    case creationRequestForAssetFromVideo = "creationRequestForAssetFromVideo(atFileURL fileURL: URL) -> Self?"
    
    // 删除资产
    case deleteAssets = "deleteAssets(_ assets: NSFastEnumeration)"
    
    // 修改资产
    case initForAsset = "init(for asset: PHAsset)"
    
    // 编辑资产内容
    case revertAssetContentToOriginal = "revertAssetContentToOriginal()"
}
