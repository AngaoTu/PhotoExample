//
//  PHAssetResourceRequestOptionsViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/12/18.
//

import Foundation
import UIKit
import Photos

class PHAssetResourceRequestOptionsViewController: BaseTableViewController {
    // MARK: - initialization
    init() {
        self.currentResouceRequestOptions = PHAssetResourceRequestOptions()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [PHAssetResourceRequestOptionsPropertyType.isNetworkAccessAllowed, PHAssetResourceRequestOptionsPropertyType.progressHandler]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHAssetResourceRequestOptions模型"
    }
    
    // MARK: - Private Property
    private let currentResouceRequestOptions: PHAssetResourceRequestOptions
}

extension PHAssetResourceRequestOptionsViewController {
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
        
        guard let type = dataList[indexPath.row] as? PHAssetResourceRequestOptionsPropertyType else { return UITableViewCell () }
        var textString = ""
        switch type {
        case .isNetworkAccessAllowed:
            textString = isNetworkAccessAllowed()
        case .progressHandler:
            textString = progressHandler()
        }
        cell.textString = "\(type): \n\(textString)"
        return cell
    }
}

// MARK: - Private Method
private extension PHAssetResourceRequestOptionsViewController {
    // MARK: Property
    func isNetworkAccessAllowed() -> String {
        /*
         // 指定照片是否可以从 iCloud 下载请求的资产资源数据
         @available(iOS 9, *)
         open var isNetworkAccessAllowed: Bool
         */
        return "\(currentResouceRequestOptions.isNetworkAccessAllowed)"
    }
    
    func progressHandler() -> String {
        /*
         //  // 从icloud下载图片时，会定期返回下载进度
         @available(iOS 9, *)
         open var progressHandler: PHAssetResourceProgressHandler?
         */
        return "\(currentResouceRequestOptions.progressHandler)"
    }
}

private enum PHAssetResourceRequestOptionsPropertyType: String {
    case isNetworkAccessAllowed
    case progressHandler
}
