//
//  PHAssetResourceCreationOptionsViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/12/19.
//

import Foundation
import UIKit

class PHAssetResourceCreationOptionsViewController: BaseTableViewController {
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [PHAssetResourceCreationOptions.originalFilename, PHAssetResourceCreationOptions.uniformTypeIdentifier, PHAssetResourceCreationOptions.shouldMoveFile]
    }
    
    override func initView() {
        super.initView()
        self.title = "PHAssetResourceCreationOptions模型"
    }
}

extension PHAssetResourceCreationOptionsViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        
        guard let type = dataList[indexPath.row] as? PHAssetResourceCreationOptions else { return UITableViewCell () }
        var textString = ""
        switch type {
        case .originalFilename:
            textString = originalFilename()
        case .uniformTypeIdentifier:
            textString = uniformTypeIdentifier()
        case .shouldMoveFile:
            textString = shouldMoveFile()
        }
        cell.textString = "\(type): \n\(textString)"
        return cell
    }
}

// MARK: - Private Method
private extension PHAssetResourceCreationOptionsViewController {
    // MARK: Property
    func originalFilename() -> String {
        /*
         @available(iOS 9, *)
         open var originalFilename: String?
         */
        return ""
    }
    
    func uniformTypeIdentifier() -> String {
        /*
         @available(iOS 9, *)
         open var uniformTypeIdentifier: String?
         */
        return ""
    }
    
    func shouldMoveFile() -> String {
        /*
         @available(iOS 9, *)
         open var shouldMoveFile: Bool
         */
        return ""
    }
}

private enum PHAssetResourceCreationOptions {
    case originalFilename
    case uniformTypeIdentifier
    case shouldMoveFile
}
