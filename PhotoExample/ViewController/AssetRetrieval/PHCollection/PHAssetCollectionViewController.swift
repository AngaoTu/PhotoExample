//
//  AssetCollectionViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/28.
//

import UIKit
import Photos

class PHAssetCollectionViewController: BaseTableViewController {
    // MARK: - initialization
    init(assetCollection: PHAssetCollection) {
        self.currentAssetCollection = assetCollection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.dataList = [[PHAssetCollectionPropertyType.assetCollectionType, PHAssetCollectionPropertyType.assetCollectionSubtype, PHAssetCollectionPropertyType.estimatedAssetCount, PHAssetCollectionPropertyType.startDate, PHAssetCollectionPropertyType.endDate, PHAssetCollectionPropertyType.approximatedLocation, PHAssetCollectionPropertyType.localizedLocationNames], [PHAssetCollectionMethodType.fetchAssetCollectionsWithIdentifier, PHAssetCollectionMethodType.fetchAssetCollectionsWithType, PHAssetCollectionMethodType.fetchAssetCollectionsContaining, PHAssetCollectionMethodType.fetchAssetCollectionsWithALAssetGroupURLs, PHAssetCollectionMethodType.transientAssetCollectionWithAssets, PHAssetCollectionMethodType.transientAssetCollectionWithAssetFetchResult]]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHAssetCollection模型"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
    }
    
    // MARK: - 私有属性
    private let currentAssetCollection: PHAssetCollection
}

extension PHAssetCollectionViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 100
        } else {
            return 44
        }
    }
    
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
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetCollectionPropertyType else { return UITableViewCell () }
            
            var textString = ""
            switch type {
            case .assetCollectionType:
                textString = assetCollectionType()
            case .assetCollectionSubtype:
                textString = assetCollectionSubtype()
            case .estimatedAssetCount:
                textString = estimatedAssetCount()
            case .startDate:
                textString = startDate()
            case .endDate:
                textString = endDate()
            case .approximatedLocation:
                textString = approximatedLocation()
            case .localizedLocationNames:
                textString = localizedLocationNames()
            }
            cell.textString = "\(type): \(textString)"
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetCollectionMethodType else { return UITableViewCell () }
            cell.textString = "\(type.rawValue)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHAssetCollectionMethodType else { return }
            switch type {
            case .fetchAssetCollectionsWithIdentifier:
                fetchAssetCollectionsWithIdentifier(type: type)
            case .fetchAssetCollectionsWithType:
                fetchAssetCollectionsWithType(type: type)
            case .fetchAssetCollectionsContaining:
                fetchAssetCollectionsContaining(type: type)
            case .fetchAssetCollectionsWithALAssetGroupURLs:
                fetchAssetCollectionsWithALAssetGroupURLs(type: type)
            case .transientAssetCollectionWithAssets:
                transientAssetCollectionWithAssets(type: type)
            case .transientAssetCollectionWithAssetFetchResult:
                transientAssetCollectionWithAssetFetchResult(type: type)
            }
        }
    }
}

// MARK: - Private Method
private extension PHAssetCollectionViewController {
    // MARK: Property
    func assetCollectionType() -> String {
        /*
         // 集合类型
         open var assetCollectionType: PHAssetCollectionType { get }
         
         public enum PHAssetCollectionType : Int {
             @available(iOS 8, *)
             case album = 1

             @available(iOS 8, *)
             case smartAlbum = 2
             
             @available(iOS, introduced: 8, deprecated: 13, message: "Will be removed in a future release")
             case moment = 3
         }
         */
        var typeString = ""
        switch currentAssetCollection.assetCollectionType {
        case .album:
            typeString = "album"
        case .smartAlbum:
            typeString = "smartAlbum"
        case .moment:
            typeString = "moment"
        default:
            break
        }
        return typeString
    }
    
