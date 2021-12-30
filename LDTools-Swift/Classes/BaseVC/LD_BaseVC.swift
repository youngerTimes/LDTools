//
//  LD_BaseVC.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/2/4.
//

import Foundation

//public enum LD_AppearanceStyle:Int{
//    case none = 0
//    case light = 1
//    case dark = 2
//}


/// 暗黑模式适配
//public protocol LD_ColorAppearanceProtocol:NSObject{
//    @available(iOS 12.0, *)
//    /// 所有的颜色变化,需要写到这里
//    func colorAppearance(_ style:LD_AppearanceStyle)
//}

/// 基础控件
open class LD_BaseVC: UIViewController{

//    private(set) public var currentStyle:LD_AppearanceStyle = .none
    open var hh_popBlock:(() -> Void)?
//    open var closeDarkStyle:Bool = true //是否关闭暗黑模式

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        //初次进入,判断当前风格
//        if #available(iOS 13.0, *) {
//            overrideUserInterfaceStyle = .light
//            if UITraitCollection.current.userInterfaceStyle == .dark {
//                if closeDarkStyle {
//                    currentStyle = .light
//                    colorAppearance(.light)
//                }else{
//                    overrideUserInterfaceStyle = .dark
//                    currentStyle = .dark
//                    colorAppearance(.dark)
//                }
//            }else{
//                currentStyle = .light
//                colorAppearance(.light)
//            }
//        } else {
//            currentStyle = .light
//            colorAppearance(.light)
//        }

        setUI()

//        NotificationCenter.default.rx.notification(UIDevice.orientationDidChangeNotification).take(until: self.rx.deallocated).subscribe { _ in
//            let orient = UIDevice.current.orientation
//            var desc = ""
//            switch orient {
//                case .portrait :desc = "屏幕正常竖向"
//                case .portraitUpsideDown:desc = "屏幕倒立"
//                case .landscapeLeft:desc = "屏幕左旋转"
//                case .landscapeRight:desc = "屏幕右旋转"
//                default:break
//            }
//            self.receiverNotification(orient: orient, desc: desc)
//        }.disposed(by: LD_disposeBag)
    }

    // 导航栏返回按钮图片
    open var back_img:UIImage = UIImage(named: "icon_back") ?? UIImage(){
        didSet {
            if hh_isHaveBackItem {
                if let btn = navigationItem.leftBarButtonItem?.customView as? UIButton{
                    btn.setImage(back_img, for: .normal)
                }else{
                    navigationItem.leftBarButtonItem = UIBarButtonItem(image: back_img, style: .plain, target: self, action: #selector(backItemEvent))
                }
            } else {
                hh_isHaveBackItem = true
            }
        }
    }

    /// 是否需要返回按钮 默认需要
    open var hh_isHaveBackItem:Bool = true {
        didSet {
            if hh_isHaveBackItem && navigationController?.viewControllers.count != 1 {

                navigationItem.leftBarButtonItem = UIBarButtonItem(image: back_img, style: .plain, target: self, action: #selector(backItemEvent))
                //                navigationItem.leftBarButtonItem?.width = -20
            } else {
                navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
            }
        }
    }

    open func setUI(){
        hh_isHaveBackItem = true
    }

    /// 屏幕旋转监听:当设备方向改变，需要对UI进行重新布局，子类重写此方法
//    @objc open func receiverNotification(orient:UIDeviceOrientation,desc:String){}


    /// 将nav 设置为透明
    /// - Parameters:
    ///   - titleColor: 字体颜色：默认白色
    ///   - font: 字体大小：默认medium,18
    open func setNavTransparence(titleColor:UIColor = .white,font:UIFont = UIFont.systemFont(ofSize: 18, weight: .medium)){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = titleColor.withAlphaComponent(1)
        self.navigationController?.navigationBar.titleTextAttributes = [.font:font, .foregroundColor:titleColor]
    }

    /// 重置nav
    open func reSetNavTransparence(titleColor:UIColor = .black,font:UIFont = UIFont.systemFont(ofSize: 18, weight: .medium)){
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.tintColor = titleColor
        self.navigationController?.navigationBar.titleTextAttributes = [.font:font, .foregroundColor:titleColor]
    }

    // pop点击事件
    @objc fileprivate func backItemEvent() {

        // 拦截pop事件
        if (hh_popBlock != nil) {
            hh_popBlock?()
            return
        }
        pop()
    }

    // pop
    open func pop(_ animated:Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

//    open func colorAppearance(_ style: LD_AppearanceStyle) {
//
//    }

    deinit {
        print("销毁：--->\(self.description)")
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }

//    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//
//        if #available(iOS 13.0, *) {
//            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//                overrideUserInterfaceStyle = .light
//                //暗黑模式
//                if UITraitCollection.current.userInterfaceStyle == .dark {
//                    if closeDarkStyle {
//                        colorAppearance(.light)
//                        currentStyle = .light
//                    }else{
//                        overrideUserInterfaceStyle = .dark
//                        colorAppearance(.dark)
//                        currentStyle = .dark
//                    }
//                }else{
//                    colorAppearance(.light)
//                    currentStyle = .light
//                }
//            }
//        } else {
//            //浅色模式
//            if #available(iOS 12.0, *) {
//                colorAppearance(.light)
//                currentStyle = .light
//            }
//        }
//    }

    /// 旋转横屏,单纯的旋转【非强制】
    public func ld_forceOrientationLandscape() {
        let oriention = UIInterfaceOrientation.landscapeRight // 设置屏幕为横屏
        UIDevice.current.setValue(oriention.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    // 旋转竖屏,单纯的旋转【非强制】
    public func ld_forceOrientationPortrait() {
        let oriention = UIInterfaceOrientation.portrait // 设置屏幕为竖屏
        UIDevice.current.setValue(oriention.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }

//    /// 默认显示方向
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{return .portrait}
}
