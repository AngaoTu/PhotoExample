//
//  AssetModelViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/26.
//

import UIKit
import Photos

class PHAssetViewController: BaseTableViewController {
    // MARK: - initialization
    init(asset: PHAsset, isShowMethod: Bool) {
        self.currentAsset = asset
        self.isShowMethod = isShowMethod
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [
            [PHAssetPropertyType.localIdentifier, PHAssetPropertyType.playbackStyle, PHAssetPropertyType.mediaType, PHAssetPropertyType.mediaSubtypes, PHAssetPropertyType.pixelWidth, PHAssetPropertyType.pixeHeight, PHAssetPropertyType.creationDate, PHAssetPropertyType.modificationDate, PHAssetPropertyType.location, PHAssetPropertyType.duration, PHAssetPropertyType.isHidden, PHAssetPropertyType.isFavorite, PHAssetPropertyType.burstIdentifier, PHAssetPropertyType.burstSelectionTypes, PHAssetPropertyType.representBurst, PHAssetPropertyType.sourceType],
                    [PHAssetMethodType.fetchAssetsInAssetCollection, PHAssetMethodType.fetchAssetsWithIdentifiers, PHAssetMethodType.fetchKeyAssetsInAssetCollection, PHAssetMethodType.fetchAssetsWithBurstIdentidier, PHAssetMethodType.fetchAssetsWithOptions, PHAssetMethodType.fetchAssetsWithMediaType]]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHAsset模型"
        tableView.rowHeight = 60
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
    }
    
    // MARK: - 私有属性
    private var currentAsset: PHAsset?
    private var isShowMethod: Bool
}

extension PHAssetViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = dataList[section] as? [Any] else {
            return 0
        }
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isShowMethod ? dataList.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetPropertyType else { return UITableViewCell () }
            
            var textString = ""
            switch type {
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
            
            cell.textString = "\(type.rawValue): \(textString)"
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetMethodType else { return UITableViewCell () }
            cell.textString = "\(type.rawValue)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetMethodType else { return }
            switch type {
            case .fetchAssetsInAssetCollection:
                fetchAssetsInAssetCollection(type: type)
            case .fetchAssetsWithIdentifiers:
                fetchAssetsWithIdentifiers(type: type)
            case .fetchKeyAssetsInAssetCollection:
                fetchKeyAssetsInAssetCollection(type: type)
            case .fetchAssetsWithOptions:
                fetchAssetsWithOptions(type: type)
            case .fetchAssetsWithMediaType:
                fetchAssetsWithMediaType(type: type)
            case .fetchAssetsWithBurstIdentidier:
                fetchAssetsWithBurstIdentidier(type: type)
            }
        }
    }
}

// MARK: - Private Method
private extension PHAssetViewController {
    // MARK: Properties
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
    
