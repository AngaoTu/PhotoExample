//
//  ViewController.swift
//  PhotoExample
//
//  Created by AngaoTu on 2021/7/20.
//

import UIKit
import Photos
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.requestAuthorization()
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
    
    private let dataList: [PhotoExampleType] = [.fetchResource, .changeObserver, .modifyResource]
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
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
        case .fetchResource:
            let fetchResourceViewController = FetchResourceViewController()
            self.navigationController?.pushViewController(fetchResourceViewController, animated: true)
        case .changeObserver:
            print("tqy: 点击了 changeObserver")
        case .modifyResource:
            print("tqy: fit modifyResource")
//        default:
//            break
        }
    }
}

private extension ViewController {
    func initView() {
        view.backgroundColor = .white
        self.title = "PhotoExample"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func requestAuthorization() {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { authorizationStatus in
                print("authorizationStatus: \(authorizationStatus.rawValue)")
            }
        }
    }
}

enum PhotoExampleType: String {
    case fetchResource = "获取资源"
    case changeObserver = "监听资源"
    case modifyResource = "修改资源"
}
