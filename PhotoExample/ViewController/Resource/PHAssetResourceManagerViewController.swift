//
//  PHAssetResourceManagerViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/12/18.
//

import Foundation
import UIKit
import Photos

class PHAssetResourceManagerViewController: BaseTableViewController {
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [PHAssetResourceManagerMethodType.assetResourceDefault, PHAssetResourceManagerMethodType.requestData, PHAssetResourceManagerMethodType.writeDataWithCompletionhandler, PHAssetResourceManagerMethodType.writeDataWithAsync, PHAssetResourceManagerMethodType.cancelDataRequest]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHAssetResourceManager模型"
    }
}

extension PHAssetResourceManagerViewController {
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
        guard let type = dataList[indexPath.row] as? PHAssetResourceManagerMethodType else { return UITableViewCell () }
        cell.textString = "\(type.rawValue)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let type = dataList[indexPath.row] as? PHAssetResourceManagerMethodType else { return }
            switch type {
            case .assetResourceDefault:
                assetResourceDefault(type: type)
            case .requestData:
                requestData(type: type)
            case .writeDataWithCompletionhandler:
                writeDataWithCompletionhandler(type: type)
            case .writeDataWithAsync:
                writeDataWithAsync(type: type)
            case .cancelDataRequest:
                cancelDataRequest(type: type)
            }
        }
    }
}

// MARK: - Private Method
private extension PHAssetResourceManagerViewController {
    // MARK: Method
    func assetResourceDefault(type: PHAssetResourceManagerMethodType) {
        /*
         // 返回PHAssetResourceManager单例对象
         @available(iOS 9, *)
         open class func `default`() -> PHAssetResourceManager
         */
        ATLog("assetResourceManager = \(PHAssetResourceManager.default())", funcName: type.rawValue)
    }
    
    func requestData(type: PHAssetResourceManagerMethodType) {
        /*
         // 请求指定资产资源的底层数据，以异步交付
         // 处理程序是在任意串行队列上调用的。数据的生存期不能保证超过处理程序的生存期。
         
         // 当您调用此方法时，Photos将开始异步地读取资产资源的基础数据。根据您指定的选项和资产的当前状态，照片可以从网络下载资产数据。
         
         在读取(或下载)资产资源数据时，Photos至少调用一次处理程序块，逐步提供数据块。在读取所有数据之后，Photos调用completionHandler块来表示数据已经完成。(此时，资产的完整数据是所有调用到处理程序块的数据参数的连接。)如果照片不能完成读取或下载资产资源数据，它调用completionHandler块，并描述错误。如果用户取消下载，当数据完成时，照片也可以调用completionHandler块，并给出一个非nil错误。
         @available(iOS 9, *)
         open func requestData(for resource: PHAssetResource, options: PHAssetResourceRequestOptions?, dataReceivedHandler handler: @escaping (Data) -> Void, completionHandler: @escaping (Error?) -> Void) -> PHAssetResourceDataRequestID
         */
        
        guard let lastAsset = PHAsset.fetchAssets(with: nil).lastObject else { return }
        let assetResource = PHAssetResource.assetResources(for: lastAsset).first
        
        var imageData: Data = Data()
        PHAssetResourceManager.default().requestData(for: assetResource!, options: nil) { data in
            imageData.append(data)
        } completionHandler: { error in
            if (error == nil) {
                ATLog("get AssetResource success dataLength = \(imageData.count)", funcName: type.rawValue)
            }
        }
    }
    
    func writeDataWithCompletionhandler(type: PHAssetResourceManagerMethodType) {
        /*
         // 请求指定资产资源的底层数据，以异步写入本地文件
         @available(iOS 9, *)
         open func writeData(for resource: PHAssetResource, toFile fileURL: URL, options: PHAssetResourceRequestOptions?, completionHandler: @escaping (Error?) -> Void)
         */
        guard let lastAsset = PHAsset.fetchAssets(with: nil).lastObject else { return }
        let assetResource = PHAssetResource.assetResources(for: lastAsset).first
        
        let ursl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let doucumentUrl = ursl.first
        let resourceUrl = doucumentUrl?.appendingPathComponent(assetResource!.originalFilename, isDirectory: false)
        ATLog("resourceUrl = \(resourceUrl)")
        
        PHAssetResourceManager.default().writeData(for: assetResource!, toFile: resourceUrl!, options: nil) { error in
            if (error == nil) {
                ATLog("写入文件成功", funcName: type.rawValue)
            }
        }
    }
    
    func writeDataWithAsync(type: PHAssetResourceManagerMethodType) {
        /*
         // 请求指定资产资源的底层数据，以异步写入本地文件
         @available(iOS 9, *)
         open func writeData(for resource: PHAssetResource, toFile fileURL: URL, options: PHAssetResourceRequestOptions?) async throws
         */
    }
    
    func cancelDataRequest(type: PHAssetResourceManagerMethodType) {
        /*
         // 取消异步请求
         @available(iOS 9, *)
         open func cancelDataRequest(_ requestID: PHAssetResourceDataRequestID)
         */
    }
}

private enum PHAssetResourceManagerMethodType: String {
    case assetResourceDefault = "`default`() -> PHAssetResourceManager"
    case requestData = "requestData(for resource: PHAssetResource, options: PHAssetResourceRequestOptions?, dataReceivedHandler handler: @escaping (Data) -> Void, completionHandler: @escaping (Error?) -> Void) -> PHAssetResourceDataRequestID"
    case writeDataWithCompletionhandler = "writeData(for resource: PHAssetResource, toFile fileURL: URL, options: PHAssetResourceRequestOptions?, completionHandler: @escaping (Error?) -> Void)"
    case writeDataWithAsync = "writeData(for resource: PHAssetResource, toFile fileURL: URL, options: PHAssetResourceRequestOptions?) async throws"
    case cancelDataRequest = "cancelDataRequest(_ requestID: PHAssetResourceDataRequestID)"
}
