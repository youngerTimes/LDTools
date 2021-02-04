//
//  UIColor+LDExtension.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/2/4.
//

import Foundation

public extension UIColor{

    /// ColorHex 颜色值
    /// - Parameters:
    ///   - hexStr: 明亮模式颜色值
    ///   - darkStr: 暗黑系模式颜色值
    convenience init(hexStr:String,darkStr:String? = nil) {

        var tempStr = hexStr
        if darkStr != nil {
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark  {
                    tempStr = darkStr!
                }
            }
        }

        var cString:String = tempStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            self.init()
        } else {
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: 1)
        }
    }


    /// RGB颜色值
    /// - Parameters:
    ///   - lr: 明亮模式-红
    ///   - lg: 明亮模式-绿
    ///   - lb: 明亮模式-蓝
    ///   - dr: 暗黑模式-红
    ///   - dg: 暗黑模式-绿
    ///   - db: 暗黑模式-蓝
    ///   - alpha: 透明度
    convenience init(lr:CGFloat,lg:CGFloat,lb:CGFloat,dr:CGFloat? = nil,dg:CGFloat? = nil, db:CGFloat? = nil,alpha:CGFloat = 1.0) {

        var r:CGFloat = lr
        var g:CGFloat = lg
        var b:CGFloat = lb

        if dr != nil && dg != nil && db != nil {
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark  {
                    r = dr!
                    g = dg!
                    b = db!
                }
            }
        }

        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }

    ///使用rgb方式生成自定义颜色
    convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    ///使用rgba方式生成自定义颜色
    convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat, _ a : CGFloat) {

        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: a)
    }

    ///获取反色
    func ld_invertColor() -> UIColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: nil)
        return UIColor(red:1.0-r, green: 1.0-g, blue: 1.0-b, alpha: 1)
    }

}
