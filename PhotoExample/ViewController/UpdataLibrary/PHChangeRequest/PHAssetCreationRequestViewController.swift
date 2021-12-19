//
//  PHAssetCreationRequestViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/12/19.
//

import Foundation
import UIKit

class PHAssetCreationRequestViewController: BaseTableViewController {
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [PHAssetCreationRequestMethodType.forAsset, PHAssetCreationRequestMethodType.supportsAssetResourceTypes, PHAssetCreationRequestMethodType.addResourceWithData, PHAssetCreationRequestMethodType.addResourceWithFile]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHAssetCreationRequest模型"
    }
}

extension PHAssetCreationRequestViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        guard let type = dataList[indexPath.row] as? PHAssetCreationRequestMethodType else { return UITableViewCell () }
        cell.textString = "\(type.rawValue)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let type = dataList[indexPath.row] as? PHAssetCreationRequestMethodType else { return }
            switch type {
            case .forAsset:
                forAsset(type: type)
            case .supportsAssetResourceTypes:
                supportsAssetResourceTypes(type: type)
            case .addResourceWithData:
                addResourceWithData(type: type)
            case .addResourceWithFile:
                addResourceWithFile(type: type)
            }
        }
    }
}

// MARK: - Private Method
private extension PHAssetCreationRequestViewController {
    // MARK: Method
    func forAsset(type: PHAssetCreationRequestMethodType) {
        
    }
    
    func supportsAssetResourceTypes(type: PHAssetCreationRequestMethodType) {
        
    }
    
    func addResourceWithData(type: PHAssetCreationRequestMethodType) {
        
    }
    
    func addResourceWithFile(type: PHAssetCreationRequestMethodType) {
        
    }
}

private enum PHAssetCreationRequestMethodType: String {
    case forAsset = "forAsset() -> Self"
    case supportsAssetResourceTypes = "supportsAssetResourceTypes(_ types: [NSNumber]) -> Bool"
    case addResourceWithData = "addResource(with type: PHAssetResourceType, fileURL: URL, options: PHAssetResourceCreationOptions?)"
    case addResourceWithFile = "addResource(with type: PHAssetResourceType, data: Data, options: PHAssetResourceCreationOptions?)"
}
