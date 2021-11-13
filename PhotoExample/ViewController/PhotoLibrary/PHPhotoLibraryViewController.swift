//
//  PHPhotoLibrayViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/11/13.
//

import Foundation
import UIKit
import Photos

class PHPhotoLibraryViewController: BaseTableViewController {
    // MARK: - initialization
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [[PHPhotoLibrayPropertyType.unavailabilityReason], [PHPhotoLibrayMethodType.authorizationStatus, PHPhotoLibrayMethodType.requestAuthorization, PHPhotoLibrayMethodType.performChanges, PHPhotoLibrayMethodType.performChangesAndWait, PHPhotoLibrayMethodType.registerChangeObserver, PHPhotoLibrayMethodType.unregisterChangeObserver, PHPhotoLibrayMethodType.registerAvailabilityObserver, PHPhotoLibrayMethodType.unregisterAvailabilityObserver]]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHPhotoLibray"
        tableView.rowHeight = 60
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
    }
}

extension PHPhotoLibraryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = dataList[section] as? [Any] else {
            return 0
        }
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.section == 0 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHPhotoLibrayPropertyType else { return UITableViewCell () }
            
            var textString = ""
            switch type {
            case .unavailabilityReason:
                textString = unavailabilityReason()
            }
            cell.textString = "\(type): \(textString)"
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHPhotoLibrayMethodType else { return UITableViewCell () }
            cell.textString = "\(type.rawValue)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHPhotoLibrayMethodType else { return }
            switch type {
            case .authorizationStatus:
                authorizationStatus(type: type)
            case .requestAuthorization:
                requestAuthorization(type: type)
            case .performChanges:
                performChanges(type: type)
            case .performChangesAndWait:
                performChangesAndWait(type: type)
            case .registerChangeObserver:
                registerChangeObserver(type: type)
            case .unregisterChangeObserver:
                unregisterChangeObserver(type: type)
            case .registerAvailabilityObserver:
                registerAvailabilityObserver(type: type)
            case .unregisterAvailabilityObserver:
                unregisterAvailabilityObserver(type: type)
            }
        }
    }
}

// MARK: - Private Method
private extension PHPhotoLibraryViewController {
    // MARK: Property
    func unavailabilityReason() -> String {
        /*
         // 照片库不可用原因
         // 仅在照片库不可用时，才包含有效错误
         @available(iOS 13, *)
         open var unavailabilityReason: Error? { get }
         */
        return "\(String(describing: PHPhotoLibrary.shared().unavailabilityReason))"
    }
    
    // MARK: Method
    func authorizationStatus(type: PHPhotoLibrayMethodType) {
        /*
         // 返回应用对指定访问级别的用户照片库的访问权限
         @available(iOS 14, *)
         open class func authorizationStatus(for accessLevel: PHAccessLevel) -> PHAuthorizationStatus
         
         @available(iOS 8, iOS 8, *)
         public enum PHAuthorizationStatus : Int {

             
             @available(iOS 8, *)
             case notDetermined = 0 // 用户尚未设置应用的授权状态。
         
             @available(iOS 8, *)
             case restricted = 1 // 此应用程序未被授权访问照片数据。

             @available(iOS 8, *)
             case denied = 2 // 用户明确拒绝此应用程序访问照片数据。

             @available(iOS 8, *)
             case authorized = 3 // 用户已授权此应用程序访问照片数据。

             @available(iOS 14, *)
             case limited = 4 // 用户授权此应用访问有限的照片库。
            // User has authorized this application for limited photo library access. Add PHPhotoLibraryPreventAutomaticLimitedAccessAlert = YES to the application's Info.plist to prevent the automatic alert to update the users limited library selection. Use -[PHPhotoLibrary(PhotosUISupport) presentLimitedLibraryPickerFromViewController:] from PhotosUI/PHPhotoLibrary+PhotosUISupport.h to manually present the limited library picker.
         }
         */
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        var statusString = ""
        switch status {
        case .notDetermined:
            statusString = "notDetermined"
        case .restricted:
            statusString = "restricted"
        case .denied:
            statusString = "denied"
        case .authorized:
            statusString = "authorized"
        case .limited:
            statusString = "limited"
        @unknown default:
            statusString = ""
        }
        
        ATLog("返回应用对指定访问级别的用户照片库的访问权限 status = \(statusString)", funcName: type.rawValue)
    }
    
    func requestAuthorization(type: PHPhotoLibrayMethodType) {
        /*
         // 提示用户授予应用访问照片库的权限。
         @available(iOS 14, *)
         open class func requestAuthorization(for accessLevel: PHAccessLevel, handler: @escaping (PHAuthorizationStatus) -> Void)
         */
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { authorizationStatus in
            var statusString = ""
            switch authorizationStatus {
            case .notDetermined:
                statusString = "notDetermined"
            case .restricted:
                statusString = "restricted"
            case .denied:
                statusString = "denied"
            case .authorized:
                statusString = "authorized"
            case .limited:
                statusString = "limited"
            @unknown default:
                statusString = ""
            }
            ATLog("提示用户授予应用访问照片库的权限: staus = \(statusString)", funcName: type.rawValue)
        }
    }
    
