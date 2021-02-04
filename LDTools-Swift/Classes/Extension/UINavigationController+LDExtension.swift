//
//  UINavigationController+LDExtension.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/2/4.
//

import UIKit

public extension UINavigationController{

    /// present 视图，采用Push动画
    func ld_presentPush(vc:UIViewController){
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromRight
        UIApplication.shared.keyWindow?.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: false, completion: nil)
    }

    /// dismiss 视图，采用Push动画
    func ld_dismissPop(){
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = .fromLeft
        UIApplication.shared.keyWindow?.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
}