    // MARK: Metheds
    func fetchAssetsInAssetCollection(type: PHAssetMethodType) {
        /*
         // 从指定的资产集合中检索资产
         @available(iOS 8, *)
         open class func fetchAssets(in assetCollection: PHAssetCollection, options: PHFetchOptions?) -> PHFetchResult<PHAsset>
         */
        
        // 先获取一个相册
        guard let lastAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil).lastObject else { return }
        // 然后再获取该相册中图片
        let assets = PHAsset.fetchAssets(in: lastAlbum, options: nil)
        skipAssetListViewController(fetchResult: assets)
        ATLog("获取最后一个相册中的资源", funcName: type.rawValue)
    }
    
    func fetchAssetsWithIdentifiers(type: PHAssetMethodType) {
        /*
         // 检索具有指定的本地设备特定唯一标识符的资产
         @available(iOS 8, *)
         open class func fetchAssets(withLocalIdentifiers identifiers: [String], options: PHFetchOptions?) -> PHFetchResult<PHAsset> // includes hidden assets by default
         */
        
        // 这是为了举一个通过localIdentifier来获取PHAsset例子，由于没有现成的localIdentifier，所以采用以下方式绕了一个圈
        // 先获取一个相册
        guard let firstAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil).firstObject else { return }
        // 先获取该相册所有asset
        let assets = PHAsset.fetchAssets(in: firstAlbum, options: nil)
        // 再获取该相册中所有图片的localIdentifier
        var localIdentifiers: [String] = []
        for i in 0..<assets.count {
            let asset = assets[i]
            localIdentifiers.append(asset.localIdentifier)
        }
        // 再通过localIdentifers来获取对应的图片
        let assetsByLocalIdentifiers = PHAsset.fetchAssets(withLocalIdentifiers: localIdentifiers, options: nil)
        skipAssetListViewController(fetchResult: assetsByLocalIdentifiers)
        ATLog("通过本地标识符集合来获取图片数据", funcName: type.rawValue)
    }
    
    func fetchKeyAssetsInAssetCollection(type: PHAssetMethodType) {
        /*
         // 获取某个资产合集中关键资产
         @available(iOS 8, *)
         open class func fetchKeyAssets(in assetCollection: PHAssetCollection, options: PHFetchOptions?) -> PHFetchResult<PHAsset>?
         */
        
        // 先获取一个相册
        guard let lastAlbum = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil).lastObject else { return }
        // 然后再获取该相册中图片
        guard let assets = PHAsset.fetchKeyAssets(in: lastAlbum, options: nil) else { return }
        skipAssetListViewController(fetchResult: assets)
        ATLog("检索在指定资产集合中标记为关键资产的资产", funcName: type.rawValue)
    }
    
    func fetchAssetsWithBurstIdentidier(type: PHAssetMethodType) {
        /*
         // 检索具有指定连拍照片序列标识符的资产
         // 默认情况下，返回的对象仅包含代表性资产和任何用户从连拍序列中挑选的照片。如果要检索连拍序列中的所有照片，请提供一个包含过滤谓词的对象，PHFetchResult中includeAllBurstAssets设置为true
         @available(iOS 8, *)
         open class func fetchAssets(withBurstIdentifier burstIdentifier: String, options: PHFetchOptions?) -> PHFetchResult<PHAsset>
         */
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.includeAllBurstAssets = true
        
        // 这里直接挑选手机中连拍照片，然后获取他的identifier
        let burstIdentifier = "12E9222C-757A-4D89-AC52-8865FFD3D5CF"
        let assets = PHAsset.fetchAssets(withBurstIdentifier: burstIdentifier, options: fetchOptions)
        skipAssetListViewController(fetchResult: assets)
        ATLog("通过连拍标识符来获取一组连拍图片", funcName: type.rawValue)
    }
    
    func fetchAssetsWithOptions(type: PHAssetMethodType) {
        /*
         // 通过检索条件来获取资源
         // 默认情况下是拉取PHAssetSourceTypeUserLibrary中资源，你可以在PHFetchOptions中includeAssetSourceTypes修改拉取类别
         @available(iOS 8, *)
         open class func fetchAssets(with options: PHFetchOptions?) -> PHFetchResult<PHAsset>
         */
        
        // 检索条件：创建时间的倒叙
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let allAssets = PHAsset.fetchAssets(with: fetchOptions)
        skipAssetListViewController(fetchResult: allAssets)
        ATLog("通过检索条件来获取图片", funcName: type.rawValue)
    }
    
    func fetchAssetsWithMediaType(type: PHAssetMethodType) {
        /*
         // 通过媒体类别来获取资源
         @available(iOS 8, *)
         open class func fetchAssets(with mediaType: PHAssetMediaType, options: PHFetchOptions?) -> PHFetchResult<PHAsset>
         */
        
        // 获取视频类别的资源
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let vedioAssets = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        skipAssetListViewController(fetchResult: vedioAssets)
        ATLog("获取具体媒体类型的图片", funcName: type.rawValue)
    }
    
    // MARK: Others
    func skipAssetListViewController(fetchResult: PHFetchResult<PHAsset>) {
        let assetListViewController = AssetListViewController(fetchResult: fetchResult)
        self.navigationController?.pushViewController(assetListViewController, animated: true)
    }
}

private enum PHAssetPropertyType: String {
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

private enum PHAssetMethodType: String {
    case fetchAssetsInAssetCollection = "fetchAssets(in assetCollection: PHAssetCollection, options: PHFetchOptions?) -> PHFetchResult<PHAsset>"
    case fetchAssetsWithIdentifiers = "fetchAssets(withLocalIdentifiers identifiers: [String], options: PHFetchOptions?) -> PHFetchResult<PHAsset> "
    case fetchKeyAssetsInAssetCollection = "fetchKeyAssets(in assetCollection: PHAssetCollection, options: PHFetchOptions?) -> PHFetchResult<PHAsset>?"
    case fetchAssetsWithBurstIdentidier = "fetchAssets(withBurstIdentifier burstIdentifier: String, options: PHFetchOptions?) -> PHFetchResult<PHAsset>"
    case fetchAssetsWithOptions = "fetchAssets(with options: PHFetchOptions?) -> PHFetchResult<PHAsset"
    case fetchAssetsWithMediaType = "fetchAssets(with mediaType: PHAssetMediaType, options: PHFetchOptions?) -> PHFetchResult<PHAsset>"
}
