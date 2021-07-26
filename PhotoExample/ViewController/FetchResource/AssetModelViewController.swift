//
//  AssetModelViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/26.
//

import UIKit
import Photos

class AssetModelViewController: UIViewController {
    // MARK: - initialization
    init(asset: PHAsset) {
        super.init(nibName: nil, bundle: nil)
        self.currentAsset = asset
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    // MARK: - 私有属性
    private lazy var tableView: UITableView = {
        let temp = UITableView()
        temp.delegate = self
        temp.dataSource = self
        temp.rowHeight = 88
        temp.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
        return temp
    }()
    
    private let dataList: [PHAssetModelFieldType] = [.localIdentifier, .playbackStyle, .mediaType, .mediaSubtypes, .pixelWidth, .pixeHeight, .creationDate, .modificationDate, .location, .duration, .isHidden, .isFavorite, .burstIdentifier, .burstSelectionTypes, .representBurst, .sourceType]
    
    private var currentAsset: PHAsset?
}

extension AssetModelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        
        var textString = ""
        switch dataList[indexPath.row] {
        case .localIdentifier:
            textString = localIdentifier()
        case .playbackStyle:
            textString = playbackStyle()
        case .mediaType:
            textString = mediaType()
        case .mediaSubtypes:
            textString = mediaSubtypes()
        case .pixelWidth:
            guard let width = currentAsset?.pixelWidth else { break }
            textString = "\(width)"
        case .pixeHeight:
            guard let height = currentAsset?.pixelHeight else { break }
            textString = "\(height)"
        case .creationDate:
            textString = creationDate()
        case .modificationDate:
            textString = modificationDate()
        case .location:
            textString = location()
        case .duration:
            textString = duration()
        case .isHidden:
            guard let isHidden = currentAsset?.isHidden else { break }
            textString = "\(isHidden)"
        case .isFavorite:
            guard let isFavorite = currentAsset?.isFavorite else { break }
            textString = "\(isFavorite)"
        case .burstIdentifier:
            textString = burstIdentifier()
        case .burstSelectionTypes:
            textString = burstSelectionTypes()
        case .representBurst:
            textString = representsBurst()
        case .sourceType:
            textString = sourceType()
        }
        
        cell.textString = "\(dataList[indexPath.row].rawValue): \(textString)"
        return cell
    }
}

