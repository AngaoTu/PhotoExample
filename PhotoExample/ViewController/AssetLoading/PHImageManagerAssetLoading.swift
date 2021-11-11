//
//  PHImageManagerAssetLoading.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/8/30.
//

import Foundation
import UIKit
import Photos

class PHImageManagerAssetLoading: BaseTableViewController {
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [PHImageManagerMethodType.requestImageForAsset, PHImageManagerMethodType.requestImageDataAndOrientationForAsset, PHImageManagerMethodType.cancelImageRequest, PHImageManagerMethodType.requestLivePhotoForAsset, PHImageManagerMethodType.requestPlayerItem, PHImageManagerMethodType.requestExportSession, PHImageManagerMethodType.requestAVAsset]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHImageManager"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
        tableView.rowHeight = 120
    }
}

extension PHImageManagerAssetLoading {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
  
        guard let type = dataList[indexPath.row] as? PHImageManagerMethodType else { return UITableViewCell () }
        cell.textString = "\(type.rawValue)"
        return cell   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = dataList[indexPath.row] as? PHImageManagerMethodType else { return }
        switch type {
        case .requestImageForAsset:
            requestImageForAsset(type: type)
        case .requestImageDataAndOrientationForAsset:
            requestImageDataAndOrientationForAsset(type: type)
        case .cancelImageRequest:
            break
        case .requestLivePhotoForAsset:
            requestLivePhotoForAsset(type: type)
        case .requestPlayerItem:
            requestPlayerItem(type: type)
        case .requestExportSession:
            requestExportSession(type: type)
        case .requestAVAsset:
            requestAVAsset(type: type)
        }
    }
}

// MARK: - 加载图片
private extension PHImageManagerAssetLoading {
    func requestImageForAsset(type: PHImageManagerMethodType) {
        /*
         @abstract请求指定资产的图像表示。
         @param asset要加载其图像数据的资产。
         @param targetSize要返回的图像目标大小。
         @param contentMode一个如何使图像适合于所请求大小的宽高比的选项。
         如果资源的宽高比不匹配给定的targetSize, contentMode决定如何调整图像的大小。
         PHImageContentModeAspectFit:通过保持宽高比来适应要求的大小，交付的图像不一定是要求的targetSize(见PHImageRequestOptionsDeliveryMode和PHImageRequestOptionsResizeMode)
         PHImageContentModeAspectFill:填充要求的大小，部分内容可能被剪切，交付的图像不一定是要求的targetSize(见PHImageRequestOptionsDeliveryMode和PHImageRequestOptionsResizeMode)
         PHImageContentModeDefault:当size为PHImageManagerMaximumSize时使用PHImageContentModeDefault(尽管不会对结果进行缩放/裁剪)
         @param options选项，指定照片应该如何处理请求，格式化请求的图像，并通知应用程序的进展或错误。
         如果-[PHImageRequestOptions isSynchronous]返回NO(或者options为nil)， resultHandler可能被调用1次或更多次。通常，在这种情况下，resultHandler将在主线程上与请求的结果异步调用。但是，如果deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic，如果有任何图像数据立即可用，则可能在调用线程上同步调用resultHandler。如果在第一次传递中返回的图像数据质量不足，则稍后将在主线程上以异步方式调用resultHandler，并返回“正确的”结果。如果请求被取消，则可能根本不会调用resultHandler。
         如果-[PHImageRequestOptions isSynchronous]返回YES，则resultHandler将在调用线程上被同步地调用一次。同步请求不能被取消。
         根据PHImageRequestOptions options参数中指定的选项，在当前线程上同步调用或在主线程上异步调用一次或多次的块。
         @return请求的数字标识符。如果您需要在请求完成之前取消请求，请将此标识符传递给cancelImageRequest:方法。
         
         // 通过PHAsset获取UIImage
         @available(iOS 8, *)
         open func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID
         */
        let asset = PHAsset.fetchAssets(with: nil).firstObject
        PHImageManager.default().requestImage(for: asset!, targetSize: CGSize(width: 320, height: 320), contentMode: .aspectFit, options: nil) { image, infos in
            ATLog("通过PHAsset获取UIImage: image = \(image) \n infos = \(infos)", funcName: type.rawValue)
        }
    }
    
    func requestImageDataAndOrientationForAsset(type: PHImageManagerMethodType) {
        /*
         ／**
         @abstract请求指定资产的最大表示为数据字节的图像。
         @param asset要加载其图像数据的资产。
         @param options选项，指定照片应该如何处理请求，格式化请求的图像，并通知应用程序的进展或错误。
         如果请求PHImageRequestOptionsVersionCurrent，并且资源进行了调整，则返回最大的渲染图像数据。在所有其他情况下，返回原始图像数据。
         @param resultHandler一个块，根据PHImageRequestOptions选项参数中指定的同步选项(deliveryMode被忽略)，它在当前线程上被同步调用一次，在主线程上被异步调用一次。
         *／

         ／**
         @abstract请求指定资产的最大表示为数据字节和EXIF方向的图像。
         @param asset要加载其图像数据的资产。
         @param options选项，指定照片应该如何处理请求，格式化请求的图像，并通知应用程序的进展或错误。
         如果请求PHImageRequestOptionsVersionCurrent，并且资源进行了调整，则返回最大的渲染图像数据。在所有其他情况下，返回原始图像数据。
         @param resultHandler一个块，根据PHImageRequestOptions选项参数中指定的同步选项(deliveryMode被忽略)，它在当前线程上被同步调用一次，在主线程上被异步调用一次。Orientation是作为CGImagePropertyOrientation的EXIF方向。对于iOS或tvOS，将其转换为UIImageOrientation。
         *／
         
         // 请求指定PHAsset的最大字节的图像和EXIF方向
         @available(iOS 13, *)
         open func requestImageDataAndOrientation(for asset: PHAsset, options: PHImageRequestOptions?, resultHandler: @escaping (Data?, String?, CGImagePropertyOrientation, [AnyHashable : Any]?) -> Void) -> PHImageRequestID
         */
        
        let asset = PHAsset.fetchAssets(with: nil).firstObject
        
        PHImageManager.default().requestImageDataAndOrientation(for: asset!, options: nil) { imageData, imageType, exif, infos in
            ATLog("请求指定PHAsset的最大字节的图像和EXIF方向\n imageDataLength = \(String(describing: imageData?.count)) \n imageType = \(imageType ?? "") \n exif = \(exif.rawValue)", funcName: type.rawValue)
            for (key, value) in infos! {
                if (key as! String) == "PHImageFileDataKey" { continue }
                ATLog("请求指定PHAsset的最大字节的图像和EXIF方向\n key = \(key) \n value = \(value)", funcName: type.rawValue)
            }
        }
    }
}

