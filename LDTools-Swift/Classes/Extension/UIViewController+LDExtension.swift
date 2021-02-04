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
}
