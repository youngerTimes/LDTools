//
//  NSObject+LDExtension.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/2/8.
//

import Foundation

public extension NSObject{

    /// 打印该类的所有属性
    func ld_mirror(){
        let hMirror  = Mirror(reflecting: self)
        print("==================\(hMirror.subjectType)======================")
        print("-->\(hMirror.subjectType)")
        for case let (label?,value) in hMirror.children {
            print("属性：\(label)     值：\(value)")
        }
        print("==================\(hMirror.subjectType)======================")
    }
}
