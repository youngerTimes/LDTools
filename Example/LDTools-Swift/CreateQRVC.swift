//
//  CreateQRVC.swift
//  LDTools-Swift_Example
//
//  Created by 无故事王国 on 2021/2/8.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class CreateQRVC: LD_BaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "二维码生成"
        let image1 = UIImage.ld_generate(string: "www.baidu.com", descriptor: .qrCpde, size: CGSize(width: 200, height: 200))
        let image2 = UIImage.ld_generate(string: "www.baidu.com/123", descriptor: .qrCpde, size: CGSize(width: 200, height: 200), color: UIColor.red, level: .H)
        let image3 = UIImage.ld_fillImage(image2, UIImage(named: "WechatIMG"), CGSize(width: 60, height: 60))


        let img = UIImageView(image: image1)
        view.addSubview(img)
        img.snp.makeConstraints { (make) in
            make.top.equalTo(120)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }

        let img1 = UIImageView(image: image2)
        view.addSubview(img1)
        img1.snp.makeConstraints { (make) in
            make.top.equalTo(img.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }





        let img2 = UIImageView(image: image3)
        view.addSubview(img2)
        img2.snp.makeConstraints { (make) in
            make.top.equalTo(img1.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
    }
}
