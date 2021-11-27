//
//  ModifyResourceViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/21.
//

import UIKit
import Photos

class ModifyResourceViewController: BaseTableViewController {
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [ModifyResourceType.PHChangeRequest]
    }
    
    override func initView() {
        super.initView()
        self.title = "资源的编辑"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
    }
}

extension ModifyResourceViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell,
              let type = dataList[indexPath.row] as? ModifyResourceType else {
            return UITableViewCell()
        }
        cell.textString = type.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = dataList[indexPath.row] as? ModifyResourceType else { return }
        switch type {
        case .PHChangeRequest:
            let phassetChangeRequestViewController = PHAssetChangeRequestViewController()
            self.navigationController?.pushViewController(phassetChangeRequestViewController, animated: true)
        }
    }
}

private enum ModifyResourceType: String {
    case PHChangeRequest
}
