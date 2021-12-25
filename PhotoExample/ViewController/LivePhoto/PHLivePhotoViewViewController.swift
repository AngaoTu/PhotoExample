//
//  PHLivePhotoViewViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/12/25.
//

import Foundation
import Photos
import UIKit
import PhotosUI

class PHLivePhotoViewViewController: BaseTableViewController {
    // MARK: - initialization
    init() {
        self.currentLivePhotoView = PHLivePhotoView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [[PHLivePhotoViewPropertyType.livePhoto, PHLivePhotoViewPropertyType.isMuted, PHLivePhotoViewPropertyType.playbackGestureRecognizer], [PHLivePhotoViewMethodType.livePhotoBadgeImage, PHLivePhotoViewMethodType.startPlayback, PHLivePhotoViewMethodType.stopPlayback]]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHLivePhotoView模型"
    }
    
    // MARK: - Private Property
    private let currentLivePhotoView: PHLivePhotoView
}

extension PHLivePhotoViewViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHLivePhotoViewPropertyType else { return UITableViewCell () }
            var textString = ""
            switch type {
            case .livePhoto:
                textString = livePhoto()
            case .isMuted:
                textString = isMuted()
            case .playbackGestureRecognizer:
                textString = playbackGestureRecognizer()
            }
            cell.textString = "\(type): \n\(textString)"
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHLivePhotoViewMethodType else { return UITableViewCell () }
            cell.textString = "\(type.rawValue)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHLivePhotoViewMethodType else { return }
            switch type {
            case .livePhotoBadgeImage:
                livePhotoBadgeImage(type: type)
            case .startPlayback:
                break
            case .stopPlayback:
                break
            }
        }
    }
}

// MARK: - Private Method
private extension PHLivePhotoViewViewController {
    // MARK: Property
    func livePhoto() -> String {
        /*
         // 视图中显示的实况图片
         @available(iOS 9.1, *)
         open var livePhoto: PHLivePhoto?
         */
        return "\(currentLivePhotoView.livePhoto)"
    }
    
    func isMuted() -> String {
        /*
         // 是否播放实况照片中的音频内容
         // 默认值为false，表示视图会随其 Live Photo 的运动内容一起播放音频内容
         @available(iOS 9.1, *)
         open var isMuted: Bool
         */
        return "\(currentLivePhotoView.isMuted)"
    }
    
    func playbackGestureRecognizer() -> String {
        /*
         // 控制视图中实时照片播放的手势识别器
         @available(iOS 9.1, *)
         open var playbackGestureRecognizer: UIGestureRecognizer { get }
         */
        return "\(currentLivePhotoView.playbackGestureRecognizer)"
    }
    
    // MARK: Method
    func livePhotoBadgeImage(type: PHLivePhotoViewMethodType) {
        /*
         // 返回指定LivePhoto选项的图标
         // 默认情况下，此方法返回适合用作模板图像的纯色图像，您可以对其进行着色，以便在特定背景下显示。(使用UIImage类来创建模板图像。)当您计划将图标覆盖在动画的Live Photo内容上时，添加overContent选项以获得一个提供额外背景对比度的图像(不适合模板使用)。
         
         @available(iOS 9.1, *)
         open class func livePhotoBadgeImage(options badgeOptions: PHLivePhotoBadgeOptions = []) -> UIImage
         
         public struct PHLivePhotoBadgeOptions : OptionSet {
             public init(rawValue: UInt)

             ///< Include treatments so this image can be shown directly over the content of the Live Photo
             @available(iOS 9.1, *)
             public static var overContent: PHLivePhotoBadgeOptions { get } // 使该图像可以直接显示在Live Photo的内容上

             @available(iOS 9.1, *)
             public static var liveOff: PHLivePhotoBadgeOptions { get } // 表示Live Photo已经关闭，将被当作静态图片处理(例如，用于共享)
         }
         */
        let images = PHLivePhotoView.livePhotoBadgeImage(options: [.overContent])
        ATLog("image = \(images)", funcName: type.rawValue)
    }
    
    func startPlayback() {
        /*
         // 开始在视图中播放实况照片内容
         // 通常，应用程序不需要直接控制播放，因为 Live Photo 视图提供交互式播放控制。仅当适合非交互式播放时才使用此方法 - 例如，为内容短暂设置动画以指示视图包含实时照片而不是静止图像。
         @available(iOS 9.1, *)
         open func startPlayback(with playbackStyle: PHLivePhotoViewPlaybackStyle)
         
         @available(iOS 9.1, iOS 9.1, *)
         public enum PHLivePhotoViewPlaybackStyle : Int {

             @available(iOS 9.1, *)
             case undefined = 0 // 无法使用

             @available(iOS 9.1, *)
             case full = 1 // 回放 Live Photo 的整个运动和声音内容，包括开始和结束时的过渡效果

             @available(iOS 9.1, *)
             case hint = 2 // 仅播放 Live Photo 运动内容的一小部分，没有声音。
         }
         */
    }
    
    func stopPlayback() {
        /*
         // 停止播放实况照片
         @available(iOS 9.1, *)
         open func stopPlayback()
         */
    }
}

private enum PHLivePhotoViewPropertyType: String {
    case livePhoto
    case isMuted
    case playbackGestureRecognizer
}

private enum PHLivePhotoViewMethodType: String {
    case livePhotoBadgeImage = "livePhotoBadgeImage(options badgeOptions: PHLivePhotoBadgeOptions = []) -> UIImage"
    case startPlayback = "startPlayback(with playbackStyle: PHLivePhotoViewPlaybackStyle)"
    case stopPlayback = "stopPlayback()"
}
