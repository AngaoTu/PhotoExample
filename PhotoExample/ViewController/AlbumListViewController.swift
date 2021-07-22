//
//  AlbumListViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/21.
//

import UIKit
import Photos

class AlbumListViewController: UIViewController {
    // MARK: - initialization
    init(fetchResult: PHFetchResult<PHAssetCollection>) {
        super.init(nibName: nil, bundle: nil)
        self.dataList = fetchResult
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -  生命周期
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
        temp.register(AlbumListTableViewCell.self, forCellReuseIdentifier: "AlbumListTableViewCell")
        return temp
    }()
    
    private var dataList: PHFetchResult<PHAssetCollection>?
}

extension AlbumListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = dataList?.count else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumListTableViewCell", for: indexPath) as? AlbumListTableViewCell else {
            return UITableViewCell()
        }
        guard let albumTitle = dataList?[indexPath.row].localizedTitle else {
            return UITableViewCell()
        }
        cell.textString = albumTitle
        return cell
    }
}

private extension AlbumListViewController {
    func initView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
