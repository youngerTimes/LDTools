//
//  ProgressbarVC.swift
//  LDTools-Swift_Example
//
//  Created by 无故事王国 on 2021/2/8.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class ProgressbarVC: LD_BaseVC {

    var v1 = UIView()
    var v2 = UIView()
    var v3 = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let progessView = LDProgressView(corner: true, tintColor: UIColor.red.withAlphaComponent(0.6), animation: true, duration: 0.4)
        progessView.hintL.text = "普通"
        view.addSubview(progessView)
        progessView.snp.makeConstraints { (make) in
            make.top.equalTo(190)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(20)
        }
        progessView.progress = 1


        let progessView1 = LDProgressView(corner: true, animation: true, duration: 2.0, colors: [UIColor.green.withAlphaComponent(0.6).cgColor,UIColor.white.cgColor], pradientType: .LeftToRight)
        progessView1.hintL.text = "渐变：从左到右"
        view.addSubview(progessView1)
        progessView1.snp.makeConstraints { (make) in
            make.top.equalTo(progessView).offset(40)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(20)
        }
        progessView1.progress = 1


        let progessView2 = LDProgressView(corner: true, animation: true, duration: 5.0, colors: [UIColor.red.cgColor,UIColor.white.cgColor], pradientType: .TopToDown)
        progessView2.hintL.text = "渐变：从上到下"
        view.addSubview(progessView2)
        progessView2.snp.makeConstraints { (make) in
            make.top.equalTo(progessView1).offset(40)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(20)
        }
        progessView2.progress = 1


        let progressView3 = LD_OProgressView(lineWidth: 5, trackColor: UIColor.gray.withAlphaComponent(0.5), progressColor: UIColor.red)
        view.addSubview(progressView3)
        progressView3.snp.makeConstraints { (make) in
            make.top.equalTo(progessView2).offset(40)
            make.left.equalTo(20)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }


        view.addSubview(v1)
        view.addSubview(v2)
        view.addSubview(v3)

        v1.snp.makeConstraints { (make) in
            make.top.equalTo(progressView3.snp.bottom).offset(40)
            make.left.equalTo(20)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }

        v2.snp.makeConstraints { (make) in
            make.center.equalTo(v1)
            make.width.height.equalTo(80)
        }

        v3.snp.makeConstraints { (make) in
            make.center.equalTo(v1)
            make.width.height.equalTo(40)
        }


        DispatchQueue.main.asyncAfter(deadline: .now()+4) {
            progressView3.setProgress(60, animated: true, withDuration: 3.0)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        v1.ld_addCircle(circleWeight: 20, circleColor: UIColor.red, barBgColor: UIColor.white, percent: 1.0,duration: 1.5)
        v2.ld_addCircle(circleWeight: 20, circleColor: UIColor.blue, barBgColor: UIColor.white, percent: 1.0,duration: 2.0)
        v3.ld_addCircle(circleWeight: 20, circleColor: UIColor.yellow, barBgColor: UIColor.white, percent: 1.0,duration: 3.0)

    }
}
