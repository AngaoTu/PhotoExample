//
//  FetchResourceViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/21.
//

import UIKit

class AssetRetrievalViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataList = [FetchResourceType.album, FetchResourceType.asset]
    }
    
    override func initView() {
        super.initView()
        self.title = "获取资源"
        tableView.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
    }
}

extension AssetRetrievalViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        cell.textString = (dataList[indexPath.row] as? FetchResourceType)?.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = dataList[indexPath.row] as? FetchResourceType else { return }
        switch type {
        case .album:
            let fetchAlbumViewController = FetchCollectionViewController()
            self.navigationController?.pushViewController(fetchAlbumViewController, animated: true)
        case .asset:
            let fetchAssetViewController = FetchAssetViewController()
            self.navigationController?.pushViewController(fetchAssetViewController, animated: true)
        }
    }
}

enum FetchResourceType: String {
    case album = "相册资源"
    case asset = "照片资源"
}
