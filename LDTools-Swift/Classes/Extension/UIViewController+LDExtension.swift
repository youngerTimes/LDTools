//
//  UIViewController+LDExtension.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/2/4.
//

import Foundation
public extension UIViewController{
    /// 类名
    static var ld_identify:String{
        get{
            return "\(self)".components(separatedBy: ".").last ?? ""
        }
    }
    
    /// 类名
    var ld_identity:String{
        return "\(self.classForCoder)".components(separatedBy: ".").last ?? ""
    }


    /// 设置透明度
    /// - Parameter isAlpha: 
    func ld_setNavigationAlpha(isAlpha:Bool){
        if isAlpha {
            navigationController?.navigationBar.isHidden = false
            //设置导航栏背景透明
            navigationController?.navigationBar.setBackgroundImage(UIImage(),for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        }else {
            //重置导航栏背景
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        }
    }

    func ld_push(vc:UIViewController,animated:Bool = true){
        LD_currentNavigationController().pushViewController(vc, animated: animated)
    }
}
