//
//  UIImageView+LDExtension.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/2/8.
//

import Foundation
import SDWebImage

public extension UIImageView{

    func ld_load(url: String,opt:SDWebImageOptions? = nil, placeHolder: UIImage){
        if opt != nil {
            self.sd_setImage(with: URL(string: url), placeholderImage: placeHolder, options: opt!)
        }else{
            self.sd_setImage(with: URL(string: url), placeholderImage: placeHolder)
        }
    }

    /**
     Loads an image from a URL. If cached, the cached image is returned. Otherwise, a place holder is used until the image from web is returned by the closure.

     - Parameter url: The image URL.
     - Parameter placeholder: The placeholder image.
     - Parameter fadeIn: Weather the mage should fade in.
     - Parameter closure: Returns the image from the web the first time is fetched.

     - Returns A new image
     */
    func ld_imageFromURL(_ url: String, placeholder: UIImage = UIImage(), fadeIn: Bool = true, shouldCacheImage: Bool = true, closure: ((_ image: UIImage?) -> ())? = nil)
    {
        self.image = UIImage.image(fromURL: url, placeholder: placeholder, shouldCacheImage: shouldCacheImage) {
            (image: UIImage?) in
            if image == nil {
                return
            }
            self.image = image
            if fadeIn {
                let transition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                transition.type = CATransitionType.fade
                self.layer.add(transition, forKey: nil)
            }
            closure?(image)
        }
    }

    /// 加载LDTools中 Assets.xcassets中数据
    /// - Parameter name: 图片名称
    func ld_Bundle(_ name:String){
        let a = Bundle(for: LDTools.self)
        let image = UIImage(named: name, in: a, compatibleWith: .none)
        self.image = image
    }


    /// 加载GIF动态图
    func ld_showGIFWith(name:String,duration:Int){
        self.stopAnimating()
        let gifImageUrl = Bundle.main.url(forResource: name, withExtension: nil)

        let gifSource = CGImageSourceCreateWithURL( gifImageUrl! as CFURL, nil)
        let gifcount = CGImageSourceGetCount(gifSource!)
        var images = [UIImage]()
        for i in 0..<gifcount{
            let imageRef = CGImageSourceCreateImageAtIndex(gifSource!, i, nil)
            let image = UIImage(cgImage: imageRef!)
            images.append(image)
        }
        self.animationImages = images
        self.animationDuration = TimeInterval(duration)
        self.animationRepeatCount = 0
        self.contentMode = .scaleAspectFit
        self.startAnimating()
    }
}
