//
//  PHLivePhotoViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/12/25.
//

import Foundation
import UIKit
import Photos

class PHLivePhotoViewController: BaseTableViewController {
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [[PHLivePhotoPropertyType.size], [PHLivePhotoMethodType.request, PHLivePhotoMethodType.cancelRequet]]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHLivePhoto模型"
    }
}

extension PHLivePhotoViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else {
            return 120
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
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHLivePhotoPropertyType else { return UITableViewCell () }
            var textString = ""
            switch type {
            case .size:
                textString = size()
            }
            cell.textString = "\(type): \(textString)"
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHLivePhotoMethodType else { return UITableViewCell () }
            cell.textString = "\(type.rawValue)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHLivePhotoMethodType else { return }
            switch type {
            case .request:
                request(type: type)
            case .cancelRequet:
                cancelRequest(type: type)
            }
        }
    }
}

// MARK: - Private Method
private extension PHLivePhotoViewController {
    // MARK: Property
    func size() -> String {
        /*
         // 图片大小
         @available(iOS 9.1, *)
         open var size: CGSize { get }
         */
        return ""
    }
    
    // MARK: Method
    func request(type: PHLivePhotoMethodType) {
        /*
         // 使用此方法可以用以前从Photos库导出的数据文件中加载Live Photo对象以显示
         // 如果需要数据文件LivePhoto导入photos库中，可以使用PHAssetCreationRequest
         @available(iOS 9.1, *)
         open class func request(withResourceFileURLs fileURLs: [URL], placeholderImage image: UIImage?, targetSize: CGSize, contentMode: PHImageContentMode, resultHandler: @escaping (PHLivePhoto?, [AnyHashable : Any]) -> Void) -> PHLivePhotoRequestID
         */
    }
    
    func cancelRequest(type: PHLivePhotoMethodType) {
        /*
         @available(iOS 9.1, *)
         open class func cancelRequest(withRequestID requestID: PHLivePhotoRequestID)
         */
    }
}

private enum PHLivePhotoPropertyType: String {
    case size
}

private enum PHLivePhotoMethodType: String {
    case request = "request(withResourceFileURLs fileURLs: [URL], placeholderImage image: UIImage?, targetSize: CGSize, contentMode: PHImageContentMode, resultHandler: @escaping (PHLivePhoto?, [AnyHashable : Any]) -> Void) -> PHLivePhotoRequestID"
    case cancelRequet = "cancelRequest(withRequestID requestID: PHLivePhotoRequestID)"
}
