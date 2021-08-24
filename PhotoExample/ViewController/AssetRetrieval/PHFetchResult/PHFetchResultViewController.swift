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
                         [PHFetchResultFunctionType.object, PHFetchResultFunctionType.contains, PHFetchResultFunctionType.indexAnObject, PHFetchResultFunctionType.indexAnobjectInRange, PHFetchResultFunctionType.objects, PHFetchResultFunctionType.enumerateObjects, PHFetchResultFunctionType.enumerateObjectsOptions, PHFetchResultFunctionType.enumerateObjectsAt, PHFetchResultFunctionType.countOfAssets]]
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
                break
            default:
                break
            }
            cell.textString = "\(type): \(textString)"
        } else if indexPath.section == 1 {
            guard let array = dataList[indexPath.section] as? [Any], let type = array[indexPath.row] as? PHFetchResultFunctionType else { return UITableViewCell () }
            cell.textString = "\(type.rawValue)"
        }
        return cell
    }
}

private extension PHFetchResultViewController {
    func count() -> String {
        return ""
    }
    
    func firstObject() -> String {
        return ""
    }
    
    func lastObject() -> String {
        return ""
    }
}

private enum PHFetchResultPropertyType: String {
    case count
    case firstObject
    case lastObject
}

private enum PHFetchResultFunctionType: String {
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
