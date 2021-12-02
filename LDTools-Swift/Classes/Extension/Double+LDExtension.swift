//
//  Double+LDExtension.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/3/4.
//

import Foundation
import UIKit

public extension Double{

    /// 角度转换：弧度转角度
    var ld_degrees:Double{
        get{return self * (180.0 / .pi)}
    }

    /// 角度转换：角度转弧度
    var ld_radians:Double{
        get{return self / 180.0 * .pi}
    }

    /// 四舍五入
    /// - Parameter places: 小数位 位数
    func ld_roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }


    /// 截断
    /// - Parameter places: 截断小数位 位数
    func ld_truncate(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Double(Int(self * divisor)) / divisor
    }


    func ld_mm()->String{return "\(self/1)mm"}
    func ld_cm()-> String{return "\(self/10)cm"}
    func ld_dm()->String{return "\(self/100)dm"}
    func ld_m()->String{return "\(self/1000)m"}
    func ld_km()->String{return "\(self/(1000*1000))km"}
    func ld_unit()->String{
        if self > 0 && self < 1000{
            if String(format: "%.2lf", self).contains(".00"){
                return String(format: "%ld", Int(self))
            }else{
                return String(format: "%.2lf", self)
            }
        }else if self >= 1000 && self < 10000 {
            if String(format: "%.2lfK", self/1000.0).contains(".00") {
                return String(format: "%ldK", Int(self/1000.0))
            }else{
                return String(format: "%.2lfK", self/1000.0)
            }
        }else if self >= 10000{
            if String(format: "%.2lfW", self/10000.0).contains(".00") {
                return String(format: "%ldW", Int(self/10000.0))
            }else{
                return String(format: "%.2lfW", self/10000.0)
            }
        }else{
            return "0"
        }
    }

    //Cell平均分配宽度：避免小缝隙
    func avgWidth(displayWidth:CGFloat,col:Int,space:CGFloat,indexPath:IndexPath)->CGSize{
        var pxWidth = displayWidth * UIScreen.main.scale
        pxWidth = pxWidth - space * CGFloat((col))
        let mo = Int(pxWidth) % col
        if mo != 0{
            let fixPxWidth = pxWidth - CGFloat(mo)
            var itemWidth = fixPxWidth / CGFloat(col)
            let itemHeight  = itemWidth - 1.0
            if indexPath.row % col < mo{
                itemWidth = itemWidth - 1.0
            }

            let w = itemWidth / UIScreen.main.scale
            let h = itemHeight / UIScreen.main.scale
            return CGSize(width: w, height: h)
        }else{
            let itemWidth = pxWidth / CGFloat(col)
            let w = itemWidth / UIScreen.main.scale
            return CGSize(width: w, height: w)
        }
    }

    @available(*,deprecated,message: "废弃")
    var ld_ratioW:CGFloat{
        return CGFloat(self) * LD_RateW
    }

    /// 进行格式化
    var ld_formatFloat:String{
        if fmodf(Float(self), 1) == 0 {
            return String(format: "%.0f", self)
        }else if fmodf(Float(self) * 10, 1) == 0{
            return String(format: "%.1f", self)
        }else{
            return String(format: "%.2f", self)
        }
    }
}

public extension CGFloat{

    /// 进行格式化
    var ld_formatFloat:String{
        if fmodf(Float(self), 1) == 0 {
            return String(format: "%.0f", self)
        }else if fmodf(Float(self) * 10, 1) == 0{
            return String(format: "%.1f", self)
        }else{
            return String(format: "%.2f", self)
        }
    }

    /// 角度转换：弧度转角度
    var ld_degrees:CGFloat{
        get{return self * (180.0 / .pi)}
    }

    /// 角度转换：角度转弧度
    var ld_radians:CGFloat{
        get{return self / 180.0 * .pi}
    }

    /// 截断
    /// - Parameter places: 截断小数位 位数
    func ld_truncate(places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return CGFloat(Int(self * divisor)) / CGFloat(divisor)
    }

    /// 四舍五入
    /// - Parameter places: 小数位 位数
    func ld_roundTo(places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return CGFloat((self * divisor).rounded() / divisor)
    }

    func ld_mm()->String{return "\(self/1)mm"}
    func ld_cm()-> String{return "\(self/10)cm"}
    func ld_dm()->String{return "\(self/100)dm"}
    func ld_m()->String{return "\(self/1000)m"}
    func ld_km()->String{return "\(self/(1000*1000))km"}

    @available(*,deprecated,message: "废弃")
    var ld_ratioW:CGFloat{
        return self * LD_RateW
    }
}
