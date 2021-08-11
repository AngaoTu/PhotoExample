//
//  AlbumListViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/21.
//

import UIKit
import Photos

class AlbumListViewController: BaseTableViewController {
    // MARK: - initialization
    init(fetchResult: PHFetchResult<PHAssetCollection>) {
        super.init(nibName: nil, bundle: nil)
        self.fetchResult = fetchResult
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -  生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initView() {
        super.initView()
        tableView.register(AlbumListTableViewCell.self, forCellReuseIdentifier: "AlbumListTableViewCell")
    }
    
    // MARK: - 私有属性
    private var fetchResult: PHFetchResult<PHAssetCollection>?
}

extension AlbumListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = fetchResult?.count else {
            return 0
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumListTableViewCell", for: indexPath) as? AlbumListTableViewCell else {
            return UITableViewCell()
        }
        guard let albumTitle = fetchResult?[indexPath.row].localizedTitle else {
            return UITableViewCell()
        }
        cell.textString = albumTitle
        return cell
    }
}
