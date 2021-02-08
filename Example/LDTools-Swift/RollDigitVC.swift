//
//  RollDigitVC.swift
//  LDTools-Swift_Example
//
//  Created by 无故事王国 on 2021/2/8.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class RollDigitVC: LD_BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        let roll = LDRollDigitLabel(defaultNumber: 100,length: 3, animated: true)
        roll.font = UIFont.systemFont(ofSize: 59, weight: .bold)
        roll.number = 213
        roll.show()
        view.addSubview(roll)

        roll.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.left.equalTo(50)
            make.width.equalTo(roll.frame.width)
            make.height.equalTo(roll.frame.height)
        }


        let roll2 = LD_RollNumberLabel(NSNumber(floatLiteral: 0),financeType: true)
        roll2.font = UIFont.systemFont(ofSize: 59, weight: .bold)
        roll2.textColor = UIColor.red
        view.addSubview(roll2)
        roll2.snp.makeConstraints { (make) in
            make.top.equalTo(roll.snp.bottom).offset(10)
            make.left.equalTo(50)
            make.height.equalTo(roll.frame.height)
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            roll2.valueNumber = NSNumber(floatLiteral: 11201)
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            roll2.valueNumber = NSNumber(floatLiteral: 21201)
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
            roll2.valueNumber = NSNumber(floatLiteral: 41903)
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
            roll2.valueNumber = NSNumber(floatLiteral: 40905)
        }
    }
}