    func assetCollectionSubtype() -> String {
        /*
         // 集合子类型
         open var assetCollectionSubtype: PHAssetCollectionSubtype { get }
         
         public enum PHAssetCollectionSubtype : Int {
             // PHAssetCollectionTypeAlbum regular subtypes
             case albumRegular = 2 // 用户自己在Photos app中建立的相册
             case albumSyncedEvent = 3 // 已废弃；使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步过来的事件。然而，在iTunes 12 以及iOS 9.0 beta4上，选用该类型没法获取同步的事件相册，而必须使用AlbumSyncedAlbum。
             case albumSyncedFaces = 4 // 使用 iTunes 从 Photos 照片库或者 iPhoto 照片库同步的人物相册。
             case albumSyncedAlbum = 5 // 从iPhoto同步到设备的相册
             case albumImported = 6 // 从相机或外部存储导入的相册
             
             // PHAssetCollectionTypeAlbum shared subtypes
             case albumMyPhotoStream = 100 // 用户的 iCloud 照片流
             case albumCloudShared = 101 // 用户使用iCloud共享的相册
             
             // PHAssetCollectionTypeSmartAlbum subtypes
             case smartAlbumGeneric = 200 // 非特殊类型的相册，从macOS Photos app同步过来的相册
             case smartAlbumPanoramas = 201 // 相机拍摄的全景照片
             case smartAlbumVideos = 202 // 相机拍摄的视频
             case smartAlbumFavorites = 203 // 收藏的照片、视频的相册
             case smartAlbumTimelapses = 204 // 延时视频的相册
             case smartAlbumAllHidden = 205 // 包含隐藏照片、视频的相册
             case smartAlbumRecentlyAdded = 206 // 相机近期拍摄的照片、视频的相册
             case smartAlbumBursts = 207 // 连拍模式拍摄的照片
             case smartAlbumSlomoVideos = 208 // Slomo是slow motion的缩写，高速摄影慢动作解析（iOS设备以120帧拍摄）的相册
             case smartAlbumUserLibrary = 209 // 相机相册，包含相机拍摄的所有照片、视频，使用其他应用保存的照片、视频
             case smartAlbumSelfPortraits = 210 // 包含了所有使用前置摄像头拍摄的资源的智能相册——自拍
             case smartAlbumScreenshots = 211 // 包含了所有使用屏幕截图的资源的智能相册——屏幕快照
             case smartAlbumDepthEffect = 212 // 包含了所有兼容设备上使用景深效果拍摄的资源的智能相册
             case smartAlbumLivePhotos = 213 // 包含了所有Live Photo的智能相册——Live Photo
             case smartAlbumAnimated = 214 // 动态图片gif
             case smartAlbumLongExposures = 215 // 所有开启长曝光的实况图片
             case smartAlbumUnableToUpload = 216

             // Used for fetching, if you don't care about the exact subtype
             @available(iOS 8, *)
             case any = 9223372036854775807 // 包含所有类型
         }
         */
        var typeString = ""
        switch currentAssetCollection.assetCollectionSubtype {
        case .albumRegular:
            typeString = "albumRegular"
        case .albumSyncedEvent:
            typeString = "albumSyncedEvent"
        case .albumSyncedFaces:
            typeString = "albumSyncedFaces"
        case .albumSyncedAlbum:
            typeString = "albumSyncedAlbum"
        case .albumImported:
            typeString = "albumImported"
        case .albumMyPhotoStream:
            typeString = "albumMyPhotoStream"
        case .albumCloudShared:
            typeString = "albumCloudShared"
        case .smartAlbumGeneric:
            typeString = "smartAlbumGeneric"
        case .smartAlbumPanoramas:
            typeString = "smartAlbumPanoramas"
        case .smartAlbumVideos:
            typeString = "smartAlbumVideos"
        case .smartAlbumFavorites:
            typeString = "smartAlbumFavorites"
        case .smartAlbumTimelapses:
            typeString = "smartAlbumTimelapses"
        case .smartAlbumAllHidden:
            typeString = "smartAlbumAllHidden"
        case .smartAlbumRecentlyAdded:
            typeString = "smartAlbumRecentlyAdded"
        case .smartAlbumBursts:
            typeString = "smartAlbumBursts"
        case .smartAlbumSlomoVideos:
            typeString = "smartAlbumSlomoVideos"
        case .smartAlbumUserLibrary:
            typeString = "smartAlbumUserLibrary"
        case .smartAlbumSelfPortraits:
            typeString = "smartAlbumSelfPortraits"
        case .smartAlbumScreenshots:
            typeString = "smartAlbumScreenshots"
        case .smartAlbumDepthEffect:
            typeString = "smartAlbumDepthEffect"
        case .smartAlbumLivePhotos:
            typeString = "smartAlbumLivePhotos"
        case .smartAlbumAnimated:
            typeString = "smartAlbumAnimated"
        case .smartAlbumLongExposures:
            typeString = "smartAlbumLongExposures"
        case .smartAlbumUnableToUpload:
            typeString = "smartAlbumUnableToUpload"
        case .any:
            typeString = "any"
        default:
            break
        }
        return typeString
    }
    