private extension AssetModelViewController {
    func initView() {
        view.backgroundColor = .white
        self.title = "PHAsset模型"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func localIdentifier() -> String {
        /*
         // 由于PHAsset继承PHObject，所以它第一个属性应该是localIdentifier，也就是该资源唯一标识符
         open var localIdentifier: String { get }
         */
        return currentAsset?.localIdentifier ?? ""
    }
    
    func playbackStyle() -> String {
        /*
         // PHAsset中playbackStyle属性，表示通过什么方式来播放该资源
         @available(iOS 11, *)
         open var playbackStyle: PHAsset.PlaybackStyle { get }
         
         
         public enum PlaybackStyle : Int {
             @available(iOS 8, *)
             case unsupported = 0 // 未定义资源播放类型

             @available(iOS 8, *)
             case image = 1 // 展示图片

             @available(iOS 8, *)
             case imageAnimated = 2 // 展示动图

             @available(iOS 8, *)
             case livePhoto = 3 // 展示实况图

             @available(iOS 8, *)
             case video = 4 // 展示视频

             @available(iOS 8, *)
             case videoLooping = 5 // 循环展示视频
         }
         */
        var styleString = ""
        let style = currentAsset?.playbackStyle
        switch style {
        case .image:
            styleString = "image"
        case .imageAnimated:
            styleString = "imageAnimated"
        case .livePhoto:
            styleString = "livePhoto"
        case .video:
            styleString = "video"
        case .videoLooping:
            styleString = "videoLooping"
        case .unsupported:
            styleString = "unsupported"
        default:
            break
        }
        return styleString
    }
    
    func mediaType() -> String {
        /*
         // 用来区分该asset的媒体类型
         open var mediaType: PHAssetMediaType { get }
         
         // 一共有三种媒体类型：图片、视频、语音
         public enum PHAssetMediaType : Int {

             @available(iOS 8, *)
             case unknown = 0

             @available(iOS 8, *)
             case image = 1

             @available(iOS 8, *)
             case video = 2

             @available(iOS 8, *)
             case audio = 3
         }
         */
        var mediaTypeString = ""
        switch currentAsset?.mediaType {
        case .image:
            mediaTypeString = "image"
        case .video:
            mediaTypeString = "video"
        case .audio:
            mediaTypeString = "audio"
        default:
            break
        }
        return mediaTypeString
    }
    
    func mediaSubtypes() -> String {
        /*
         open var mediaSubtypes: PHAssetMediaSubtype { get }
         
         public struct PHAssetMediaSubtype : OptionSet {
             public init(rawValue: UInt)
             
             // Photo subtypes
             @available(iOS 8, *)
             public static var photoPanorama: PHAssetMediaSubtype { get } // 全景图

             @available(iOS 8, *)
             public static var photoHDR: PHAssetMediaSubtype { get } // HDR专业相机图

             @available(iOS 9, *)
             public static var photoScreenshot: PHAssetMediaSubtype { get } // 截图

             @available(iOS 9.1, *)
             public static var photoLive: PHAssetMediaSubtype { get } // 实况图

             @available(iOS 10.2, *)
             public static var photoDepthEffect: PHAssetMediaSubtype { get } // 人像模式深度效果捕捉

             
             // Video subtypes
             @available(iOS 8, *)
             public static var videoStreamed: PHAssetMediaSubtype { get } // 从未存储在本地的视频资源

             @available(iOS 8, *)
             public static var videoHighFrameRate: PHAssetMediaSubtype { get } // 高帧率视频

             @available(iOS 8, *)
             public static var videoTimelapse: PHAssetMediaSubtype { get } // 延时视频
         }
         */
        guard let mediaSubtype = currentAsset?.mediaSubtypes else { return "" }
        var mediaSubtypeString = ""
        switch mediaSubtype {
        case .photoPanorama:
            mediaSubtypeString = "photoPanorama"
        case .photoHDR:
            mediaSubtypeString = "photoHDR"
        case .photoScreenshot:
            mediaSubtypeString = "photoScreenshot"
        case .photoLive:
            mediaSubtypeString = "photoLive"
        case .photoDepthEffect:
            mediaSubtypeString = "photoDepthEffect"
        case .videoStreamed:
            mediaSubtypeString = "videoStreamed"
        case .videoHighFrameRate:
            mediaSubtypeString = "videoHighFrameRate"
        case .videoTimelapse:
            mediaSubtypeString = "videoTimelapse"
        default:
            break
        }
        return mediaSubtypeString
    }
    
    func creationDate() -> String {
        /*
         open var creationDate: Date? { get } // 创建时间
         */
        guard let creationDate = currentAsset?.creationDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd号 HH:mm:ss"
        return formatter.string(from: creationDate)
    }
    
    func modificationDate() -> String {
        /*
         open var modificationDate: Date? { get } // 修改时间
         */
        guard let modifcationDate = currentAsset?.creationDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd号 HH:mm:ss"
        return formatter.string(from: modifcationDate)
    }
    
    func location() -> String {
        /*
         open var location: CLLocation? { get } // 拍摄地点
         */
        guard let location = currentAsset?.location?.coordinate else { return "" }
        return "altitude = \(location.latitude) coordinate = \(location.longitude)"
    }
    
    func duration() -> String {
        /*
         open var duration: TimeInterval { get } // 资源时长
         */
        guard let duration = currentAsset?.duration else { return "" }
        return "\(duration)"
    }
    
    func burstIdentifier() -> String {
        /*
         // burstIdentifier表示连拍的标识符，通过fetchAssetsWithBurstIdentifier()方法，传入burstIdentifier属性，可以获取连拍照片中的剩余的其他照片
         open var burstIdentifier: String? { get }
         */
        guard let burstIdentifier = currentAsset?.burstIdentifier else { return "" }
        return burstIdentifier
    }
    
    func burstSelectionTypes() -> String {
        /*
         // 用户可以在连拍的照片中做标记；此外，系统也会自动用各种试探来标记用户可能会选择的潜在代表照片
         open var burstSelectionTypes: PHAssetBurstSelectionType { get }
         
         public struct PHAssetBurstSelectionType : OptionSet {
             public init(rawValue: UInt)
             
             @available(iOS 8, *)
             public static var autoPick: PHAssetBurstSelectionType { get } // 表示用户可能标记的潜在资源

             @available(iOS 8, *)
             public static var userPick: PHAssetBurstSelectionType { get } // 表示用户手动标记的资源
         }
         */
        guard let type = currentAsset?.burstSelectionTypes else { return "" }
        var burstSelectionString = ""
        switch type {
        case .userPick:
            burstSelectionString = "userPick"
        case .autoPick:
            burstSelectionString = "autoPick"
        default:
            break
        }
        return burstSelectionString
    }
    
    func representsBurst() -> String {
        /*
         // 若一个资源的representsBurst属性为true，则表示该资源是一系列连拍照片中的代表照片，可以通过fetchAssetsWithBurstIdentifier()方法，传入burstIdentifier属性，获取连拍照片中的剩余的其他照片
         open var representsBurst: Bool { get }
         */
        guard let result = currentAsset?.representsBurst else { return "" }
        return "\(result)"
    }
    
    func sourceType() -> String {
        /*
         // 表示资源来源类型
         open var sourceType: PHAssetSourceType { get }
         
         public struct PHAssetSourceType : OptionSet {
             public init(rawValue: UInt)
             
             @available(iOS 8, *)
             public static var typeUserLibrary: PHAssetSourceType { get } // 用户相册

             @available(iOS 8, *)
             public static var typeCloudShared: PHAssetSourceType { get } // icloud相册

             @available(iOS 8, *)
             public static var typeiTunesSynced: PHAssetSourceType { get } // iTunes同步
         }
         */
        guard let type = currentAsset?.sourceType else { return "" }
        var sourceTypeString = ""
        switch type {
        case .typeUserLibrary:
            sourceTypeString = "typeUserLibrary"
        case .typeCloudShared:
            sourceTypeString = "typeCloudShared"
        case .typeiTunesSynced:
            sourceTypeString = "typeiTunesSynced"
        default:
            break
        }
        return sourceTypeString
    }
}
private enum PHAssetModelFieldType: String {
    case localIdentifier
    case playbackStyle
    case mediaType
    case mediaSubtypes
    case pixelWidth
    case pixeHeight
    case creationDate
    case modificationDate
    case location
    case duration
    case isHidden
    case isFavorite
    case burstIdentifier
    case burstSelectionTypes
    case representBurst
    case sourceType
}
