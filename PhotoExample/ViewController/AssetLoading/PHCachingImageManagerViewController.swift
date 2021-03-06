//
//  PHCachingImageManagerViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/11/12.
//

import Foundation
import UIKit
import Photos

class PHCachingImageManagerViewController: BaseTableViewController {
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [[PHCachingImageManagerPropertyTyep.allowsCachingHighQualityImages], [PHCachingImageManagerMethodType.startCachingImages, PHCachingImageManagerMethodType.stopCachingImages, PHCachingImageManagerMethodType.stopCachingImagesForAllAssets, PHCachingImageManagerMethodType.requestImage]]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHCachingImageManager"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
        tableView.rowHeight = 100
    }
}

extension PHCachingImageManagerViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
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
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHCachingImageManagerPropertyTyep else { return UITableViewCell () }
            var textString = ""
            switch type {
            case .allowsCachingHighQualityImages:
                textString = allowsCachingHighQualityImages()
            }
            cell.textString = "\(type): \(textString)"
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHCachingImageManagerMethodType else { return UITableViewCell () }
            cell.textString = "\(type.rawValue)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHCachingImageManagerMethodType else { return }
            switch type {
            case .startCachingImages:
                startCachingImages(type: type)
            case .stopCachingImages:
                stopCachingImages(type: type)
            case .stopCachingImagesForAllAssets:
                stopCachingImagesForAllAssets(type: type)
            case .requestImage:
                requestImage()
            }
        }
    }
}

// MARK: - Private Method
private extension PHCachingImageManagerViewController {
    // MARK: Property
    func allowsCachingHighQualityImages() -> String {
        /*
         // ????????????????????????????????????false
         // ??????????????????????????????????????????????????????????????????
         @available(iOS 8, *)
         open var allowsCachingHighQualityImages: Bool // Defaults to false
         */
        
        return String(PHCachingImageManager.default().allowsCachingHighQualityImages)
    }
    
    // MARK: Method
    func startCachingImages(type: PHCachingImageManagerMethodType) {
        /*
         // ??????????????????PHAssets
         @available(iOS 8, *)
         open func startCachingImages(for assets: [PHAsset], targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?)
         */
        
        let assetsResult = PHAsset.fetchAssets(with: nil)
        var assets: [PHAsset] = []
        assetsResult.enumerateObjects { asset, index, stop in
            assets.append(asset)
        }
        
        let options = PHImageRequestOptions()
        options.version = .original
//        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        options.resizeMode = .exact
        
        PHCachingImageManager.default().startCachingImages(for: assets, targetSize: CGSize(width: 320, height: 320), contentMode: .aspectFill, options: options)
        ATLog("??????????????????PHAssets", funcName: type.rawValue)
    }
    
    func stopCachingImages(type: PHCachingImageManagerMethodType) {
        /*
         // ??????????????????PHAssets
         @available(iOS 8, *)
         open func stopCachingImages(for assets: [PHAsset], targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?)

         */
        
        ATLog("??????????????????PHAssets", funcName: type.rawValue)
    }
    
    func stopCachingImagesForAllAssets(type: PHCachingImageManagerMethodType) {
        /*
         // ?????????????????????????????????
         @available(iOS 8, *)
         open func stopCachingImagesForAllAssets()
         */
        
        PHCachingImageManager.default().stopCachingImagesForAllAssets()
        ATLog("?????????????????????????????????", funcName: type.rawValue)
    }
    
    func requestImage() {
        let assetsResult = PHAsset.fetchAssets(with: nil)
        var assets: [PHAsset] = []
        assetsResult.enumerateObjects { asset, index, stop in
            assets.append(asset)
        }
        
        let options = PHImageRequestOptions()
        options.version = .original
//        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        options.resizeMode = .exact
        
        ATLog("?????????????????? date = \(Date())")
        for asset in assets {
            PHCachingImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 320, height: 320), contentMode: .aspectFill, options: options) { image, infos in
                ATLog("?????????????????? date = \(Date())")
            }
        }
    }
}

private enum PHCachingImageManagerPropertyTyep: String {
    case allowsCachingHighQualityImages
}

private enum PHCachingImageManagerMethodType: String {
    case startCachingImages = "startCachingImages(for assets: [PHAsset], targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?)"
    case stopCachingImages = "stopCachingImages(for assets: [PHAsset], targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?)"
    case stopCachingImagesForAllAssets = "stopCachingImagesForAllAssets()"
    case requestImage = "??????????????????????????????????????????requestImage"
}

// MARK: - PHCachingImageManager??????
extension PHCachingImageManager {
    private static let shared = PHCachingImageManager()
    
    public override static func `default`() -> PHCachingImageManager {
//        shared.allowsCachingHighQualityImages = true
        return shared
    }
}
