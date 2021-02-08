//
//  UIImage+LDExtension.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/2/8.
//

import Foundation
import Photos
import CoreGraphics

/// 水印位置枚举
public enum WaterMarkCorner{
    case TopLeft
    case TopRight
    case BottomLeft
    case BottomRight
}

public enum CodeDescriptor: String {
    case qrCpde = "CIQRCodeGenerator"
    //只能识别 ascii characters
    case code128Barcod = "CICode128BarcodeGenerator"
    //显示中文会乱码
    case pdf417 = "CIPDF417BarcodeGenerator"
    //显示中文会乱码
    case aztec = "CIAztecCodeGenerator"
}

enum CodeKey:String{
    ///设置内容
    case inputMessage = "inputMessage"
    ///设置容错级别
    case inputCorrectionLevel = "inputCorrectionLevel"
}

///  容错级别

/*

 qrCpde 和 pdf417

 inputCorrectionLevel 是一个单字母（@"L", @"M", @"Q", @"H" 中的一个），表示不同级别的容错率，默认为 @"M"

 QR码有容错能力，QR码图形如果有破损，仍然可以被机器读取内容，最高可以到7%~30%面积破损仍可被读取

 相对而言，容错率愈高，QR码图形面积愈大。所以一般折衷使用15%容错能力。错误修正容量 L水平 7%的字码可被修正

 M水平 15%的字码可被修正

 Q水平 25%的字码可被修正

 H水平 30%的字码可被修正

 code128Barcod 不能设置inputCorrectionLevel属性

 aztec inputCorrectionLevel 5 - 95

 */

public enum CorrectionLevel{
    case L
    case M
    case Q
    case H
    case aztecLevel(_ value:Int)
    var  levelValue:String{
        switch self {
            case .L:
                return "L"
            case .M:
                return "M"
            case .Q:
                return "Q"
            case .H:
                return "H"
            default:return  "" }
    }
}


public extension UIImage{

    /// PHAsset转UIImage
    @objc static func JQ_PHAssetToImage(asset:PHAsset) -> UIImage{
        var image = UIImage()

        // 新建一个默认类型的图像管理器imageManager
        let imageManager = PHImageManager.default()

        // 新建一个PHImageRequestOptions对象
        let imageRequestOption = PHImageRequestOptions()

        // PHImageRequestOptions是否有效
        imageRequestOption.isSynchronous = true

        // 缩略图的压缩模式设置为无
        imageRequestOption.resizeMode = .none

        // 缩略图的质量为高质量，不管加载时间花多少
        imageRequestOption.deliveryMode = .highQualityFormat

        // 按照PHImageRequestOptions指定的规则取出图片
        imageManager.requestImage(for: asset, targetSize: CGSize.init(width: 1080, height: 1920), contentMode: .aspectFill, options: imageRequestOption, resultHandler: {
            (result, _) -> Void in
            image = result!
        })
        return image
    }

    // MARK: 1.4、layer 转 image
    /// layer 转 image
    /// - Parameters:
    ///   - layer: layer 对象
    ///   - scale: 缩放比例
    /// - Returns: 返回转化后的 image
    static func jq_image(from layer: CALayer, scale: CGFloat = 0.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }

    // MARK: -- Instance

    /// 生成一张高斯模糊图
    func jq_blur(_ value:CGFloat)->UIImage{
        let context = CIContext(options: nil)
        let inputImage =  CIImage(image: self)
        //使用高斯模糊滤镜
        let filter = CIFilter(name: "CIGaussianBlur")!
        filter.setValue(inputImage, forKey:kCIInputImageKey)
        //设置模糊半径值（越大越模糊）
        filter.setValue(value, forKey: kCIInputRadiusKey)
        let outputCIImage = filter.outputImage!
        let rect = CGRect(origin: CGPoint.zero, size: self.size)
        let cgImage = context.createCGImage(outputCIImage, from: rect)
        //显示生成的模糊图片
        return UIImage(cgImage: cgImage!)
    }