// MARK: - 加载视频
private extension PHImageManagerAssetLoading {
    func requestPlayerItem(type: PHImageManagerMethodType) {
        /*
         // 通过PHAsset获取AVPlayerItem
         @available(iOS 8, *)
         open func requestPlayerItem(forVideo asset: PHAsset, options: PHVideoRequestOptions?, resultHandler: @escaping (AVPlayerItem?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID
         */
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        let asset = PHAsset.fetchAssets(with: options).firstObject
        PHImageManager.default().requestPlayerItem(forVideo: asset!, options: nil) { avplayer, infos in
            ATLog("通过PHAsset获取PHLivePhoto: AVPlayerItem =  \(avplayer) \n infos = \(infos)", funcName: type.rawValue)
        }
    }
    
    func requestExportSession(type: PHImageManagerMethodType) {
        /*
         // 通过PHAsset获取AVAssetExportSession
         @available(iOS 8, *)
         open func requestExportSession(forVideo asset: PHAsset, options: PHVideoRequestOptions?, exportPreset: String, resultHandler: @escaping (AVAssetExportSession?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID
         */
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        let asset = PHAsset.fetchAssets(with: options).firstObject
        PHImageManager.default().requestExportSession(forVideo: asset!, options: nil, exportPreset: "test") { avassetExportSeesion, infos in
            ATLog("通过PHAsset获取AVAssetExportSession: AVAssetExportSession =  \(avassetExportSeesion) \n infos = \(infos)", funcName: type.rawValue)
        }
    }
    
    func requestAVAsset(type: PHImageManagerMethodType) {
        /*
         // 通过PHAsset获取AVAsset
         @available(iOS 8, *)
         open func requestAVAsset(forVideo asset: PHAsset, options: PHVideoRequestOptions?, resultHandler: @escaping (AVAsset?, AVAudioMix?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID
         */
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        let asset = PHAsset.fetchAssets(with: options).firstObject
        PHImageManager.default().requestAVAsset(forVideo: asset!, options: nil) { avAsset, avAudioMix, infos in
            ATLog("通过PHAsset获取AVAsset: AVAsset = \(avAsset) \n AVAudioMix = \(avAudioMix) \n infos = \(infos)", funcName: type.rawValue)
        }
    }
}

// MARK: - 加载Live Photo
private extension PHImageManagerAssetLoading {
    func requestLivePhotoForAsset(type: PHImageManagerMethodType) {
        /*
         // 请求资源的实时照片表示。使用PHImageRequestOptionsDeliveryModeOpportunistic(或者如果没有指定选项)，resultHandler块可以被调用多次(第一次调用可能发生在方法返回之前)。结果处理程序的info参数中的PHImageResultIsDegradedKey键指示何时提供了一个临时的低质量的实时照片。
         
         // 通过PHAsset获取PHLivePhoto
         @available(iOS 9.1, *)
         open func requestLivePhoto(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHLivePhotoRequestOptions?, resultHandler: @escaping (PHLivePhoto?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID
         */
        
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaSubtypes = %d", PHAssetMediaSubtype.photoLive.rawValue)
        let asset = PHAsset.fetchAssets(with: options).firstObject
        PHImageManager.default().requestLivePhoto(for: asset!, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: nil) { livePhoto, infos in
            ATLog("通过PHAsset获取PHLivePhoto: \(livePhoto) \n infos = \(infos)", funcName: type.rawValue)
        }
    }
}

private enum PHImageManagerMethodType: String {
    case requestImageForAsset = "requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID"
    case requestImageDataAndOrientationForAsset = "requestImageDataAndOrientation(for asset: PHAsset, options: PHImageRequestOptions?, resultHandler: @escaping (Data?, String?, CGImagePropertyOrientation, [AnyHashable : Any]?) -> Void) -> PHImageRequestID"
    case cancelImageRequest = "cancelImageRequest(_ requestID: PHImageRequestID)"
    case requestLivePhotoForAsset = "requestLivePhoto(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHLivePhotoRequestOptions?, resultHandler: @escaping (PHLivePhoto?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID"
    case requestPlayerItem = "requestPlayerItem(forVideo asset: PHAsset, options: PHVideoRequestOptions?, resultHandler: @escaping (AVPlayerItem?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID"
    case requestExportSession = "requestExportSession(forVideo asset: PHAsset, options: PHVideoRequestOptions?, exportPreset: String, resultHandler: @escaping (AVAssetExportSession?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID"
    case requestAVAsset = "requestAVAsset(forVideo asset: PHAsset, options: PHVideoRequestOptions?, resultHandler: @escaping (AVAsset?, AVAudioMix?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID"
}
