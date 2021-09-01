//
//  AssetLoadingViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/9/1.
//

import Foundation
import UIKit

class AssetLoadingViewContoller: BaseTableViewController {
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [AssetLoadingType.imageRequet, AssetLoadingType.livePhotoRequest, AssetLoadingType.videoRequest, AssetLoadingType.PHImageManager, AssetLoadingType.PHCachingImageManager]
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
        case .imageRequet:
            let imageRequestViewController = PHImageRequestOptionsViewController()
            self.navigationController?.pushViewController(imageRequestViewController, animated: true)
        default:
            break
        }
    }
}

private enum AssetLoadingType: String {
    case imageRequet
    case livePhotoRequest
    case videoRequest
    case PHImageManager
    case PHCachingImageManager
}
