//
//  UIButton+LDExtension.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/2/4.
//

import Foundation


public extension UIButton{
    /// 设置GIF动态图
    /// - Parameters:
    ///   - name: 动态名称
    ///   - duration: 持续时间
    func ld_gif(name:String,duration:TimeInterval = 0.1){
        let gifImageUrl = Bundle.main.url(forResource: name, withExtension: nil)

        let gifSource = CGImageSourceCreateWithURL( gifImageUrl! as CFURL, nil)
        let gifcount = CGImageSourceGetCount(gifSource!)
        var images = [UIImage]()
        for i in 0..<gifcount{
            let imageRef = CGImageSourceCreateImageAtIndex(gifSource!, i, nil)
            let image = UIImage(cgImage: imageRef!)
            images.append(image)
        }
        setImage(UIImage.animatedImage(with: images, duration: duration), for: .normal)
    }

    /// 重新绘制按钮图像颜色
    func ld_tintColor(_ color:UIColor){
        let image = self.imageView?.image
        let tinImage = image?.qmui_image(withTintColor: color)
        setImage(tinImage, for: .normal)
    }
}
