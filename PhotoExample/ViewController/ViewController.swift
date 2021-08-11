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
        self.dataList = [PhotoExampleType.fetchResource, PhotoExampleType.changeObserver, PhotoExampleType.modifyResource]
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
        case .fetchResource:
            let fetchResourceViewController = AssetRetrievalViewController()
            self.navigationController?.pushViewController(fetchResourceViewController, animated: true)
        case .changeObserver:
            print("tqy: 点击了 changeObserver")
        case .modifyResource:
            print("tqy: fit modifyResource")
//        default:
//            break
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
    case fetchResource = "获取资源"
    case changeObserver = "监听资源"
    case modifyResource = "修改资源"
}
