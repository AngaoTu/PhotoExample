//
//  PHImageRequestOptionsViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/8/31.
//

import Foundation
import UIKit

class PHImageRequestOptionsViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [PHImageRequestOptionsPropertyType.version, PHImageRequestOptionsPropertyType.deliveryMode, PHImageRequestOptionsPropertyType.resizeMode, PHImageRequestOptionsPropertyType.normalizedCropRect, PHImageRequestOptionsPropertyType.isNetworkAccessAllowed, PHImageRequestOptionsPropertyType.isSynchronous, PHImageRequestOptionsPropertyType.progressHandler]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHImageRequestOptions模型"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
    }
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
        break
        case .deliveryMode:
        break
        case .resizeMode:
        break
        case .normalizedCropRect:
        break
        case .isNetworkAccessAllowed:
            break
        case .isSynchronous:
            break
        case .progressHandler:
            break
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
        return ""
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