    // MARK: 1.5、设置图片透明度
    /// 设置图片透明度
    /// alpha: 透明度
    /// - Returns: newImage
    func jq_imageByApplayingAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -area.height)
        context?.setBlendMode(.multiply)
        context?.setAlpha(alpha)
        context?.draw(self.cgImage!, in: area)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }

    /// 添加水印方法:添加文字
    func jq_waterMarkeText(waterMarkText:String, corner:WaterMarkCorner = .BottomLeft,
                           margin:CGPoint = CGPoint(x: 20, y: 20),
                           waterMarkTextColor:UIColor = UIColor.white,
                           waterMarkTextFont:UIFont = UIFont.systemFont(ofSize: 20),
                           backgroundColor:UIColor = UIColor.clear) -> UIImage?{

        let textAttributes = [NSAttributedString.Key.foregroundColor:waterMarkTextColor,
                              NSAttributedString.Key.font:waterMarkTextFont,
                              NSAttributedString.Key.backgroundColor:backgroundColor]
        let textSize = NSString(string: waterMarkText).size(withAttributes: textAttributes)
        var textFrame = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)

        let imageSize = self.size
        switch corner{
            case .TopLeft:
                textFrame.origin = margin
            case .TopRight:
                textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: margin.y)
            case .BottomLeft:
                textFrame.origin = CGPoint(x: margin.x, y: imageSize.height - textSize.height - margin.y)
            case .BottomRight:
                textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x,
                                           y: imageSize.height - textSize.height - margin.y)
        }

        // 开始给图片添加文字水印
        UIGraphicsBeginImageContext(imageSize)
        draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        NSString(string: waterMarkText).draw(in:textFrame, withAttributes: textAttributes)

        let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return waterMarkedImage
    }

    //添加图片水印方法：添加图片
    func jq_waterMarkeImg(waterMarkImage:UIImage, corner:WaterMarkCorner = .BottomRight,
                          margin:CGPoint = CGPoint(x: 20, y: 20), alpha:CGFloat = 1) -> UIImage{

        var markFrame = CGRect(x:0, y: 0, width:waterMarkImage.size.width,
                               height: waterMarkImage.size.height)
        let imageSize = self.size

        switch corner{
            case .TopLeft:
                markFrame.origin = margin
            case .TopRight:
                markFrame.origin = CGPoint(x: imageSize.width - waterMarkImage.size.width - margin.x,
                                           y: margin.y)
            case .BottomLeft:
                markFrame.origin = CGPoint(x: margin.x,
                                           y: imageSize.height - waterMarkImage.size.height - margin.y)
            case .BottomRight:
                markFrame.origin = CGPoint(x: imageSize.width - waterMarkImage.size.width - margin.x,
                                           y: imageSize.height - waterMarkImage.size.height - margin.y)
        }

        // 开始给图片添加图片
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in: CGRect(x: 0, y:0, width: imageSize.width, height: imageSize.height))
        waterMarkImage.draw(in: markFrame, blendMode: .normal, alpha: alpha)
        let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return waterMarkedImage!
    }

    /*
     滤镜
     https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP40004346

     【查看】CICategoryColorEffect

     */
    func jq_filter(name:String) -> UIImage?
    {
        let imageData = self.pngData()
        let inputImage = CoreImage.CIImage(data: imageData!)
        let context = CIContext(options:nil)
        let filter = CIFilter(name:name)
        filter!.setValue(inputImage, forKey: kCIInputImageKey)
        filter!.setValue(0.8, forKey: "inputIntensity")
        if let outputImage = filter!.outputImage {
            let outImage = context.createCGImage(outputImage, from: outputImage.extent)
            return UIImage(cgImage: outImage!)
        }
        return nil
    }

    /// 生成对应的码图片
    /// - Parameters:
    ///   - string: 图片中的内容
    ///   - descriptor: 码的类型
    ///   - size: 图片的大小
    ///   - color: 图片的颜色
    ///   - level: 码的容错级别
    /// - Returns: 图片
    static func ld_generate(string: String,descriptor: CodeDescriptor,size: CGSize,color:UIColor? = nil,level:CorrectionLevel = .M) -> UIImage? {
        guard let data = string.data(using: .utf8),let filter = CIFilter(name: descriptor.rawValue) else {
            return nil
        }

        filter.setValue(data, forKey: CodeKey.inputMessage.rawValue)
        if (descriptor == .qrCpde || descriptor == .pdf417){
            switch level {
                case .L,.M,.Q,.H:
                    filter.setValue(level.levelValue, forKey: CodeKey.inputCorrectionLevel.rawValue)
                default:break
            }
        }else if descriptor == .aztec{
            switch level {
                case .aztecLevel(var value):
                    if value < 5 {
                        value = 5
                    }else if value > 95{
                        value = 95
                    }
                    filter.setValue(NSNumber.init(value: value), forKey: CodeKey.inputCorrectionLevel.rawValue)
                default:break
            }
        }

        guard let image = filter.outputImage else {
            return nil
        }

        let imageSize = image.extent.size
        let transform = CGAffineTransform(scaleX: size.width / imageSize.width,y: size.height / imageSize.height)
        let scaledImage = image.transformed(by: transform)

        guard let codeColor = color else{
            return UIImage.init(ciImage: scaledImage)
        }

        // 设置颜色
        let colorFilter = CIFilter(name: "CIFalseColor", parameters: ["inputImage":scaledImage,"inputColor0":CIColor(cgColor: codeColor.cgColor ),"inputColor1":CIColor(cgColor: UIColor.clear.cgColor)])

        guard let newOutPutImage = colorFilter?.outputImage else {
            return UIImage.init(ciImage: scaledImage)
        }
        return UIImage.init(ciImage: newOutPutImage)
    }

    /// 根码上夹图片
    /// - Parameters:
    ///   - inputImage: 码图片
    ///   - fillImage: 中间的icon图片
    ///   - fillSize: icon的大小
    /// - Returns: 合成后的图片
    static func ld_fillImage(_ inputImage:UIImage?,_ fillImage:UIImage?,_ fillSize:CGSize) -> UIImage? {
        guard let input = inputImage,let fill = fillImage  else {
            return inputImage
        }
        let imageSize = input.size
        UIGraphicsBeginImageContext(imageSize)
        input.draw(in: CGRect.init(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let fillWidth = min(imageSize.width, fillSize.width)
        let fillHeight = min(imageSize.height, fillSize.height)
        let fillRect = CGRect(x: (imageSize.width - fillWidth)/2, y: (imageSize.height - fillHeight)/2, width: fillWidth ,height: fillHeight)
        fill.draw(in: fillRect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return inputImage
        }
        UIGraphicsEndImageContext()
        return newImage
    }
}



