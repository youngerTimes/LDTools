//
//  NSLayoutConstraint+LDExtension.swift
//  SwiftFrame
//
//  Created by 无故事王国 on 2021/2/2.
//

import Foundation

public extension NSLayoutConstraint {

    /// 重写constant,适配xib 设置的宽高时，重置比例，无需关心此方法
    override func awakeFromNib() {
        super.awakeFromNib()
        self.constant = self.constant * LD_RateW
    }
}

