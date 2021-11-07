//
//  PHFetchResultViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/8/24.
//

import Photos
import UIKit

class PHFetchResultViewController: BaseTableViewController {
    // MARK: - initialization
    init(fetchResult: PHFetchResult<PHAsset>) {
        self.fetchResult = fetchResult
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataList = [[PHFetchResultPropertyType.count, PHFetchResultPropertyType.firstObject, PHFetchResultPropertyType.lastObject],
                         [PHFetchResultMethodType.object, PHFetchResultMethodType.contains, PHFetchResultMethodType.indexAnObject, PHFetchResultMethodType.indexAnobjectInRange, PHFetchResultMethodType.objects, PHFetchResultMethodType.enumerateObjects, PHFetchResultMethodType.enumerateObjectsOptions, PHFetchResultMethodType.enumerateObjectsAt, PHFetchResultMethodType.countOfAssets]]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHFetchResult模型"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
        tableView.rowHeight = 80
    }
    
    // MARK: - 私有属性
    private let fetchResult: PHFetchResult<PHAsset>
}

extension PHFetchResultViewController {
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
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHFetchResultPropertyType else { return UITableViewCell () }
            var textString = ""
            switch type {
            case .count:
                textString = count()
            default:
                break
            }
            cell.textString = "\(type): \(textString)"
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHFetchResultMethodType else { return UITableViewCell () }
            cell.textString = "\(type.rawValue)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHFetchResultPropertyType else { return }
            switch type {
            case .firstObject:
                firstObject()
            case .lastObject:
                lastObject()
            default:
                break
            }
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHFetchResultMethodType else { return }
            switch type {
            case .object:
                object(type: type)
            case .contains:
                contains(type: type)
            case .indexAnObject:
                indexAnObject(type: type)
            case .indexAnobjectInRange:
                indexAnobjectInRange(type: type)
            case .objects:
                objects(type: type)
            case .enumerateObjects:
                enumerateObjects(type: type)
            case .enumerateObjectsOptions:
                enumerateObjectsOptions(type: type)
            case .enumerateObjectsAt:
                enumerateObjectsAt(type: type)
            case .countOfAssets:
                countOfAssets(type: type)
            }
        }
    }
}

// MARK: - Private Method
private extension PHFetchResultViewController {
    // MARK: Propries
    func count() -> String {
        /*
         @available(iOS 8, *)
         open var count: Int { get }
         */
        return String(fetchResult.count)
    }
    
    func firstObject() {
        /*
         @available(iOS 8, *)
         open var firstObject: ObjectType? { get }
         */
        let object = fetchResult.firstObject
        ATLog("\(String(describing: object))")
    }
    
    func lastObject() {
        /*
         @available(iOS 8, *)
         open var lastObject: ObjectType? { get }
         */
        let object = fetchResult.lastObject
        ATLog("\(String(describing: object))")
    }
    
    // MARK: Methods
    func object(type: PHFetchResultMethodType) {
        /*
         @available(iOS 8, *)
         open func object(at index: Int) -> ObjectType // 获取第几个元素 超出该相册数量范围，则直接崩溃
         */
        // 这里需要对范围进行预判
        let object = fetchResult.object(at: 1)
        ATLog("\(object)", funcName: type.rawValue)
    }
    
    func contains(type: PHFetchResultMethodType) {
        /*
         @available(iOS 8, *)
         open func contains(_ anObject: ObjectType) -> Bool // 判断是否包含某个元素
         */
        // 先获取下标位1的元素，然后再进行判断
        let object = fetchResult.object(at: 1)
        let isHas = fetchResult.contains(object)
        ATLog("\(isHas)", funcName: type.rawValue)
    }
    
    func indexAnObject(type: PHFetchResultMethodType) {
        /*
         @available(iOS 8, *)
         open func index(of anObject: ObjectType) -> Int // 返回某个元素下标
         */
        let object = fetchResult.object(at: 1)
        let index = fetchResult.index(of: object)
        ATLog("\(index)", funcName: type.rawValue)
    }
    
