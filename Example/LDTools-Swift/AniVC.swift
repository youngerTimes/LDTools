//
//  AniVC.swift
//  LDTools-Swift_Example
//
//  Created by 无故事王国 on 2021/2/9.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class AniVC: LD_BaseVC {




    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = UIImageView(image: UIImage(named: "heart"))
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(50)
            make.top.equalTo(90)
            make.width.height.equalTo(30)
        }

       let ani = LD_AnisTool.sizeAni(from: CGSize(width: 30, height: 30), to: CGSize(width: 50, height: 50), repeatCount: 100, duration: 0.4)
        imageView.layer.add(ani, forKey: nil)


        let btn = UIButton(type: .custom)
        btn.setTitle("点击", for: .normal)
        btn.setImage(UIImage(named: "heart"), for: .normal)
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.left.equalTo(50)
            make.top.equalTo(imageView.snp.bottom).offset(40)
            make.width.height.equalTo(30)
        }
    }

    @objc func btnAction(_ btn:UIButton){
        LD_AnisTool.scaleHuge(btn)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
}
