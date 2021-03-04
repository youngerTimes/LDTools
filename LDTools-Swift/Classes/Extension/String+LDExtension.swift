//
//  String+LDExtension.swift
//  SwiftFrame
//
//  Created by 无故事王国 on 2021/2/2.
//

import Foundation
import CommonCrypto

public extension String{
    private static let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

    enum LDSafeBase64Type {
        ///加密
        case encode
        ///解密
        case decode
    }

    enum HMACAlgorithm {
        case MD5, SHA1, SHA224, SHA256, SHA384, SHA512

        func toCCHmacAlgorithm() -> CCHmacAlgorithm {
            var result: Int = 0
            switch self {
                case .MD5:
                    result = kCCHmacAlgMD5
                case .SHA1:
                    result = kCCHmacAlgSHA1
                case .SHA224:
                    result = kCCHmacAlgSHA224
                case .SHA256:
                    result = kCCHmacAlgSHA256
                case .SHA384:
                    result = kCCHmacAlgSHA384
                case .SHA512:
                    result = kCCHmacAlgSHA512
            }
            return CCHmacAlgorithm(result)
        }

        func digestLength() -> Int {
            var result: CInt = 0
            switch self {
                case .MD5:
                    result = CC_MD5_DIGEST_LENGTH
                case .SHA1:
                    result = CC_SHA1_DIGEST_LENGTH
                case .SHA224:
                    result = CC_SHA224_DIGEST_LENGTH
                case .SHA256:
                    result = CC_SHA256_DIGEST_LENGTH
                case .SHA384:
                    result = CC_SHA384_DIGEST_LENGTH
                case .SHA512:
                    result = CC_SHA512_DIGEST_LENGTH
            }
            return Int(result)
        }
    }

    // MARK: -- Static
    /// 获取字符串宽度
    static func ld_getWidth(text: String, height: CGFloat, font: CGFloat) -> CGFloat {
        let text = text as NSString
        let rect = text.boundingRect(with: CGSize(width: CGFloat(Int.max), height: height), options: .usesLineFragmentOrigin, attributes: [.font : UIFont.systemFont(ofSize: font)], context: nil)
        return rect.size.width
    }

    ///获取字符串高度
    static func ld_getHeight(text: String, width: CGFloat, font: CGFloat) -> CGFloat {
        let text = text as NSString
        let rect = text.boundingRect(with: CGSize(width: width, height: CGFloat(Int.max)), options: .usesLineFragmentOrigin, attributes: [.font : UIFont.systemFont(ofSize: font)], context: nil)
        return rect.size.height
    }

    ///获取字符串高度(带font)
    static func ld_getHeightwithFont(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let text = text as NSString
        let rect = text.boundingRect(with: CGSize(width: width, height: CGFloat(Int.max)), options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        return rect.size.height
    }

    ///获取指定长度的随机字符串
    static func ld_randomStr(len : Int) -> String{
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
            ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }


    // MARK: -- Instance Method

    /// 指定范围随机数值
    func ld_randomNumber(start: Int, end: Int) ->() ->Int? {
        //根据参数初始化可选值数组
        var nums = [Int]();
        for i in start...end{
            nums.append(i)
        }

        func randomMan() -> Int! {
            if !nums.isEmpty {
                //随机返回一个数，同时从数组里删除
                let index = Int(arc4random_uniform(UInt32(nums.count)))
                return nums.remove(at: index)
            }else {
                //所有值都随机完则返回nil
                return nil
            }
        }

        return randomMan
    }

    /// 从文本中提取所有链接
    /// - Returns: 提取的url
    func ld_pickUpUrls() -> [String] {
        var urls = [String]()
        // 创建一个正则表达式对象
        do {
            let dataDetector = try NSDataDetector(types:NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue))
            // 匹配字符串,返回结果集
            let res = dataDetector.matches(in: self,options: NSRegularExpression.MatchingOptions(rawValue: 0),range: NSMakeRange(0, self.count))
            // 取出结果
            for checkingRes in res {
                urls.append((self as NSString).substring(with: checkingRes.range))
            }
        }
        catch {
            print(error)
        }
        return urls
    }


