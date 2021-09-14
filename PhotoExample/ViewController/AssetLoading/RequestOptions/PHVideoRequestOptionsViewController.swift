//
//  PHVideoRequestOptions.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/9/13.
//

import Foundation
import UIKit
import Photos

class PHVideoRequestOptionsViewController: BaseTableViewController {
    // MARK: - initialization
    init() {
        self.videoRequestOptions = PHVideoRequestOptions()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [PHVideoRequestOptionsPropertyType.isNetworkAccessAllowed, PHVideoRequestOptionsPropertyType.version, PHVideoRequestOptionsPropertyType.deliveryMode, PHVideoRequestOptionsPropertyType.progressHandler]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHVedioRequestOptions模型"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
    }
    
    // MARK: - 私有属性
    private let videoRequestOptions: PHVideoRequestOptions
}

extension PHVideoRequestOptionsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell,
              let type = dataList[indexPath.row] as? PHVideoRequestOptionsPropertyType else {
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

private extension PHVideoRequestOptionsViewController {
    func isNetworkAccessAllowed() -> String {
        /*
         @available(iOS 8, *)
         open var isNetworkAccessAllowed: Bool
         */
        return "\(videoRequestOptions.isNetworkAccessAllowed)"
    }
    
    func version() -> String {
        /*
         @available(iOS 8, iOS 8, *)
         public enum PHVideoRequestOptionsVersion : Int {
             @available(iOS 8, *)
             case current = 0 // 当前版本，包括编辑内容

             @available(iOS 8, *)
             case original = 1 // 请求原版数据
         }
         
         @available(iOS 8, *)
         open var version: PHVideoRequestOptionsVersion
         */
        var text = ""
        switch videoRequestOptions.version {
        case .current:
            text = "current"
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
         public enum PHVideoRequestOptionsDeliveryMode : Int {

             @available(iOS 8, *)
             case automatic = 0 // only apply with PHVideoRequestOptionsVersionCurrent

             @available(iOS 8, *)
             case highQualityFormat = 1 // best quality

             @available(iOS 8, *)
             case mediumQualityFormat = 2 // medium quality (typ. 720p)

             @available(iOS 8, *)
             case fastFormat = 3 // fastest available (typ. 360p MP4)
         }
         
         @available(iOS 8, *)
         open var deliveryMode: PHVideoRequestOptionsDeliveryMode
         */
        var text = ""
        switch videoRequestOptions.deliveryMode {
        case .automatic:
            text = "automatic"
        case .highQualityFormat:
            text = "highQualityFormat"
        case .mediumQualityFormat:
            text = "mediumQualityFormat"
        case .fastFormat:
            text = "fastFormat"
        default:
            break
        }
        return text
    }
    
    func progressHandler() -> String {
        /*
         @available(iOS 8, *)
         open var progressHandler: PHAssetVideoProgressHandler?
         */
        return "\(String(describing: videoRequestOptions.progressHandler))"
    }
}

private enum PHVideoRequestOptionsPropertyType: String {
    case isNetworkAccessAllowed
    case version
    case deliveryMode
    case progressHandler
}
