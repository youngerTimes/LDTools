//
//  RefreshTableViewController.swift
//  LDTools-Swift_Example
//
//  Created by 无故事王国 on 2021/2/8.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import LDTools_Swift

class RefreshTableViewController: LD_RefreshTVC{

    var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(LD_NavBarHeight)
            make.left.right.bottom.equalToSuperview()
        }

        ld_addReresh(tableView, footer: true)
    }

    override func ld_getData(isHeader: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.ld_endRefresh()
        }

        if isHeader{

        }else{

        }
    }
}

extension RefreshTableViewController:UITableViewDelegate{


}

extension RefreshTableViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if  cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        return cell!
    }
}
