//
//  GuideVC.swift
//  LDTools-Swift_Example
//
//  Created by 无故事王国 on 2021/2/9.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class GuideVC: LD_BaseVC {
    var guideVC:LDGuideVC?

    override func viewDidLoad() {
        super.viewDidLoad()

         guideVC = LDGuideVC([UIImage(named: "1")!,UIImage(named: "2")!,UIImage(named: "3")!],showPageControl: true)
        guideVC!.delegate = self
        guideVC!.loadAtWindow()
    }
}

extension GuideVC:LD_GuideDelegate{
    func currtentPage(page: Int, imgView: UIImageView) {
        print("---->\(page)")
    }

    func guideImagesView(imgView: [UIImageView]) {
        print("---->\(imgView)")
    }

    func browseComplete() {
        print("浏览完成")
        guideVC?.hiddenGuide()
    }
}
