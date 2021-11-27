//
//  PHAssetChangeRequestViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/11/27.
//

import UIKit
import Photos

class PHAssetChangeRequestViewController: BaseTableViewController {
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

extension PHAssetChangeRequestViewController {
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
            cell.textString = "\(type)"
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetChangeRequestMethodType else { return UITableViewCell () }
            cell.textString = "\(type.rawValue)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetChangeRequestPropertyType else { return }
            switch type {
            case .placeholderForCreatedAsset:
                placeholderForCreatedAsset()
            case .creationDate:
                creationDate()
            case .location:
                location()
            case .isFavorite:
                isFavorite()
            case .isHidden:
                isHidden()
            case .contentEditingOutput:
                break
            }
        } else if indexPath.section == 1 {
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
private extension PHAssetChangeRequestViewController {
    // MARK: Property
    func placeholderForCreatedAsset() {
        /*
         // 变更请求创建的资产的占位符对象
         1. 可以使用-localIdentifier在变更块完成后获取新创建的资产
         2. 它也可以直接添加到当前更改块中的集合中
         @available(iOS 8, *)
         open var placeholderForCreatedAsset: PHObjectPlaceholder? { get }
         */
        let image = UIImage(named: "Dustbin_down")
        var localId = ""
        PHPhotoLibrary.shared().performChanges {
            // 1. 可以使用-localIdentifier在变更块完成后获取新创建的资产
            let request = PHAssetChangeRequest.creationRequestForAsset(from: image!)
            localId = request.placeholderForCreatedAsset!.localIdentifier
            
            // 2. 它也可以直接添加到当前更改块中的集合中
            /*
             PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
             PHObjectPlaceholder *assetPlaceholder = createAssetRequest.placeholderForCreatedAsset;
             PHAssetCollectionChangeRequest *albumChangeRequest =
                 [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
             [albumChangeRequest addAssets:@[ assetPlaceholder ]];
             */
        } completionHandler: { success, error in
            if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [localId], options: nil).firstObject {
                ATLog("获取成功 asset = \(asset)")
            } else {
                ATLog("获取失败")
            }
        }
    }
    
    func creationDate() {
        /*
         // 创建时间
         @available(iOS 8, *)
         open var creationDate: Date?
         */
        
        let asset = PHAsset.fetchAssets(with: nil).lastObject
        let localId = asset!.localIdentifier
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetChangeRequest(for: asset!)
            request.creationDate = Date()
        } completionHandler: { success, error in
            if success {
                let currentAsset = PHAsset.fetchAssets(withLocalIdentifiers: [localId], options: nil).firstObject
                ATLog("修改后createDate = \(currentAsset?.creationDate)")
            }
        }
    }
    
    func location() {
        /*
         // 地点
         @available(iOS 8, *)
         open var location: CLLocation?
         */
        let asset = PHAsset.fetchAssets(with: nil).lastObject
        let localId = asset!.localIdentifier
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetChangeRequest(for: asset!)
            request.location = CLLocation(latitude: 39.916527, longitude: 116.397128)
        } completionHandler: { success, error in
            if success {
                let currentAsset = PHAsset.fetchAssets(withLocalIdentifiers: [localId], options: nil).firstObject
                ATLog("修改后createDate = \(currentAsset?.location)")
            }
        }
    }
    
    func isFavorite() {
        /*
         // 是否喜欢
         @available(iOS 8, *)
         open var isFavorite: Bool
         */
        let asset = PHAsset.fetchAssets(with: nil).lastObject
        let localId = asset!.localIdentifier
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetChangeRequest(for: asset!)
            request.isFavorite = !asset!.isFavorite
        } completionHandler: { success, error in
            if success {
                let currentAsset = PHAsset.fetchAssets(withLocalIdentifiers: [localId], options: nil).firstObject
                ATLog("修改后createDate = \(currentAsset?.isFavorite)")
            }
        }
    }
    
    func isHidden() {
        /*
         // 是否隐藏
         @available(iOS 8, *)
         open var isHidden: Bool
         */
        let asset = PHAsset.fetchAssets(with: nil).lastObject
        let localId = asset!.localIdentifier
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetChangeRequest(for: asset!)
            request.isHidden = !asset!.isHidden
        } completionHandler: { success, error in
            if success {
                let currentAsset = PHAsset.fetchAssets(withLocalIdentifiers: [localId], options: nil).firstObject
                ATLog("修改后createDate = \(currentAsset?.isHidden)")
            }
        }
    }
    
    func contentEditingOutput() {
        // TODO: 编辑操作
    }
    
    // MARK: Method
    func creationRequestForAsset() {
        /*
         // 通过UIImage创建新Asset
         @available(iOS 8, *)
         open class func creationRequestForAsset(from image: UIImage) -> Self
         */
    }
    
    func creationRequestForAssetFromImage() {
        /*
         // 通过照片file创建新Asset
         @available(iOS 8, *)
         open class func creationRequestForAssetFromImage(atFileURL fileURL: URL) -> Self?
         */
    }
    
    func creationRequestForAssetFromVideo() {
        /*
         // 通过视频file创建新Asset
         @available(iOS 8, *)
         open class func creationRequestForAssetFromVideo(atFileURL fileURL: URL) -> Self?
         */
    }
    
    func deleteAssets() {
        /*
         // 删除Assets
         @available(iOS 8, *)
         open class func deleteAssets(_ assets: NSFastEnumeration)
         */
    }
    
    func initForAsset() {
        /*
         // 通过Asset初始化一个PHAssetChangeRequest
         @available(iOS 8, *)
         public convenience init(for asset: PHAsset)
         */
    }
    
    func revertAssetContentToOriginal() {
        /*
         TODO: PHAssetResourceManager
         // 请求恢复对资产内容所做的任何编辑
         @available(iOS 8, *)
         open func revertAssetContentToOriginal()
         */
    }
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
