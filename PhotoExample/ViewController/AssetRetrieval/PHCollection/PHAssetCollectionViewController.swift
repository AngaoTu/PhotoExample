//
//  AssetCollectionViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/28.
//

import UIKit
import Photos

class PHAssetCollectionViewController: UIViewController {
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
    
    private let dataList: [PHAssetCollectionPropertyType] = [.canContainAssets, .canContainCollection, .localizedTitle, .assetCollectionType, .assetCollectionSubtype, .estimatedAssetCount, .startDate, .endDate, .approximatedLocation, .localizedLocationNames]
    
    private let currentAssetCollection: PHAssetCollection
}

extension PHAssetCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        var textString = ""
        switch dataList[indexPath.row] {
        case .canContainAssets:
            textString = canContainAssets()
        case .canContainCollection:
            textString = canContainCollection()
        case .localizedTitle:
            textString = localizedTitle()
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
        cell.textString = "\(dataList[indexPath.row].rawValue): \(textString)"
        return cell
    }
}

private extension PHAssetCollectionViewController {
    func initView() {
        view.backgroundColor = .white
        self.title = "获取资源"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func canContainAssets() -> String {
        /*
         // 能否包含Assets
         open var canContainAssets: Bool { get }
         */
        return currentAssetCollection.canContainAssets ? "ture" : "false"
    }
    
    func canContainCollection() -> String {
        /*
         // 能否包含集合
         open var canContainCollections: Bool { get }
         */
        return currentAssetCollection.canContainCollections ? "true" : "false"
    }
    
    func localizedTitle() -> String {
        /*
         // 标题
         open var localizedTitle: String? { get }
         */
        return currentAssetCollection.localizedTitle ?? ""
    }
    
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
}

private enum PHAssetCollectionPropertyType: String {
    // 继承于PHCollection属性
    case canContainAssets
    case canContainCollection
    case localizedTitle
    // PHAssetCollection属性
    case assetCollectionType
    case assetCollectionSubtype
    case estimatedAssetCount
    case startDate
    case endDate
    case approximatedLocation
    case localizedLocationNames
}


