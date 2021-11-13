//
//  ResourceChangeViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/11/13.
//

import Foundation
import UIKit
import Photos

class ResourceChangeViewController: BaseTableViewController {
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [ResourceChangeType.phChange, ResourceChangeType.phObjectChangeDetails, ResourceChangeType.phFetchResultChangeDetails]
    }
    
    override func initView() {
        super.initView()
        self.title = "照片库资源变化"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
    }
}

extension ResourceChangeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        cell.textString = (dataList[indexPath.row] as? ResourceChangeType)?.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = dataList[indexPath.row] as? ResourceChangeType else { return }
        switch type {
        case .phChange:
            let phChange = PHChangeViewController()
            self.navigationController?.pushViewController(phChange, animated: true)
        case .phObjectChangeDetails:
            let phObject = PHObjectChangeDetailsViewController()
            self.navigationController?.pushViewController(phObject, animated: true)
        case .phFetchResultChangeDetails:
            let phFetchReuslt = PHFetchResultChangeDetailsViewController()
            self.navigationController?.pushViewController(phFetchReuslt, animated: true)
        }
    }
}

private enum ResourceChangeType: String {
    case phChange = "PHChange模型"
    case phObjectChangeDetails = "PHObjectChangeDetails模型"
    case phFetchResultChangeDetails = "PHFetchResultChangeDetails模型"
}
