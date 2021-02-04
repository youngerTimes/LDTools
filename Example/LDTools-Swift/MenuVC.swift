//
//  MenuVC.swift
//  LDTools-Swift_Example
//
//  Created by 无故事王国 on 2021/2/4.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import LDTools_Swift
import SnapKit


class MenuVC: LD_BaseVC {

    let btn  = UIButton(type: .system)
    var rightBtn:UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "下拉框"

        btn.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        btn.setTitle("下拉菜单", for: .normal)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(60 + LD_SafeEdges.top)
            make.height.equalTo(50)
        }

        rightBtn = UIBarButtonItem(title: "按钮", style: .plain, target: self, action: #selector(tap1Action))
        navigationItem.rightBarButtonItem = rightBtn
    }

    @objc func tapAction(){
        let menuView = LD_MenuView()
        menuView.show(self, tapView: btn, items: ["菜单","复制","转发"]) { (index, str) in

        }
    }

    @objc func tap1Action(){
        let menuView = LD_MenuView()
        menuView.show(self, tapView: nil, items:  ["菜单","复制","转发"]) { (index, str) in

        }
    }
}
