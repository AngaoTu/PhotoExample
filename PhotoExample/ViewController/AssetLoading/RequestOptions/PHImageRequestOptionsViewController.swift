//
//  PHImageRequestOptionsViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/8/31.
//

import Foundation
import UIKit
import Photos

class PHImageRequestOptionsViewController: BaseTableViewController {
    // MARK: - initalization
    init() {
        self.imageRequestOptions = PHImageRequestOptions()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [PHImageRequestOptionsPropertyType.version, PHImageRequestOptionsPropertyType.deliveryMode, PHImageRequestOptionsPropertyType.resizeMode, PHImageRequestOptionsPropertyType.normalizedCropRect, PHImageRequestOptionsPropertyType.isNetworkAccessAllowed, PHImageRequestOptionsPropertyType.isSynchronous, PHImageRequestOptionsPropertyType.progressHandler]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHImageRequestOptions模型"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
    }
    
    // MARK: - 私有属性
    private let imageRequestOptions: PHImageRequestOptions
}

extension PHImageRequestOptionsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell,
              let type = dataList[indexPath.row] as? PHImageRequestOptionsPropertyType else {
            return UITableViewCell()
        }
        var textString = ""
        switch type {
        case .version:
            textString = version()
        case .deliveryMode:
            textString = deliveryMode()
        case .resizeMode:
            textString = resizeMode()
        case .normalizedCropRect:
            textString = normalizedCropRect()
        case .isNetworkAccessAllowed:
            textString = isNetworkAccessAllowed()
        case .isSynchronous:
            textString = isSynchronous()
        case .progressHandler:
            textString = progressHandler()
        }
        cell.textString = "\(type):\n\(textString)"
        return cell
    }
}

private extension PHImageRequestOptionsViewController {
    func version() -> String {
        // TODO: unadjusted和original的区别
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
         */
        var text = ""
        switch imageRequestOptions.version {
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
        switch imageRequestOptions.deliveryMode {
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
    
    func resizeMode() -> String {
        /*
         @available(iOS 8, iOS 8, *)
         public enum PHImageRequestOptionsResizeMode : Int {

             @available(iOS 8, *)
             case none = 0 // 不做任何调整
         
             @available(iOS 8, *)
             case fast = 1 // 最快速的调整图像，有可能比给定大小略大

             @available(iOS 8, *)
             case exact = 2 // 与给定大小一致，如果使用normalizedCropRect属性，则必须指定为该模式。
         }
         
         @available(iOS 8, *)
         open var resizeMode: PHImageRequestOptionsResizeMode // 请求图像的大小，默认为fast
         */
        var text = ""
        switch imageRequestOptions.resizeMode {
        case .none:
            text = "none"
        case .fast:
            text = "fast"
        case .exact:
            text = "exact"
        default:
            break
        }
        return text
    }
    
    func normalizedCropRect() -> String {
        /*
         @available(iOS 8, *)
         open var normalizedCropRect: CGRect // 是否对原图进行裁剪
         // 如果你指定了裁剪的矩形，那么你必须对resizeMode属性设置为.exact
         */
        return "\(imageRequestOptions.normalizedCropRect)"
    }
    
    func isNetworkAccessAllowed() -> String {
        /*
         @available(iOS 8, *)
         open var isNetworkAccessAllowed: Bool // 是否可以从iCloud中下载图片，默认为false
         */
        return "\(imageRequestOptions.isNetworkAccessAllowed)"
    }
    
    func isSynchronous() -> String {
        /*
         @available(iOS 8, *)
         open var isSynchronous: Bool // 是否同步请求照片，默认是NO
         */
        return "\(imageRequestOptions.isSynchronous)"
    }
    
    func progressHandler() -> String {
        /*
         @available(iOS 8, *)
         open var progressHandler: PHAssetImageProgressHandler? // 从icloud下载图片是，会定期返回下载进度
         */
        return "\(String(describing: imageRequestOptions.progressHandler))"
    }
}

private enum PHImageRequestOptionsPropertyType: String {
    case version
    case deliveryMode
    case resizeMode
    case normalizedCropRect
    case isNetworkAccessAllowed
    case isSynchronous
    case progressHandler
}