    func indexAnobjectInRange(type: PHFetchResultMethodType) {
        /*
         @available(iOS 8, *)
         open func index(of anObject: ObjectType, in range: NSRange) -> Int // 在某个范围中，返回某个元素下标
         */
        // 如果不在范围中，返回值为超大数值  9223372036854775807
        // 在范围中，则返回范围值。所以在使用该方法需要对返回值进行判断
        let object = fetchResult.object(at: 1)
        let index = fetchResult.index(of: object, in: NSMakeRange(2, 2))
        ATLog("\(index)", funcName: type.rawValue)
    }
    
    func objects(type: PHFetchResultMethodType) {
        /*
         @available(iOS 8, *)
         open func objects(at indexes: IndexSet) -> [ObjectType] //
         */
        // 如果set中有不在范围中index，会直接抛出异常
        let objects = fetchResult.objects(at: [1, 2])
        ATLog("\(objects)", funcName: type.rawValue)
    }
    
    func enumerateObjects(type: PHFetchResultMethodType) {
        /*
         @available(iOS 8, *)
         open func enumerateObjects(_ block: @escaping (ObjectType, Int, UnsafeMutablePointer<ObjCBool>) -> Void)
         */
        fetchResult.enumerateObjects { asset, index, stop in
            if index == 2 {
                stop.initialize(to: true)
            }
            ATLog("\(asset)", funcName: type.rawValue)
        }
    }
    
    func enumerateObjectsOptions(type: PHFetchResultMethodType) {
        /*
         @available(iOS 8, *)
         open func enumerateObjects(options opts: NSEnumerationOptions = [], using block: @escaping (ObjectType, Int, UnsafeMutablePointer<ObjCBool>) -> Void)
         
         
         public struct NSEnumerationOptions : OptionSet {
             public init(rawValue: UInt)
             
             public static var concurrent: NSEnumerationOptions { get } // 并行遍历

             public static var reverse: NSEnumerationOptions { get } // 倒叙遍历
         }
         */
        fetchResult.enumerateObjects(options: .concurrent) { asset, index, stop in
            if index == 2 {
                stop.initialize(to: true)
            }
            ATLog("index = \(index) \(asset)", funcName: type.rawValue)
        }
    }
    
    func enumerateObjectsAt(type: PHFetchResultMethodType) {
        /*
         @available(iOS 8, *)
         open func enumerateObjects(at s: IndexSet, options opts: NSEnumerationOptions = [], using block: @escaping (ObjectType, Int, UnsafeMutablePointer<ObjCBool>) -> Void)
         */
        fetchResult.enumerateObjects(at: [1, 2, 5, 6], options: .concurrent) { asset, index, stop in
            if index == 2 {
                stop.initialize(to: true)
            }
            ATLog("\(asset)", funcName: type.rawValue)
        }
    }
    
    func countOfAssets(type: PHFetchResultMethodType) {
        /*
         @available(iOS 8, *)
         open func countOfAssets(with mediaType: PHAssetMediaType) -> Int // 获取mediaType类型有多少元素
         */
        let count = fetchResult.countOfAssets(with: .video)
        ATLog("\(count)", funcName: type.rawValue)
    }
}

private enum PHFetchResultPropertyType: String {
    case count
    case firstObject
    case lastObject
}

private enum PHFetchResultMethodType: String {
    case object = "object(at index: Int) -> ObjectType"
    case contains = "contains(_ anObject: ObjectType) -> Bool"
    case indexAnObject = "index(of anObject: ObjectType) -> Int"
    case indexAnobjectInRange = "index(of anObject: ObjectType, in range: NSRange) -> Int"
    case objects = "objects(at indexes: IndexSet) -> [ObjectType]"
    case enumerateObjects = "enumerateObjects(_ block: @escaping (ObjectType, Int, UnsafeMutablePointer<ObjCBool>) -> Void)"
    case enumerateObjectsOptions = "enumerateObjects(options opts: NSEnumerationOptions = [], using block: @escaping (ObjectType, Int, UnsafeMutablePointer<ObjCBool>) -> Void)"
    case enumerateObjectsAt = "enumerateObjects(at s: IndexSet, options opts: NSEnumerationOptions = [], using block: @escaping (ObjectType, Int, UnsafeMutablePointer<ObjCBool>) -> Void)"
    case countOfAssets = "countOfAssets(with mediaType: PHAssetMediaType) -> Int"
}
