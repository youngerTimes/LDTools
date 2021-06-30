//
//  UIView+LDExtension.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/2/4.
//

import Foundation

public enum LD_DottedLineType {
    case Vertical
    case Horizontal
}


public extension UIView{

    // MARK: Property

    // 边线的宽度
    @IBInspectable var ld_borderWidthXIB: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }

    // 边线的颜色
    @IBInspectable var ld_borderColorXIB: UIColor {
        get {
            guard let borderColor = self.layer.borderColor else {
                return UIColor.clear
            }
            return UIColor(cgColor: borderColor)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }

    // 子图层超出部分是否裁剪
    @IBInspectable var ld_maskToBoundsXIB: Bool {
        get {
            return self.layer.masksToBounds
        }
        set {
            self.layer.masksToBounds = newValue
        }
    }

    // 圆角
    @IBInspectable var ld_cornerRadiusXIB: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }

    var ld_identity:String{
        get{return "\(type(of: self))"}
    }

    var ld_x:CGFloat{
        get{return self.frame.origin.x}
        set(value){self.frame.origin.x = value}
    }

    var ld_y:CGFloat{
        get{return self.frame.origin.y}
        set(value){self.frame.origin.y = value}
    }

    var ld_height:CGFloat{
        get{return self.frame.size.height}
        set(value){self.frame.size.height = value}
    }

    var ld_width:CGFloat{
        get{return self.frame.size.width}
        set(value){self.frame.size.width = value}
    }

    var ld_cornerRadius:CGFloat{
        get{return self.layer.cornerRadius}
        set(value){
            self.layer.masksToBounds = true
            self.layer.cornerRadius = value
        }
    }

    var ld_masksToBounds:Bool{
        get{return self.layer.masksToBounds}
        set(value){self.layer.masksToBounds = value}
    }

    var ld_borderWidth:CGFloat{
        get{return self.layer.borderWidth}
        set(value){self.layer.borderWidth = value}
    }

    var ld_borderCololr:CGColor?{
        get{return self.layer.borderColor}
        set(value){self.layer.borderColor = value}
    }

    /// centerY
    var ld_centerY: CGFloat {
        get {return center.y}
        set {center.y = newValue}
    }

    /// size
    var ld_size: CGSize {
        get {return frame.size}
        set {frame.size = newValue}
    }

    var ld_right: CGFloat {
        get {return frame.maxX}
    }

    var ld_bottom: CGFloat {
        get {return frame.maxY}
    }


    // MARK: -- Function
    ///返回该view所在VC
    func ld_firstVC() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }

    ///切部分圆角(Frame) 注意不能用错，storyboard和nib 在高度动态变化时，容易出现BUG
    func ld_cornerPart(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        maskLayer.masksToBounds = false
        maskLayer.shouldRasterize = true
        self.layer.mask = maskLayer
    }
    ///切部分圆角(Xib)
    func ld_cornerPartWithNib(byRoundingCorners corners: UIRectCorner, radii: CGFloat, size: CGSize) {
        let maskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        maskLayer.path = maskPath.cgPath
        maskLayer.shouldRasterize = true
        self.layer.mask = maskLayer
    }

    ///切圆角并且设置阴影
    func ld_cornerWith(radii: CGFloat, isXib:Bool,shadowColor:UIColor) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = radii
        self.layer.cornerRadius = radii
        self.layer.shadowOffset = CGSize.init(width: 0, height: 5)
        self.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: isXib ?self.bounds.size.width : self.bounds.size.width, height: isXib ? self.bounds.size.height : self.bounds.size.height), cornerRadius: radii).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }


    /// 切部分圆角
    /// - Returns: 返回阴影Layer,需要自定义颜色和范围
    func ld_cornerPartWithShadow(byRoundingCorners corners: UIRectCorner, radii: CGFloat)->CALayer {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer

        let shadowLayer = CALayer()
        shadowLayer.frame = self.frame
        shadowLayer.cornerRadius = radii
        shadowLayer.backgroundColor = UIColor.white.cgColor
        self.superview?.layer.addSublayer(shadowLayer)
        self.superview?.layer.qmui_sendSublayer(toBack: shadowLayer)

        return shadowLayer
    }


    /// 设置阴影
    func ld_shadow(shadowColor: UIColor, corner: CGFloat, opacity: Double) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.borderColor = shadowColor.cgColor
        self.layer.borderWidth = 0.000001;
        self.layer.cornerRadius = corner
        self.layer.shadowOpacity = Float(opacity)
        self.layer.shadowRadius = corner
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    ///【截图】UIView->UIImage
    func ld_captureToImage(_ saveToAlbum:Bool = false) -> UIImage {
        var imageRet = UIImage()
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        imageRet = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        if saveToAlbum {
            UIImageWriteToSavedPhotosAlbum(imageRet, nil, nil, nil)
        }

        return imageRet
    }

    ///【截图】将当前视图转为UIImage
    func ld_captureAsImage(_ saveToAlbum:Bool = false) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let image = renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }

        if saveToAlbum {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return image
    }

    /// 合并两个图片
    func ld_combinTwoImage(image1:UIImage,image2:UIImage) -> UIImage{
        let width = max(image1.size.width, image2.size.width)
        let height = image1.size.height + image2.size.height
        let offScreenSize = CGSize.init(width: width, height: height)

        UIGraphicsBeginImageContext(offScreenSize);

        let rect = CGRect.init(x:0, y:0, width:width, height:image1.size.height)
        image1.draw(in: rect)

        let rect2 = CGRect.init(x:0, y:image1.size.height, width:width, height:image2.size.height)
        image1.draw(in: rect2)

        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext();

        return image;
    }

    ///设置渐变色(Frame)
    func ld_gradientColor(colorArr:[CGColor],cornerRadius:CGFloat = 0) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colorArr
        gradientLayer.cornerRadius = cornerRadius
        if cornerRadius > 0 {gradientLayer.masksToBounds = true}
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    ///设置渐变色(Nib)
    @discardableResult
    func ld_gradientNibColor(colorArr:[CGColor],cornerRadius:CGFloat = 0) -> CAGradientLayer? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width*LD_RateW, height: self.frame.height*LD_RateH)
        gradientLayer.colors = colorArr
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = cornerRadius
        if cornerRadius > 0 {gradientLayer.masksToBounds = true}
        self.layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }

    /// 圆角加阴影
    func ld_addShadows(shadowColor: UIColor, corner: CGFloat,radius:CGFloat,offset:CGSize, opacity: Double) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.cornerRadius = corner
        self.layer.shadowOpacity = Float(opacity)
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    /// 添加阴影（父视图）
    static func ld_addRoundedOrShadow(frame: CGRect,radius:CGFloat, shadowOpacity:CGFloat, shadowColor:UIColor) -> CALayer {
        let subLayer = CALayer()
        let fixframe = frame
        let newFrame = CGRect(x: 0, y: fixframe.minY, width: fixframe.width, height: fixframe.height) // 修正偏差
        subLayer.frame = newFrame
        subLayer.cornerRadius = radius
        subLayer.backgroundColor = UIColor.white.cgColor
        subLayer.masksToBounds = false
        subLayer.shadowColor = shadowColor.cgColor // 阴影颜色
        subLayer.shadowOffset = CGSize(width: 0, height: 4) // 阴影偏移,width:向右偏移3，height:向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = Float(shadowOpacity) //阴影透明度
        subLayer.shadowRadius = 5;//阴影半径，默认3
        return subLayer
    }

    /// 添加阴影（父视图）
    static func ld_addRoundedOrShadows(frame: CGRect,radius:CGFloat, shadowOpacity:CGFloat, shadowColor:UIColor) -> CALayer {
        let subLayer = CALayer()
        let fixframe = frame
        let newFrame = CGRect(x: fixframe.minX-(375-UIScreen.main.bounds.size.width)/2, y: fixframe.minY, width: fixframe.width, height: fixframe.height) // 修正偏差
        subLayer.frame = newFrame
        subLayer.cornerRadius = radius
        subLayer.backgroundColor = UIColor.white.cgColor
        subLayer.masksToBounds = false
        subLayer.shadowColor = shadowColor.cgColor // 阴影颜色
        subLayer.shadowOffset = CGSize(width: 0, height: 0) // 阴影偏移,width:向右偏移3，height:向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = Float(shadowOpacity) //阴影透明度
        subLayer.shadowRadius = 5;//阴影半径，默认3
        return subLayer
    }

    /// 进度圆环
    /// - Parameters:
    ///   - circleWeight: 圆环宽度
    ///   - circleColor: 圆环颜色
    ///   - barBgColor: 圆环底色
    ///   - percent: 进度值 0 ~ 1.0
    ///   - duration: 动画执行，为0 则没有动画
    func ld_addCircle(circleWeight: CGFloat, circleColor: UIColor,barBgColor:UIColor, percent:CGFloat,duration:CGFloat = 0){
        let X = self.bounds.midX
        let Y = self.bounds.midY
        let startAngle = CGFloat(-Double.pi/2)
        let endAngle = CGFloat(Double.pi*1.5)

        if percent > 1.0{fatalError("范围0～1.0")}

        let barBgPath = UIBezierPath(arcCenter: CGPoint(x: X, y: Y), radius: ld_width/2,startAngle: startAngle, endAngle: endAngle,clockwise: true).cgPath

        self.addOval(lineWidth: circleWeight, path: barBgPath, strokeStart: 0, strokeEnd: 1,strokeColor: barBgColor, fillColor: UIColor.clear,shadowRadius: 0, shadowOpacity: 0, shadowOffsset: CGSize.zero)

        // 进度条圆弧
        let barPath = UIBezierPath(arcCenter: CGPoint(x: X, y: Y), radius:ld_width/2,startAngle: startAngle, endAngle: endAngle,clockwise: true).cgPath

        let layer = self.addOval(lineWidth: circleWeight, path: barPath, strokeStart: 0, strokeEnd: percent,strokeColor: circleColor, fillColor: UIColor.clear,shadowRadius: 0, shadowOpacity: 0, shadowOffsset: CGSize.zero)
        if duration != 0 {
            ld_addAnimation(layer, strokeStart: 0, strokeEnd: percent,duration: duration)
        }
    }

    /// 添加圆弧
    @discardableResult
    private func addOval(lineWidth: CGFloat, path: CGPath, strokeStart: CGFloat,strokeEnd: CGFloat, strokeColor: UIColor, fillColor: UIColor,shadowRadius: CGFloat, shadowOpacity: Float, shadowOffsset: CGSize)->CAShapeLayer {

        let arc = CAShapeLayer()
        arc.lineWidth = lineWidth
        arc.path = path
        arc.strokeStart = strokeStart
        arc.strokeEnd = strokeEnd
        arc.strokeColor = strokeColor.cgColor
        arc.fillColor = fillColor.cgColor
        arc.shadowColor = UIColor.black.cgColor
        arc.lineCap = CAShapeLayerLineCap.round
        arc.shadowRadius = shadowRadius
        arc.shadowOpacity = shadowOpacity
        arc.shadowOffset = shadowOffsset
        layer.addSublayer(arc)
        return arc
    }


    /// 创建一个矩形的实线
    func ld_addRectLine(_ color:UIColor){
        //线宽
        let lineWidth = 1 / UIScreen.main.scale
        //线偏移量
        let lineAdjustOffset = 1 / UIScreen.main.scale / 2
        //获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {return}

        //创建一个矩形，它的所有边都内缩固定的偏移量
        let drawingRect = self.bounds.insetBy(dx: lineAdjustOffset, dy: lineAdjustOffset)
        //创建并设置路径
        let path = CGMutablePath()
        //外边框
        path.addRect(drawingRect)
        //横向分隔线(中点同样要计算偏移量)
        let midY = CGFloat(Int(self.bounds.midY)) + lineAdjustOffset
        path.move(to: CGPoint(x: drawingRect.minX, y: midY))
        path.addLine(to: CGPoint(x: drawingRect.maxX, y: midY))
        //纵向分隔线(中点同样要计算偏移量)
        let midX = CGFloat(Int(self.bounds.midX)) + lineAdjustOffset
        path.move(to: CGPoint(x: midX, y: drawingRect.minY))
        path.addLine(to: CGPoint(x: midX, y: drawingRect.maxY))

        //添加路径到图形上下文
        context.addPath(path)
        //设置笔触颜色
        context.setStrokeColor(color.cgColor)

        //设置笔触宽度
        context.setLineWidth(lineWidth)
        //绘制路径
        context.strokePath()
    }

    private func ld_addAnimation(_ layer:CAShapeLayer,strokeStart: CGFloat,strokeEnd: CGFloat,duration:CGFloat){
        let basic = CABasicAnimation(keyPath: "strokeEnd")
        basic.duration = CFTimeInterval(duration)
        basic.fromValue = strokeStart
        basic.toValue = strokeEnd
        layer.add(basic, forKey: "checkAnimation")
    }

    // MARK: -- Static Function
    ///绘制虚线
    static func JQ_drawDashLine(lineView : UIView,lineLength : Double ,lineSpacing : Int,lineColor : UIColor, type:LD_DottedLineType){
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = lineView.bounds
        //        只要是CALayer这种类型,他的anchorPoint默认都是(0.5,0.5)
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.strokeColor = lineColor.cgColor
        if type == .Vertical {
            shapeLayer.lineWidth = lineView.frame.size.width * LD_RateW
        }else {
            shapeLayer.lineWidth = lineView.frame.size.height
        }

        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength),NSNumber(value: lineSpacing)]

        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))

        if type == .Vertical {
            path.addLine(to: CGPoint(x: 0, y: lineView.frame.size.height))
        }else {
            path.addLine(to: CGPoint(x: lineView.frame.size.width * LD_RateW, y: 0))
        }
        shapeLayer.path = path
        lineView.layer.addSublayer(shapeLayer)
    }
}
