//
//  LDTools.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/2/4.
//

import Foundation
import HandyJSON

/*
 核心工具类，封装了常用的内容
 */
public class LDTools:NSObject{


    // MARK: -- Static Function

    /// app对账号密码自动填充,交给iCloud 进行同步管理，同时需要官网进行一些配置，配置请参考以下链接
    /// * [参考链接1](https://www.jianshu.com/p/96f0c009d285)
    /// * [参考链接2](https://www.jianshu.com/p/20c94cb00b1b)
    /// - Parameters:
    ///   - server: 标示一般是公司域名:webcredentials:example.com的example.com部分
    ///   - username: 账号:已开启TextField的textContentType = .username | .email 等
    ///   - password: 密码:已开启TextField的textContentType = .password
    ///   - clouse: 设置回调
    public static func SaveAccount(_ server:String,username:String,password:String, _  clouse: @escaping (Bool)->Void){
        SecAddSharedWebCredential(server as CFString, username as CFString, password as CFString) { (error) in
            error == nil ? clouse(true) : clouse(false)
        }
    }

    ///获取系统缓存大小（B）
    public static func CacheSize() -> String {
        var big = 0.0
        let cachePath = NSSearchPathForDirectoriesInDomains(
            .cachesDirectory, .userDomainMask, true).first
        let files = FileManager.default.subpaths(atPath: cachePath!)

        for p in files!{
            let path = cachePath!.appendingFormat("/\(p)")
            if let floder = try? FileManager.default.attributesOfItem(atPath: path){
                for (abc,bcd) in floder {
                    if abc == .size{
                        big += (bcd as AnyObject).doubleValue
                    }
                }
            }
        }
        if big/1024/1024 > 0{
            return "\(String(format: "%.2f", big/1024/1024))MB"
        }else if big/1024 > 0{
            return "\(String(format: "%.2f", big/1024))KB"
        }else{
            return "\(String(format: "%.2f", big))B"
        }
    }

    ///清除缓存
    public static func cleanCache(succuss:(()->Void)?) {
        DispatchQueue.global().async {
            let cachePath = NSSearchPathForDirectoriesInDomains(
                .cachesDirectory, .userDomainMask, true).first
            let files = FileManager.default.subpaths(atPath: cachePath!)
            if let files = files{
                if files.isEmpty{
                    succuss!()
                }else{
                    for p in files{
                        let path = cachePath!.appendingFormat("/\(p)")
                        if(FileManager.default.fileExists(atPath: path) && FileManager.default.isDeletableFile(atPath: path)){
                            do {
                                try FileManager.default.removeItem(atPath: path as String)
                            } catch {
                                print("removeItemAtPath err"+path)
                            }
                        }
                    }
                    succuss!()
                }
            }else{
                succuss!()
            }
        }
    }

    /// 代码延迟运行
    ///
    /// - Parameters:
    ///   - delayTime: 延时时间。比如：.seconds(5)、.milliseconds(500)
    ///   - qosClass: 要使用的全局QOS类（默认为 nil，表示主线程）
    ///   - closure: 延迟运行的代码
    public static func delay(by delayTime: TimeInterval, qosClass: DispatchQoS.QoSClass? = nil,
                             _ closure: @escaping () -> Void) {
        let dispatchQueue = qosClass != nil ? DispatchQueue.global(qos: qosClass!) : .main
        dispatchQueue.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: closure)
    }

    ///开启倒计时
    public static func openCountDown(sender: UIButton,_ timeOver:(()->Void)? = nil) {
        var time = 59 //倒计时时间
        let queue = DispatchQueue.global()
        let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: .seconds(1));
        timer.setEventHandler(handler: {
            if time <= 0 {
                timer.cancel()
                DispatchQueue.main.async(execute: {
                    sender.setTitle("获取验证码", for: .normal)
                    sender.isUserInteractionEnabled = true
                    timeOver?()
                });
            }else {
                DispatchQueue.main.async(execute: {
                    sender.setTitle("\(time)s", for: .normal)
                    sender.isUserInteractionEnabled = false
                });
            }
            time -= 1
        });
        timer.resume()
    }


    /// 版本信息
    public static func currentVersion()->String{
        let info = Bundle.main.infoDictionary
        var version = ""
        #if DEBUG
        version = info!["CFBundleVersion"] as! String
        #else
        version = info!["CFBundleShortVersionString"]  as! String
        #endif
        return version
    }

    public static func alert(title:String,message:String?,cancelStr:String,sureStr:String, clouse: @escaping (Int)->Void){
        let alertVC = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelStr, style: .cancel) { action in
            clouse(0)
        }

        let subAction = UIAlertAction(title: sureStr, style: .default) { action in
            clouse(1)
        }

        alertVC.addAction(cancelAction)
        alertVC.addAction(subAction)
        LD_currentViewController().present(alertVC, animated: true, completion: nil)

    }


    public static func checkVersion(appid:String,_ clouse:((Bool,VersionResultModel?)->Void)? = nil){
        if appid.isEmpty {fatalError("请填写appid")}
        if let url = URL(string: "https://itunes.apple.com/cn/lookup?id=\(appid)"){
            let shareSession = URLSession.shared
            let request = URLRequest(url: url)
            let task = shareSession.dataTask(with: request) { (data, response, error) in
                if error == nil && data != nil{
                    do{
                        let dictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Dictionary<String, Any>
                        let versionModel = VersionModel.deserialize(from: dictionary)
                        if currentVersion() != versionModel?.results.last?.version{
                            clouse?(true,versionModel?.results.last!)
                        }else{
                            clouse?(false,nil)
                        }
                    }catch{
                        clouse?(false,nil)
                    }
                }
            }
            task.resume()
        }
    }


    /// 跳转至AppStore检查更新等
    public static func jumpAppStore(appid:String){
        if let url = URL(string: "itms-apps://itunes.apple.com/cn/app/id\(appid)"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

public struct VersionModel:HandyJSON{
    public init() {}
    public var resultCount = 1
    public var results = [VersionResultModel]()

}

public struct VersionResultModel:HandyJSON{
    public init(){}

    public var ipadScreenshotUrls = [String]()
    public var appletvScreenshotUrls = [String]()
    public var artworkUrl60 = ""
    public var artworkUrl512 = ""
    public var artworkUrl100 = ""
    public var artistViewUrl = ""
    public var screenshotUrls = [String]()
    public var isGameCenterEnabled = false
    public var supportedDevices = [String]()
    public var advisories = [String]()
    public var features = [String]()
    public var kind = ""
    public var trackCensoredName = ""
    public var languageCodesISO2A = [String]()
    public var fileSizeBytes = ""
    public var sellerUrl = ""
    public var contentAdvisoryRating = ""
    public var averageUserRatingForCurrentVersion = ""
    public var userRatingCountForCurrentVersion = ""
    public var averageUserRating = ""
    public var trackViewUrl = ""
    public var trackContentRating = ""
    public var releaseDate = ""
    public var genreIds = [String]()
    public var formattedPrice = ""
    public var primaryGenreName = ""
    public var isVppDeviceBasedLicensingEnabled = false
    public var minimumOsVersion = ""
    public var sellerName = ""
    public var currentVersionReleaseDate = ""
    public var releaseNotes = ""
    public var primaryGenreId = 0
    public var currency = ""
    public var trackId = 0
    public var trackName = ""
    public var description = ""
    public var artistId = 0
    public var artistName = ""
    public var genres = [String]()
    public var price = 0
    public var bundleId = ""
    public var version = ""
    public var wrapperType = ""
    public var userRatingCount = 0
}