    func performChanges(type: PHPhotoLibrayMethodType) {
        /*
         // 异步运行请求更改照片库的块
         // 在任意串行队列上执行更改和完成处理程序块。如果因为更改而更新应用程序的UI，请将这部分工作放到主队列中执行。
         @available(iOS 8, *)
         open func performChanges(_ changeBlock: @escaping () -> Void, completionHandler: ((Bool, Error?) -> Void)? = nil)
         */
        PHPhotoLibrary.shared().performChanges {
            
        } completionHandler: { success, error in
            if success {
                
            }
        }

        
        ATLog("异步运行请求更改照片库的块", funcName: type.rawValue)
    }
    
    func performChangesAndWait(type: PHPhotoLibrayMethodType) {
        /*
         // 同步运行一个块，请求在照片库中执行更改
         // 不要从主线程调用这个方法。你的更改块以及照片代表您执行以应用其请求的更改的工作需要一些时间来执行。（照片可能需要提示用户执行更改，因此此方法可以无限期地阻止执行。）
         // 如果您已经在后台队列上执行工作，导致将更改应用于照片库，请使用此方法。要从主队列请求更改，请改用方法 performChanges(_:completionHandler:)
         @available(iOS 8, *)
         open func performChangesAndWait(_ changeBlock: @escaping () -> Void) throws
         */
        do {
            try PHPhotoLibrary.shared().performChangesAndWait {
                
            }
        } catch {
            
        }
        
        ATLog("同步运行一个块，请求在照片库中执行更改", funcName: type.rawValue)
    }
    
    func registerChangeObserver(type: PHPhotoLibrayMethodType) {
        /*
         // 注册一个对象以在照片库中的对象发生变化时接收消息
         @available(iOS 8, *)
         open func register(_ observer: PHPhotoLibraryChangeObserver)
         */
        PHPhotoLibrary.shared().register(self)
        ATLog("注册一个对象以在照片库中的对象发生变化时接收消息", funcName: type.rawValue)
    }
    
    func unregisterChangeObserver(type: PHPhotoLibrayMethodType) {
        /*
         // 取消注册对象，使其不再接收更改消息
         @available(iOS 8, *)
         open func unregisterChangeObserver(_ observer: PHPhotoLibraryChangeObserver)
         */
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
        ATLog("取消注册对象，使其不再接收更改消息", funcName: type.rawValue)
    }
    
    func registerAvailabilityObserver(type: PHPhotoLibrayMethodType) {
        /*
         // 注册一个对象以观察照片库可用性的变化
         @available(iOS 13, *)
         open func register(_ observer: PHPhotoLibraryAvailabilityObserver)
         */
//        PHPhotoLibrary.shared().register(self)
        ATLog("注册一个对象以观察照片库可用性的变化", funcName: type.rawValue)
    }
    
    func unregisterAvailabilityObserver(type: PHPhotoLibrayMethodType) {
        /*
         // 从观察照片库可用性的变化中取消注册对象
         @available(iOS 13, *)
         open func unregisterAvailabilityObserver(_ observer: PHPhotoLibraryAvailabilityObserver)
         */
//        PHPhotoLibrary.shared().unregisterAvailabilityObserver(self)
        ATLog("从观察照片库可用性的变化中取消注册对象", funcName: type.rawValue)
    }
}

extension PHPhotoLibraryViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        ATLog("照片库有变化", funcName: "photoLibraryDidChange(_ changeInstance: PHChange)")
    }
}

// 由于注册变化观察者，可用性观察者的方法名一样，同一个类继承这个协议，会报register方法歧义的错误

//extension PHPhotoLibraryViewController: PHPhotoLibraryAvailabilityObserver {
//    func photoLibraryDidBecomeUnavailable(_ photoLibrary: PHPhotoLibrary) {
//        ATLog("", funcName: "photoLibraryDidBecomeUnavailable(_ photoLibrary: PHPhotoLibrary)")
//    }
//}

private enum PHPhotoLibrayPropertyType: String {
    case unavailabilityReason
}

private enum PHPhotoLibrayMethodType: String {
    // 验证权限
    case authorizationStatus = "authorizationStatus(for accessLevel: PHAccessLevel) -> PHAuthorizationStatus"
    case requestAuthorization = "requestAuthorization(for accessLevel: PHAccessLevel, handler: @escaping (PHAuthorizationStatus) -> Void)"
    
    // 更新库
    case performChanges = "performChanges(_ changeBlock: @escaping () -> Void, completionHandler: ((Bool, Error?) -> Void)? = nil)"
    case performChangesAndWait = "performChangesAndWait(_ changeBlock: @escaping () -> Void) throws"
    
    // 观察库的变化
    case registerChangeObserver = "register(_ observer: PHPhotoLibraryChangeObserver)"
    case unregisterChangeObserver = "unregisterChangeObserver(_ observer: PHPhotoLibraryChangeObserver)"
    
    // 观察库的可用性
    case registerAvailabilityObserver = "register(_ observer: PHPhotoLibraryAvailabilityObserver)"
    case unregisterAvailabilityObserver = "unregisterAvailabilityObserver(_ observer: PHPhotoLibraryAvailabilityObserver)"
}