    /// 从文本中提取所有时间
    /// - Returns: 提取的时间
    func ld_pickUpDate() -> [String] {
        var urls = [String]()
        // 创建一个正则表达式对象
        do {
            let dataDetector = try NSDataDetector(types:NSTextCheckingTypes(NSTextCheckingResult.CheckingType.date.rawValue))
            // 匹配字符串,返回结果集
            let res = dataDetector.matches(in: self,options: NSRegularExpression.MatchingOptions(rawValue: 0),range: NSMakeRange(0, self.count))
            // 取出结果
            for checkingRes in res {
                urls.append((self as NSString).substring(with: checkingRes.range))
            }
        }
        catch {
            print(error)
        }
        return urls
    }


    /// 从文本中提取所有电话号码
    /// - Returns: 提取的电话号码
    func ld_pickUpPhone() -> [String] {
        var urls = [String]()
        // 创建一个正则表达式对象
        do {
            let dataDetector = try NSDataDetector(types:NSTextCheckingTypes(NSTextCheckingResult.CheckingType.phoneNumber.rawValue))
            // 匹配字符串,返回结果集
            let res = dataDetector.matches(in: self,options: NSRegularExpression.MatchingOptions(rawValue: 0),range: NSMakeRange(0, self.count))
            // 取出结果
            for checkingRes in res {
                urls.append((self as NSString).substring(with: checkingRes.range))
            }
        }
        catch {
            print(error)
        }
        return urls
    }


    /// 将 String/Data 类型转换成UnsafeMutablePointer<UInt8>类型
    func ld_mutableBytes(_ clouse:((UnsafeMutablePointer<UInt8>)->Void)?){
        var data = self.data(using: .utf8)!
        data.withUnsafeMutableBytes({ (bytes: UnsafeMutablePointer<UInt8>) -> Void in
            //bytes即为指针地址
            print("指针地址：\(bytes)")
            //通过指针移动来取值（赋值也是可以的）
            var bytesStart = bytes
            for _ in 0..<6 {
                print(bytesStart.pointee)
                bytesStart += 1
            }
            clouse?(bytes)
        })
    }

    /// 16进制字符串转Data
    func ld_hexData() -> Data? {
        var data = Data(capacity: count / 2)
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        guard data.count > 0 else { return nil }
        return data
    }


    /// 字符串转Data
    func ld_utf8Data()-> Data? {
        return self.data(using: .utf8)
    }


    /// 获取子串的位置
    /// - Parameter sub: 子串
    /// - Returns: 返回元组类型，位置；长度
    func ld_subString(sub:String)->(index:NSInteger,length:NSInteger){
        if let range = self.range(of:sub) {
            let startPos = self.distance(from: self.startIndex, to: range.lowerBound)
            let endPos = self.distance(from: self.startIndex, to: range.upperBound)
            return(startPos,endPos)
        }
        return (0,0)
    }

/// 根据脚标获取子串
    subscript(start:Int, length:Int) -> String{
        get{
            let index1 = self.index(self.startIndex, offsetBy: start)
            let index2 = self.index(index1, offsetBy: length)
            let range = Range(uncheckedBounds: (lower: index1, upper: index2))
            return self.substring(with: range)
        }
        set{
            let tmp = self
            var s = ""
            var e = ""
            for (idx, item) in tmp.enumerated() {
                if(idx < start)
                {
                    s += "\(item)"
                }
                if(idx >= start + length)
                {
                    e += "\(item)"
                }
            }
            self = s + newValue + e
        }
    }

    subscript(index:Int) -> String{
        get{
            return String(self[self.index(self.startIndex, offsetBy: index)])
        }
        set{
            let tmp = self
            self = ""
            for (idx, item) in tmp.enumerated() {
                if idx == index {
                    self += "\(newValue)"
                }else{
                    self += "\(item)"
                }
            }
        }
    }


