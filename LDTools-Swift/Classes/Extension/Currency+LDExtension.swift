//
//  Currency+LDExtension.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/2/8.
//

import Foundation
///金融货币相关

extension Double{
    public func ld_fuCoin(_ style:NumberFormatter.Style = .decimal,format:String = ",###.##")->String{
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        formatter.positiveFormat = format
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension Float{
    public func ld_fuCoin(_ style:NumberFormatter.Style = .decimal,format:String = ",###.##")->String{
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        formatter.positiveFormat = format
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}



extension Int{
    public func ld_fuCoin(_ style:NumberFormatter.Style = .decimal,format:String = ",###.##")->String{
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        formatter.positiveFormat = format
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
