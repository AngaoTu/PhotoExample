//
//  PHLivePhotoRequestOptionsViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/9/1.
//

import Foundation
import UIKit
import Photos

class PHLivePhotoRequestOptionsViewController: BaseTableViewController {
    // MARK: - initalization
    init() {
        self.livePhotoRequestOptions = PHLivePhotoRequestOptions()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [PHLivePhotoRequestOptionsPropertyType.version, PHLivePhotoRequestOptionsPropertyType.deliveryMode, PHLivePhotoRequestOptionsPropertyType.isNetworkAccessAllowed, PHLivePhotoRequestOptionsPropertyType.progressHandler]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHLivePhotoRequestOptions模型"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
    }
    
    // MARK: - 私有属性
    private let livePhotoRequestOptions: PHLivePhotoRequestOptions
}

extension PHLivePhotoRequestOptionsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell,
              let type = dataList[indexPath.row] as? PHLivePhotoRequestOptionsPropertyType else {
            return UITableViewCell()
        }
        var textString = ""
        switch type {
        case .version:
            textString = version()
        case .deliveryMode:
            textString = deliveryMode()
        case .isNetworkAccessAllowed:
            textString = isNetworkAccessAllowed()
        case .progressHandler:
            textString = progressHandler()
        }
        cell.textString = "\(type):\n\(textString)"
        return cell
    }
}

private extension PHLivePhotoRequestOptionsViewController {
    func version() -> String {
        /*
         @available(iOS 8, iOS 8, *)
         public enum PHImageRequestOptionsVersion : Int {

             @available(iOS 8, *)
             case current = 0 // 请求图像资产的最新版本（包括所有编辑的版本）

             @available(iOS 8, *)
             case unadjusted = 1 // 原版，没有任何调整编辑

             @available(iOS 8, *)
             case original = 2 // 请求图像资产的原始、最高保真度版本。
         }
         
         @available(iOS 8, *)
         open var version: PHImageRequestOptionsVersion // 图片版本
         // 这里和PHImageRequestOptions采用相同的枚举
         */
        var text = ""
        switch livePhotoRequestOptions.version {
        case .current:
            text = "current"
        case .unadjusted:
            text = "unadjusted"
        case .original:
            text = "original"
        default:
            break
        }
        return text
    }
    
    func deliveryMode() -> String {
        /*
         @available(iOS 8, iOS 8, *)
         public enum PHImageRequestOptionsDeliveryMode : Int {

             
             @available(iOS 8, *)
             case opportunistic = 0 // 平衡图像质量和响应速度，可能会返回一个或者多个结果

             @available(iOS 8, *)
             case highQualityFormat = 1 // 只会返回最高质量图像

             @available(iOS 8, *)
             case fastFormat = 2 // 最快速度得到一个图像结果，可能会牺牲图像质量
         }
         
         @available(iOS 8, *)
         open var deliveryMode: PHImageRequestOptionsDeliveryMode // 图片交付模式，默认是opportunistic
         */
        var text = ""
        switch livePhotoRequestOptions.deliveryMode {
        case .opportunistic:
            text = "opportunistic"
        case .highQualityFormat:
            text = "highQualityFormat"
        case .fastFormat:
            text = "fastFormat"
        default:
            break
        }
        return text
    }
    
    func isNetworkAccessAllowed() -> String {
        /*
         @available(iOS 8, *)
         open var isNetworkAccessAllowed: Bool // 是否可以从iCloud中下载图片，默认为false
         */
        return "\(livePhotoRequestOptions.isNetworkAccessAllowed)"
    }
    
    func progressHandler() -> String {
        /*
         @available(iOS 8, *)
         open var progressHandler: PHAssetImageProgressHandler? // 从icloud下载图片是，会定期返回下载进度
         */
        return "\(String(describing: livePhotoRequestOptions.progressHandler))"
    }
}

private enum PHLivePhotoRequestOptionsPropertyType: String {
    case version
    case deliveryMode
    case isNetworkAccessAllowed
    case progressHandler
}