    func estimatedAssetCount() -> String {
        /*
         // These counts are just estimates; the actual count of objects returned from a fetch should be used if you care about accuracy. Returns NSNotFound if a count cannot be quickly returned.
         open var estimatedAssetCount: Int { get }
         */
        return "\(currentAssetCollection.estimatedAssetCount)"
    }
    
    func startDate() -> String {
        guard let creationDate = currentAssetCollection.startDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd号 HH:mm:ss"
        return formatter.string(from: creationDate)
    }
    
    func endDate() -> String {
        guard let creationDate = currentAssetCollection.endDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd号 HH:mm:ss"
        return formatter.string(from: creationDate)
    }
    
    func approximatedLocation() -> String {
        /*
         // 大概位置
         open var approximateLocation: CLLocation? { get }
         */
        guard let location = currentAssetCollection.approximateLocation?.coordinate else { return "" }
        return "altitude = \(location.latitude) coordinate = \(location.longitude)"
    }
    
    func localizedLocationNames() -> String {
        /*
         // 位置名称集合
         open var localizedLocationNames: [String] { get }
         */
        let array = currentAssetCollection.localizedLocationNames
        var locations = ""
        for item in array {
            locations += "\(item),"
        }
        return locations
    }
    
    // MARK: Method
    func fetchAssetCollectionsWithIdentifier(type: PHAssetCollectionMethodType) {
        /*
         // 通过PHAssetCollection的localIdentidier来检索PHAssetCollection
         @available(iOS 8, *)
         open class func fetchAssetCollections(withLocalIdentifiers identifiers: [String], options: PHFetchOptions?) -> PHFetchResult<PHAssetCollection>
         */
        
        // 先获取AssetCollection的loaclIdentider，然后再取获取PHAssetCollection
        // 由于这里没有现成的localIdentifier，所有采用这种比较绕的方式来获取
        let albumResults: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        var collectionIdentifiers: [String] = []
        albumResults.enumerateObjects { assetCollection, index, stop in
            collectionIdentifiers.append(assetCollection.localIdentifier)
        }
        
        let colletions = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: collectionIdentifiers, options: nil)
        colletions.enumerateObjects { collection, index, stop in
            ATLog("通过localIdentifiers来获取PHAssetCollection: \(collection)", funcName: type.rawValue)
        }
    }
    
    func fetchAssetCollectionsWithType(type: PHAssetCollectionMethodType) {
        /*
         // 通过PHAssetCollection的type和subType来获取PHAssetCollection
         // 如果想要获取该type下所有集合，subType设置为.any
         @available(iOS 8, *)
         open class func fetchAssetCollections(with type: PHAssetCollectionType, subtype: PHAssetCollectionSubtype, options: PHFetchOptions?) -> PHFetchResult<PHAssetCollection>
         */
        
        let albumResults = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        albumResults.enumerateObjects { assetCollection, index, stop in
            ATLog("通过PHAssetCollection的type和subType来获取PHAssetCollection: \(assetCollection)", funcName: type.rawValue)
        }
    }
    
    func fetchAssetCollectionsContaining(type: PHAssetCollectionMethodType) {
        /*
         // 通过PHAsset获取包含该资源的集合
         // 只支持Albums和Moments
         @available(iOS 8, *)
         open class func fetchAssetCollectionsContaining(_ asset: PHAsset, with type: PHAssetCollectionType, options: PHFetchOptions?) -> PHFetchResult<PHAssetCollection>
         */
        guard let asset = PHAsset.fetchAssets(with: .image, options: nil).lastObject else { return }
        let collections = PHAssetCollection.fetchAssetCollectionsContaining(asset, with: .smartAlbum, options: nil)
        collections.enumerateObjects { assetCollection, index, stop in
            ATLog("通过PHAsset获取包含该资源的集合: \(assetCollection)", funcName: type.rawValue)
        }
    }
    
    func fetchAssetCollectionsWithALAssetGroupURLs(type: PHAssetCollectionMethodType) {
        /*
         此处ALAsset是废弃的相册库，现在都是用PHAsset来代替它，故这里不进行讲解
         */
        ATLog("此处ALAsset是废弃的相册库，现在都是用PHAsset来代替它，故这里不进行讲解", funcName: type.rawValue)
    }
    
    func transientAssetCollectionWithAssets(type: PHAssetCollectionMethodType) {
        /*
         // 通过PHAsset集合生成临时的PHAssetCollection
         @available(iOS 8, *)
         open class func transientAssetCollection(with assets: [PHAsset], title: String?) -> PHAssetCollection
         */
        let assetsFetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        var assets: [PHAsset] = []
        assetsFetchResult.enumerateObjects { asset, index, stop in
            assets.append(asset)
        }
        
        let assetCollection = PHAssetCollection.transientAssetCollection(with: assets, title: "临时资源集合")
        ATLog("通过PHAsset集合生成临时的PHAssetCollection \(assetCollection)", funcName: type.rawValue)
    }
    
    func transientAssetCollectionWithAssetFetchResult(type: PHAssetCollectionMethodType) {
        /*
         // 通过PHFetchResult结果生成临时的PHAssetCollection
         @available(iOS 8, *)
         open class func transientAssetCollection(withAssetFetchResult fetchResult: PHFetchResult<PHAsset>, title: String?) -> PHAssetCollection
         */
        let assetsFetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        let assetCollection = PHAssetCollection.transientAssetCollection(withAssetFetchResult: assetsFetchResult, title: "临时资源集合")
        ATLog("通过PHAsset集合生成临时的PHAssetCollection \(assetCollection)", funcName: type.rawValue)
    }
}

