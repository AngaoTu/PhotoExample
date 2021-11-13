//
//  AssetLoadingViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/9/1.
//

import Foundation
import UIKit
import Photos

class AssetLoadingViewContoller: BaseTableViewController {
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [AssetLoadingType.PHImageRequetOptions, AssetLoadingType.PHLivePhotoRequestOptions, AssetLoadingType.PHVideoRequestOptions, AssetLoadingType.PHImageManager, AssetLoadingType.PHCachingImageManager, AssetLoadingType.ImageOptionsPriority]
    }
    
    override func initView() {
        super.initView()
        self.title = "加载资源"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
    }
    
    // MARK: - 私有属性
    
}

extension AssetLoadingViewContoller {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell,
              let type = dataList[indexPath.row] as? AssetLoadingType else {
            return UITableViewCell()
        }
        cell.textString = type.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = dataList[indexPath.row] as? AssetLoadingType else { return }
        switch type {
        case .PHImageRequetOptions:
            let imageRequestViewController = PHImageRequestOptionsViewController()
            self.navigationController?.pushViewController(imageRequestViewController, animated: true)
        case .PHLivePhotoRequestOptions:
            let livePhotoViewController = PHLivePhotoRequestOptionsViewController()
            self.navigationController?.pushViewController(livePhotoViewController, animated: true)
        case .PHVideoRequestOptions:
            let videoViewController = PHVideoRequestOptionsViewController()
            self.navigationController?.pushViewController(videoViewController, animated: true)
        case .PHImageManager:
            let imageManager = PHImageManagerViewController()
            self.navigationController?.pushViewController(imageManager, animated: true)
        case .PHCachingImageManager:
            let cachingImageManaer = PHCachingImageManagerViewController()
            self.navigationController?.pushViewController(cachingImageManaer, animated: true)
        case .ImageOptionsPriority:
            propertyPriorityTest()
        }
    }
}

// MARK: - Private Method
private extension AssetLoadingViewContoller {
    func propertyPriorityTest() {
        guard let asset = PHAsset.fetchAssets(with: nil).firstObject else { return }
        
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 320, height: 320), contentMode: .aspectFill, options: options) { image, infos in
//            ATLog("测试options属性的优先级")
            ATLog("options1 原来width= \(asset.pixelWidth) height = \(asset.pixelHeight) \n 获取图片大小 width = \(image!.size.width) height = \(image!.size.height)")
            ATLog("options1 isSynchronous = \(options.isSynchronous) deliveryMode = \(options.deliveryMode.rawValue)")

            let imageData = image?.pngData()
            ATLog("options1 imageData = \(imageData!.count)")
        }
        
//        print("********************************************************\n")
        
//        options.resizeMode = .fast
//        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 320, height: 320), contentMode: .aspectFill, options: options) { image, infos in
////            ATLog("测试options属性的优先级")
//            ATLog("options2 原来width= \(asset.pixelWidth) height = \(asset.pixelHeight) \n 获取图片大小 width = \(image!.size.width) height = \(image!.size.height)")
//            ATLog("options2 isSynchronous = \(options.isSynchronous) deliveryMode = \(options.deliveryMode.rawValue)")
//
//            let imageData = image?.pngData()
//            ATLog("options2 imageData = \(imageData!.count)")
//        }
        
//        print("********************************************************\n")
//
//        options.resizeMode = .exact
//        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 320, height: 320), contentMode: .aspectFill, options: options) { image, infos in
////            ATLog("测试options属性的优先级")
//            ATLog("options3 原来width= \(asset.pixelWidth) height = \(asset.pixelHeight) \n 获取图片大小 width = \(image!.size.width) height = \(image!.size.height)")
//            ATLog("options3 isSynchronous = \(options.isSynchronous) deliveryMode = \(options.deliveryMode.rawValue)")
//
//            let imageData = image?.pngData()
//            ATLog("options3 imageData = \(imageData!.count)")
//        }
    }
}

private enum AssetLoadingType: String {
    case PHImageRequetOptions
    case PHLivePhotoRequestOptions
    case PHVideoRequestOptions
    case PHImageManager
    case PHCachingImageManager
    case ImageOptionsPriority = "测试ImageRequestOptions中属性优先级"
}
