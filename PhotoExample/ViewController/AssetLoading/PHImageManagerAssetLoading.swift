//
//  PHImageManagerAssetLoading.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/8/30.
//

import Foundation
import UIKit
import Photos

class PHImageManagerAssetLoading {
    static let shared = PHImageManagerAssetLoading()
    private init() {}
}

// MARK: - 加载图片
extension PHImageManagerAssetLoading {
    static func loadImage(asset: PHAsset) -> UIImageView {
//        PHImageManager.default().requestImage(for: <#T##PHAsset#>, targetSize: <#T##CGSize#>, contentMode: <#T##PHImageContentMode#>, options: <#T##PHImageRequestOptions?#>, resultHandler: <#T##(UIImage?, [AnyHashable : Any]?) -> Void#>)
//        let options = PHImageRequestOptions()
//        options.resizeMode = .fast
//        options.isSynchronous = false
//        options.deliveryMode = .opportunistic
//        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 320, height: 320), contentMode: .aspectFill, options: options) { image, infos in
//            cell.image = image
//        }
        return UIImageView()
    }
    
    static func loadImageData() -> UIImageView {
//        PHImageManager.default().requestImageDataAndOrientation(for: <#T##PHAsset#>, options: <#T##PHImageRequestOptions?#>, resultHandler: <#T##(Data?, String?, CGImagePropertyOrientation, [AnyHashable : Any]?) -> Void#>)
        return UIImageView()
    }
}

// MARK: - 加载视频
extension PHImageManagerAssetLoading {
    
}

// MARK: - 加载Live Photo
extension PHImageManagerAssetLoading {
    
}
