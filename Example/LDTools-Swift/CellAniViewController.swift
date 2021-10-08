//
//  CellAniViewController.swift
//  LDTools-Swift_Example
//
//  Created by 无故事王国 on 2021/2/8.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class CellAniViewController: LD_BaseVC {

    var segmentedControl:UISegmentedControl?
    var item:Array<String>?
    var type:LD_TableAniType = .moveFromLeft

    var tableView = UITableView(frame: CGRect.zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        segmentedControl = UISegmentedControl(items: ["右左","左右","显影","显影1","大小","双向","填充"])
        segmentedControl?.addTarget(self, action: #selector(changeAction), for: .valueChanged)
        view.addSubview(segmentedControl!)
        segmentedControl?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(LD_NavBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        })

        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl!.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        self.item = ["1","2","3","4","5","6","7","8","9","10","11","11","11","11","11","11"]
        tableView.ld_addAni(type: type)
    }

    @objc func changeAction(sender:UISegmentedControl){


        switch sender.selectedSegmentIndex {
            case 0:
                type = .moveFromLeft
            case 1:
                type = .moveFromRight
            case 2:
                type = .fadeDut
            case 3:
                type = .fadeDut_move
            case 4:
                type = .bounds
            case 5:
                type = .bothway
            case 6:
                type = .fillOne
            default:break
        }
        tableView.ld_addAni(type: type)
    }
}

extension CellAniViewController:UITableViewDelegate{

}

extension CellAniViewController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "AnnimationTVC")
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "AnnimationTVC")

            let view = UIView()
            view.backgroundColor = UIColor.orange
            view.layer.cornerRadius = 5
            cell?.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
            }
        }

        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