    /// 获取子字符串的NSRange
    func ld_subRange(_ subText:String)->NSRange{
        let range = self.range(of: subText)
        let from = range?.lowerBound.samePosition(in: utf16)
        let to = range?.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!),
                       length: utf16.distance(from: from!, to: to!))
    }

    /// 将字符串转换为字典类型
    func ld_toDict() -> [String : Any]?{
        let data = self.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
            return dict
        }
        return nil
    }

    ///JSONString转换为数组
    static func ld_toArray(jsonString:String) ->NSArray{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as! NSArray
        }
        return array as! NSArray
    }

    ///字符串分割成数组
    func ld_toArray(character:String) -> Array<String>{
        let array : Array = components(separatedBy: character)
        return array
    }

    ///去掉首尾空格 后 指定开头空格数
    func ld_beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0..<num {
            beginSpace += " "
        }
        return beginSpace + self.ld_removeHeadAndTailSpacePro
    }

    ///配合 TextDelegate -> shouldChangeCharactersIn
    func ld_filterDecimals(replacementString:String,range:NSRange,limit:NSInteger = 2)->Bool{
        let futureString: NSMutableString = NSMutableString(string: self)
        futureString.insert(replacementString, at: range.location)
        var flag = 0
        let limited = limit//小数点后需要限制的个数
        if !futureString.isEqual(to: "") {
            for i in stride(from: (futureString.length - 1), through: 0, by: -1) {
                let char = Character(UnicodeScalar(futureString.character(at: i))!)
                if char == "." {
                    if flag > limited {return false}
                    break
                }
                flag += 1
            }
        }
        return true
    }

    ///JsonString->字典
    func ld_dictionaryFromJsonString() -> Any? {
        let jsonData = self.data(using: String.Encoding.utf8)
        if jsonData != nil {
            let dic = try? JSONSerialization.jsonObject(with: jsonData!, options: [])
            if dic != nil {
                return dic
            }else {
                return nil
            }
        }else {
            return nil
        }
    }


    ///将原始的url编码为合法的url
    func ld_urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        return encodeUrlString ?? ""
    }

    ///将编码后的url转换回原始的url
    func ld_urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }

    ///获取子字符串
    func ld_substingInRange(_ r: Range<Int>) -> String? {
        if r.lowerBound < 0 || r.upperBound > self.count {
            return nil
        }
        let startIndex = self.index(self.startIndex, offsetBy:r.lowerBound)
        let endIndex   = self.index(self.startIndex, offsetBy:r.upperBound)
        return String(self[startIndex..<endIndex])
    }

    ///时间转换为Date
    func ld_toDate(format:String = "YYYY-MM-dd") ->Date?{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        dateformatter.timeZone = TimeZone.current
        return dateformatter.date(from: self)
    }

    /// 将HTML标签中<>去除
    func ld_filterFromHTML(_ htmlString:String)->String{
        var html = htmlString
        let scanner = Scanner(string: htmlString)
        let text:String = ""
        while scanner.isAtEnd == false {
            scanner.scanUpTo("<", into: nil)
            scanner.scanUpTo(">", into: nil)
            html = htmlString.replacingOccurrences(of:"\(text)>", with: "")
        }
        return html
    }

    ///减少内存(截取)
    func ld_substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        } else {
            return self
        }
    }

    ///减少内存(截取)
    func ld_substring(to index: Int) -> String {
        if self.count > index {
            let endIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[self.startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }

    ///转化为Base64
    func ld_safeBase64(type: LDSafeBase64Type) -> String {
        var base64Str: String!
        if type == .encode {
            base64Str = self.replacingOccurrences(of: "+", with: "-")
            base64Str = base64Str.replacingOccurrences(of: "/", with: "_")
            base64Str = base64Str.replacingOccurrences(of: "=", with: "")
        }else {
            base64Str = self.replacingOccurrences(of: "-", with: "+")
            base64Str = base64Str.replacingOccurrences(of: "_", with: "/")
            let mod = base64Str.count % 4
            if mod > 0 {
                base64Str += "====".ld_substring(to: mod)
            }
        }
        return base64Str
    }

    ///base64 转Data
    func ld_base64ToData()->Data?{
        if self.contains("%") {
            return Data(base64Encoded: self.removingPercentEncoding!)
        }
        return Data(base64Encoded: self)
    }


    ///MD5
    func ld_md5String() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)

        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize(count: digestLen)
        return String(format: hash as String)
    }

    ///获取字符串拼音
    func ld_getPinyin() -> String {
        let str = NSMutableString(string: self)
        CFStringTransform(str as CFMutableString, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(str as CFMutableString, nil, kCFStringTransformStripDiacritics, false)
        return str.capitalized
    }

    ///获取字符串首字母大写
    func ld_FirstLetter() -> String {
        let str = NSMutableString(string: self)
        CFStringTransform(str as CFMutableString, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(str as CFMutableString, nil, kCFStringTransformStripDiacritics, false)
        let strPinYin = str.capitalized
        return strPinYin.ld_substring(to: 1)
    }

    //    /// 去除emoji表情
    //    func ld_fliterEmoji()->String{
    //        let a = try! LD_RegexTool(.emoji)
    //        return a.replacingMatches(in: self, with: "")
    //    }

    //转译成字符值引用（NCR）
    func ld_toEncoded() -> String {
        var result:String = "";
        for scalar in self.utf16 {
            //将十进制转成十六进制，不足4位前面补0
            let tem = String().appendingFormat("%04x",scalar)
            result += "&#x\(tem);";
        }
        return result
    }


    /// 精准身份证号码判断
    func ld_idCard()->Bool{
        let idArray = NSMutableArray()
        for i in 0..<18 {
            let range = NSMakeRange(i, 1);
            let subString = NSString(string: self).substring(with: range)
            idArray.add(subString)
        }

        let coefficientArray = NSArray(arrayLiteral:"7","9","10","5","8","4","2","1","6","3","7","9","10","5","8","4","2")
        let remainderArray = NSArray(arrayLiteral:"1","0","X","9","8","7","6","5","4","3","2")
        var sum = 0
        for i in 0..<17 {
            let coefficient = NSInteger((coefficientArray[i] as! String))!
            let id = NSInteger((idArray[i] as! String))!
            sum += coefficient * id
        }

        let str = remainderArray[(sum % 11)] as! String
        let string = NSString(string: self).substring(from: 17)
        return str == string
    }

    ///判断是否为汉字
    func ld_isValidateChinese() -> Bool {
        let match: String = "[\\u4e00-\\u9fa5]+$"
        return NSPredicate(format: "SELF MATCHES %@", match).evaluate(with:self)
    }

    ///获取文件/文件夹大小
    func ld_getFileSize() -> UInt64  {
        var size: UInt64 = 0
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        let isExists = fileManager.fileExists(atPath: self, isDirectory: &isDir)
        if isExists {
            if isDir.boolValue {
                let enumerator = fileManager.enumerator(atPath: self)
                for subPath in enumerator! {
                    let fullPath = self.appending("/\(subPath)")
                    do {
                        let attr = try fileManager.attributesOfItem(atPath: fullPath)
                        size += attr[FileAttributeKey.size] as! UInt64
                    } catch  {
                        print("error :\(error)")
                    }
                }
            } else {
                do {
                    let attr = try fileManager.attributesOfItem(atPath: self)
                    size += attr[FileAttributeKey.size] as! UInt64

                } catch  {
                    print("error :\(error)")
                }
            }
        }
        return size
    }


    /// 字符串加密
    /// - Parameters:
    ///   - algorithm: 加密方式
    ///   - key: 加密的key
    /// - Returns: 返回加密结果
    func ld_hmac(algorithm: HMACAlgorithm, key: String) -> String {
        let cKey = key.cString(using: String.Encoding.utf8)
        let cData = self.cString(using: String.Encoding.utf8)
        //        var result = [CUnsignedChar](count: Int(algorithm.digestLength()), repeatedValue: 0)
        //        var hmacData:NSData = NSData(bytes: result, length: (Int(algorithm.digestLength())))
        //        var hmacBase64 = hmacData.base64EncodedStringWithOptions(NSData.Base64EncodingOptions.Encoding76CharacterLineLength)
        var result = [CUnsignedChar](repeating: 0, count: Int(algorithm.digestLength()))
        CCHmac(algorithm.toCCHmacAlgorithm(), cKey!, strlen(cKey!), cData!, strlen(cData!), &result)

        var hmacData: Data = Data(bytes: result, count: (Int(algorithm.digestLength())))


        //        var str = String(data: hmacData, encoding: String.Encoding.utf8)!
        //        str += "\(self)"
        //        let data = str.data(using: String.Encoding.utf8)!

        let data = self.data(using: String.Encoding.utf8)!
        hmacData.append(data)
        let hmacBase64 = hmacData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength76Characters)
        return String(hmacBase64)
    }


    // MARK: -- property

    /// 适配Web,JS代码，WKWebView代理didFinish执行
    /// /*
    ///  webView.evaluateJavaScript('')
    /// */
    var ld_adaptJS:String{
        get{return """
document.createElement('meta');script.name = 'viewport';script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";document.getElementsByTagName('head')[0].appendChild(script);var style = document.createElement('style');style.type='text/css';style.innerHTML='body{width:100%;height:auto;margin:auto;background-color:#ffffff}img{max-width:100%}p{word-wrap: break-word;color: #222;list-style-position: inside;list-style-type: square;margin-top: 17px;font-size: 18px;line-height: 1.76;border: none;outline: none;display: block;margin-block-start: 1em;margin-block-end: 1em;margin-inline-start: 0px;margin-inline-end: 0px;} p img {margin-bottom: -9px}';document.body.appendChild(style);
"""}
    }

    /// 手机号转138****6372
    var ld_blotOutPhone:String{
        if self.count != 11{
            print("传入手机号格式错误")
            return ""
        }else{
            let befor = prefix(3)
            let last = suffix(4)
            return befor + "****" + last
        }
    }

    ///适配Web,填充HTML的完整
    var ld_warpHtml:String{
        get{return "<html><head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><style>*{ width: 100%; margin: 0; padding: 0 3; box-sizing: border-box;} img{ width: 100%;}</style></head><body>\(self)</body></html>"}
    }

    ///去掉首尾空格
    var ld_removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }

    ///去掉首尾空格 包括后面的换行 \n
    var ld_removeHeadAndTailSpacePro:String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }

    ///去掉所有空格
    var ld_removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }

    /// 判断是否为手机号
    var ld_isPhone:Bool{
        let pattern2 = "^1[0-9]{10}$"
        if NSPredicate(format: "SELF MATCHES %@", pattern2).evaluate(with: self) {
            return true
        }
        return false
    }

    /// 判断是否是身份证
    var ld_isIdCard:Bool{
        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch:Bool = pred.evaluate(with: self)
        return isMatch
    }

    ///正则匹配用户密码6-18位数字和字母组合
    var ld_isComplexPassword:Bool{
        let pattern = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch:Bool = pred.evaluate(with: self)
        return isMatch
    }

    /// 判断是否是邮箱
    var ld_isEmail:Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch:Bool = pred.evaluate(with: self)
        return isMatch;
    }

    /// 判断是否是中文
    var ld_isChinese:Bool {
        let pattern = "^[a-zA-Z\\u4E00-\\u9FA5]{1,20}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch:Bool = pred.evaluate(with: self)
        return isMatch;
    }

    /// 判断是否是链接
    var ld_isURL:Bool {
        let url = URL(string: self)
        return url != nil
    }

    /// 返回字数
    var ld_count: Int {
        let string_NS = self as NSString
        return string_NS.length
    }

    /// 是否是IP地址
    var ld_isIP:Bool{
        let pattern = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch:Bool = pred.evaluate(with: self)
        return isMatch;
    }

    /// 对Unicode编码进行转换
    var ld_unicodeDescription : String{
        return self.ld_stringByReplaceUnicode
    }

    /// unicode编码
    var ld_stringByReplaceUnicode : String{
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\n", with: "\n")
    }
}
