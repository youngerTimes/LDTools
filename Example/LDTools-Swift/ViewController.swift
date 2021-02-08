//
//  ViewController.swift
//  LDTools-Swift
//
//  Created by 841720330@qq.com on 02/03/2021.
//  Copyright (c) 2021 841720330@qq.com. All rights reserved.
//

import UIKit
import SnapKit
import QMUIKit
import LDTools_Swift

class ItemsVC{
    var title = ""
    var VC:UIViewController.Type?

    convenience init(title:String,VC:UIViewController.Type) {
        self.init()
        self.title = title
        self.VC = VC
    }
}

class ViewController: UIViewController {
    private var shinkItem = [false,false,false,false]
    private var Keys = ["VC","View","Tool","Animation"]
    private var vCItems = [ItemsVC]()
    private var viewItems = [ItemsVC]()
    private var toolsItems = [ItemsVC]()
    private var animationItems = [ItemsVC]()


    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DEMO"
        tableView.delegate = self
        tableView.dataSource = self

        //VC
        vCItems.append(ItemsVC(title: "网页加载控制器", VC: LD_WebVC.self))
        vCItems.append(ItemsVC(title: "Base_下拉刷新，上拉加载", VC: RefreshTableViewController.self))

        viewItems.append(ItemsVC(title: "下拉菜单", VC: MenuVC.self))
        viewItems.append(ItemsVC(title: "二维码", VC: CreateQRVC.self))
        viewItems.append(ItemsVC(title: "滚动数字", VC: RollDigitVC.self))

        animationItems.append(ItemsVC(title: "进度条", VC: ProgressbarVC.self))
        animationItems.append(ItemsVC(title: "TableView-Cell动画", VC: CellAniViewController.self))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @objc func shinkAction(_ btn:UIButton){
        let index = btn.tag - 1100
        shinkItem[index] = !shinkItem[index]
        tableView.reloadData()

    }
}

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var itemsVC:UIViewController?

        switch indexPath.section {
            case 0:
                let item = vCItems[indexPath.row].VC!
                if let _ = item as? LD_WebVC.Type {
                    navigationController?.pushViewController(LD_WebVC(url: "https://www.hangge.com"), animated: true)
                }else{
                    let v = item.init()
                    navigationController?.pushViewController(v, animated: true)
                }

            case 1:
                let item = viewItems[indexPath.row].VC!
                let v = item.init()
                navigationController?.pushViewController(v, animated: true)

            case 2:
                let item = toolsItems[indexPath.row].VC!
                let v = item.init()
                navigationController?.pushViewController(v, animated: true)


            case 3:
                let item = animationItems[indexPath.row].VC!
                let v = item.init()
                navigationController?.pushViewController(v, animated: true)

            default:break
        }
    }
}

extension ViewController:UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.Keys.count
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35 * LD_RateW
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         var headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        if headView == nil{
            headView = UITableViewHeaderFooterView(reuseIdentifier: "header")
        }

        headView?.contentView.qmui_removeAllSubviews()

        let label = UILabel()
        label.text = Keys[section]
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        headView?.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }

        let btn = UIButton(type: .system)

        btn.addTarget(self, action: #selector(shinkAction(_:)), for: .touchUpInside)
        btn.tag = 1100 + section
        headView?.contentView.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }

        if shinkItem[section] {
            btn.setTitle("收回", for: .normal)
        }else{
            btn.setTitle("展开", for: .normal)
        }

        return headView!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shinkItem[section]  {
            switch section {
                case 0:return vCItems.count
                case 1:return viewItems.count
                case 2:return toolsItems.count
                case 3:return animationItems.count
                default:return 0
            }
        }else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }

        switch indexPath.section {
            case 0:cell?.textLabel?.text = vCItems[indexPath.row].title
            case 1:cell?.textLabel?.text = viewItems[indexPath.row].title
            case 2:cell?.textLabel?.text = toolsItems[indexPath.row].title
            case 3:cell?.textLabel?.text = animationItems[indexPath.row].title
            default:break
        }

        return cell!
    }
}
