//
//  LivePhotoViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/12/25.
//

import UIKit
import Photos

class LivePhotoViewController: BaseTableViewController {
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList = [LivePhotoType.PHLivePhoto, LivePhotoType.PHLivePhotoView]
    }
    
    override func initView() {
        super.initView()
        self.title = "LivePhoto"
    }
}

extension LivePhotoViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell,
              let type = dataList[indexPath.row] as? LivePhotoType else {
            return UITableViewCell()
        }
        cell.textString = type.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = dataList[indexPath.row] as? LivePhotoType else { return }
        switch type {
        case .PHLivePhoto:
            let livePhotoViewController = PHLivePhotoViewController()
            self.navigationController?.pushViewController(livePhotoViewController, animated: true)
        case .PHLivePhotoView:
            let livePhotoViewViewController = PHLivePhotoViewViewController()
            self.navigationController?.pushViewController(livePhotoViewViewController, animated: true)
        }
    }
}

private enum LivePhotoType: String {
    case PHLivePhoto
    case PHLivePhotoView
}
