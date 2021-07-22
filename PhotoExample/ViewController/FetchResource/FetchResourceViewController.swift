//
//  FetchResourceViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/21.
//

import UIKit

class FetchResourceViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    // MARK - 私有属性
    private lazy var tableView: UITableView = {
        let temp = UITableView()
        temp.delegate = self
        temp.dataSource = self
        temp.rowHeight = 44
        temp.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
        return temp
    }()
    
    private let dataList: [FetchResourceType] = [.album, .imageAsset, .videoAsset]
}

extension FetchResourceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTextTableViewCell", for: indexPath) as? SimpleTextTableViewCell else {
            return UITableViewCell()
        }
        cell.textString = dataList[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataList[indexPath.row] {
        case .album:
            let fetchAlbumViewController = FetchAlbumViewController()
            self.navigationController?.pushViewController(fetchAlbumViewController, animated: true)
        case .imageAsset:
            let fetchImageAssetViewController = FetchAssetViewController()
            self.navigationController?.pushViewController(fetchImageAssetViewController, animated: true)
        case .videoAsset:
            break
//        default:
//            break
        }
    }
}

private extension FetchResourceViewController {
    func initView() {
        view.backgroundColor = .white
        self.title = "获取资源"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

enum FetchResourceType: String {
    case album = "相册资源"
    case imageAsset = "图片资源"
    case videoAsset = "视频资源"
}
