//
//  LD_OpenFile.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/3/4.
//

import QuickLook

/// 打开文件操作
public class LD_OpenFile: NSObject,QLPreviewControllerDelegate,QLPreviewControllerDataSource{
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return datePathStr! as NSURL
    }

    public var datePathStr:URL!

    public func show(){
        let myQlPreVC = QLPreviewController()
        myQlPreVC.delegate = self
        myQlPreVC.dataSource = self
        myQlPreVC.currentPreviewItemIndex = 0

        LD_currentNavigationController().present(myQlPreVC, animated: true, completion: nil)
    }
}
