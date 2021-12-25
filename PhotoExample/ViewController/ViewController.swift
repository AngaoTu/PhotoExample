//
//  ViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/20.
//

import UIKit
import Photos
import SnapKit

class ViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestAuthorization()
        self.dataList = [PhotoExampleType.photoLibary, PhotoExampleType.resourceChange, PhotoExampleType.resourceUpdateChange, PhotoExampleType.fetchResource, PhotoExampleType.loadAsset, PhotoExampleType.modifyResource, PhotoExampleType.assetResource, PhotoExampleType.livePhoto]
    }
    
    override func initView() {
        super.initView()
        self.title = "PhotoExample"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        cell.textString = (dataList[indexPath.row] as? PhotoExampleType)?.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = dataList[indexPath.row] as? PhotoExampleType else { return }
        switch type {
        case .photoLibary:
            let photoLibary = PHPhotoLibraryViewController()
            self.navigationController?.pushViewController(photoLibary, animated: true)
        case .resourceChange:
            let resouceChange = ObservingLibraryChangesViewController()
            self.navigationController?.pushViewController(resouceChange, animated: true)
        case .resourceUpdateChange:
            let updateLibrary = UpdateLibraryViewController()
            self.navigationController?.pushViewController(updateLibrary, animated: true)
        case .fetchResource:
            let fetchResourceViewController = AssetRetrievalViewController()
            self.navigationController?.pushViewController(fetchResourceViewController, animated: true)
        case .loadAsset:
            let assetLoadingViewControlelr = AssetLoadingViewContoller()
            self.navigationController?.pushViewController(assetLoadingViewControlelr, animated: true)
        case .modifyResource:
//            let modifyResourceViewController = ModifyResourceViewController()
//            self.navigationController?.pushViewController(modifyResourceViewController, animated: true)
            break
        case .assetResource:
            let assetResourceViewController = AssetResourceViewController()
            self.navigationController?.pushViewController(assetResourceViewController, animated: true)
        case .livePhoto:
            let livePhotoViewController = LivePhotoViewController()
            self.navigationController?.pushViewController(livePhotoViewController, animated: true)
        }
    }
}

private extension ViewController {
    func requestAuthorization() {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { authorizationStatus in
                print("authorizationStatus: \(authorizationStatus.rawValue)")
            }
        }
    }
}

enum PhotoExampleType: String {
    case photoLibary = "共享照片库"
    case resourceChange = "照片库资源变化"
    case resourceUpdateChange = "更新照片库资源"
    case fetchResource = "获取资源"
    case loadAsset = "加载资源"
    case modifyResource = "修改资源"
    case assetResource = "AssetResource资源管理"
    case livePhoto = "实况照片"
}
