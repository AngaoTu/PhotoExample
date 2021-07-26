//
//  FetchAlbumViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/21.
//

import UIKit
import Photos

class FetchAlbumViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    // MARK: - 私有属性
    private lazy var tableView: UITableView = {
        let temp = UITableView()
        temp.delegate = self
        temp.dataSource = self
        temp.rowHeight = 44
        temp.register(SimpleTextTableViewCell.self, forCellReuseIdentifier: "SimpleTextTableViewCell")
        return temp
    }()
    
    private let dataList: [FetchAlbumType] = [.album, .smartAlbum, .momentAlbum]
}

extension FetchAlbumViewController: UITableViewDelegate, UITableViewDataSource {
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
            fetchAlbum()
        case .smartAlbum:
            fetchSmartAlbum()
        case .momentAlbum:
            fetchMomentAlbum()
//        default:
//            break
        }
    }
}

private extension FetchAlbumViewController {
    func initView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func fetchAlbum() {
        let albumResults: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        skipAlbumListViewController(title: "我的相册", fetchResult: albumResults)
    }
    
    func fetchSmartAlbum() {
        let smartAlbumResults: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        skipAlbumListViewController(title: "智能相册", fetchResult: smartAlbumResults)
    }
    
    func fetchMomentAlbum() {
        let momentAlbumResults = PHAssetCollection.fetchAssetCollections(with: .moment, subtype: .any, options: nil)
        skipAlbumListViewController(title: "时刻相册", fetchResult: momentAlbumResults)
    }
    
    func skipAlbumListViewController(title: String, fetchResult: PHFetchResult<PHAssetCollection>) {
        let albumListViewController = AlbumListViewController(fetchResult: fetchResult)
        albumListViewController.title = title
        self.navigationController?.pushViewController(albumListViewController, animated: true)
    }
}

enum FetchAlbumType: String {
    case album = "相册"
    case smartAlbum = "智能相册"
    case momentAlbum = "时刻相册"
}