private enum PHAssetCollectionPropertyType: String {
    case assetCollectionType
    case assetCollectionSubtype
    case estimatedAssetCount
    case startDate
    case endDate
    case approximatedLocation
    case localizedLocationNames
}

private enum PHAssetCollectionMethodType: String {
    case fetchAssetCollectionsWithIdentifier = "fetchAssetCollections(withLocalIdentifiers identifiers: [String], options: PHFetchOptions?) -> PHFetchResult<PHAssetCollection>"
    case fetchAssetCollectionsWithType = "fetchAssetCollections(with type: PHAssetCollectionType, subtype: PHAssetCollectionSubtype, options: PHFetchOptions?) -> PHFetchResult<PHAssetCollection>"
    case fetchAssetCollectionsContaining = "fetchAssetCollectionsContaining(_ asset: PHAsset, with type: PHAssetCollectionType, options: PHFetchOptions?) -> PHFetchResult<PHAssetCollection>"
    case fetchAssetCollectionsWithALAssetGroupURLs = "fetchAssetCollections(withALAssetGroupURLs assetGroupURLs: [URL], options: PHFetchOptions?) -> PHFetchResult<PHAssetCollection>"
    case transientAssetCollectionWithAssets = "transientAssetCollection(with assets: [PHAsset], title: String?) -> PHAssetCollection"
    case transientAssetCollectionWithAssetFetchResult = "transientAssetCollection(withAssetFetchResult fetchResult: PHFetchResult<PHAsset>, title: String?) -> PHAssetCollection"
}
