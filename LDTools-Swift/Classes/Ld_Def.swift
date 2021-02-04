//
//  Ld_Def.swift
//  SwiftFrame
//
//  Created by 无故事王国 on 2021/2/2.
//

import Foundation
import QMUIKit
import RxSwift
import RxCocoa
import RxDataSources
import MJRefresh


// MARK: -- ENUM
public enum LD_RefreshStatus {
    case none
    case beingHeaderRefresh
    case endHeaderRefresh
    case beingFooterRefresh
    case endFooterRefresh
    case noMoreData
    case others
}


// MARK: -- Protocol
public protocol LD_Refreshable {
    var refreshStatus: BehaviorSubject<LD_RefreshStatus> { get }
}
extension LD_Refreshable {
    @discardableResult
    public func refreshStatusBind(to scrollView: UIScrollView, _ header: (() -> Void)? = nil, _ footer: (() -> Void)? = nil) -> Disposable {

        if header != nil {
            scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: header!)
        }
        if footer != nil {
            scrollView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: footer!)
        }
        return refreshStatus.subscribe(onNext: { (status) in
            switch status {
                case .beingHeaderRefresh:
                    scrollView.mj_header!.beginRefreshing()
                    break
                case .endHeaderRefresh:
                    scrollView.mj_header?.endRefreshing()
                    break
                case .beingFooterRefresh:
                    scrollView.mj_footer!.beginRefreshing()
                    break
                case .endFooterRefresh:
                    scrollView.mj_footer!.endRefreshing()
                    break
                case .noMoreData:
                    scrollView.mj_footer!.endRefreshingWithNoMoreData()
                    break
                case .none:
                    scrollView.mj_footer!.isHidden = true
                    break
                case .others: break
            }
        })
    }
}



// MARK: -- Unit Property
/// 屏幕宽度
public let LD_ScreenW = UIScreen.main.bounds.size.width

/// 屏幕高度
public let LD_ScreenH = UIScreen.main.bounds.size.height

/// 屏幕的适配比例，适配6s
public let LD_RateW   = LD_ScreenW/375.0

public let LD_RateH   = LD_ScreenH/667.0

/// Nav高度
public let LD_NavBarHeight:CGFloat = (UIApplication.shared.statusBarFrame.size.height>20) ?88:64

/// TabBar高度
public let LD_TabBarHeight:CGFloat = (UIApplication.shared.statusBarFrame.size.height)>20 ?83:49

/// window
public let LD_KeyWindow = UIApplication.shared.keyWindow!

/// Document路径
public let LD_DocumentPath =  NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).last

/// Cache路径
public let LD_CachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String

/// Libary路径
public let LD_LibaryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String

/// Temp路径
public let LD_TempPath = NSTemporaryDirectory() as String

/// 异形屏安全距离
public var LD_SafeEdges:UIEdgeInsets{
    get{
        let window = UIApplication.shared.keyWindow
        if window != nil{
            if #available(iOS 11.0, *) {
                return window!.safeAreaInsets
            } else {
                return UIEdgeInsets.zero
            }
        }else{
            return UIEdgeInsets.zero
        }
    }
}

/// 是否是异形屏
public var LD_IsDiffPhone: Bool{
    get {return UIScreen.main.bounds.size.height >= 812 || UIScreen.main.bounds.size.width >= 812}
}

/// 是否是手机
public var LD_IsPhone: Bool{
    get {return UIDevice.current.userInterfaceIdiom == .phone}
}

/// 是否是Pad
public var LD_IsPad:Bool{
    get{return UIDevice.current.userInterfaceIdiom == .pad}
}

public var LD_disposeBag = DisposeBag()


// MARK: -- Function
///当前的VC
public func LD_currentViewController() -> UIViewController {
    var currVC:UIViewController?
    var Rootvc = UIApplication.shared.keyWindow?.rootViewController
    repeat {
        if (Rootvc?.isKind(of: NSClassFromString("UINavigationController")!))! {
            let nav = Rootvc as! UINavigationController
            let v = nav.viewControllers.last
            currVC = v
            Rootvc = v?.presentedViewController
            continue
        }else if (Rootvc?.isKind(of: NSClassFromString("UITabBarController")!))!{
            let tabVC = Rootvc as! UITabBarController
            currVC = tabVC
            Rootvc = tabVC.viewControllers?[tabVC.selectedIndex]
            continue
        }else {
            return currVC!
        }

    } while Rootvc != nil
    return currVC!
}

///当前的NavVC
public func LD_currentNavigationController() -> UINavigationController {
    return LD_currentViewController().navigationController!
}


/// 动态加载VC
public func LD_loadVC(string:String)->UIViewController?{
    //动态获得命名空间
    let name = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
    //这里以控制器为例
    let vc1:AnyClass? = NSClassFromString(name + "." + string)
    if let vc = vc1 {
        let nameVc = vc as! UIViewController.Type
        //nameVc就是通过字符串动态加载后的类，我们可以通过他创建新的实例
        let newObject = nameVc.init()
        return newObject
    }
    return nil
}


