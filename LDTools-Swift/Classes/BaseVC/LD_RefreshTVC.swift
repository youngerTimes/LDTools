//
//  LD_RefreshTVC.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/2/4.
//

import RxSwift
import RxCocoa
import RxDataSources
import MJRefresh
import EmptyDataSet_Swift
import UIKit

/// 自带下拉刷新，上拉加载
/// 自带page,totalPages,
/// 使用时需要手动加载`ld_addReresh`
/// 数据回掉在`ld_getData`
///
open class LD_RefreshTVC: LD_BaseVC,LD_Refreshable{
    public var page = 1 //当前页数
    public var totalPages = -1 //总页数
    public var items = [Any]()
    private var scrollView:UIScrollView?

    public let refreshStatus = BehaviorSubject(value: LD_RefreshStatus.others)

    /// 获取数据
    /// - Parameter isHeader: 是否是头部刷新
    open func ld_getData(isHeader:Bool = true) {
        if isHeader {
            self.page = 1
            self.refreshStatus.onNext(LD_RefreshStatus.beingHeaderRefresh)
        }else {
            if page >= totalPages && totalPages != -1 {
                self.refreshStatus.onNext(LD_RefreshStatus.noMoreData);return
            }else{
                self.page += 1
                self.refreshStatus.onNext(LD_RefreshStatus.beingFooterRefresh)
            }
        }
    }

    /// 开始刷新数据
    public func ld_beginRefresh(){
        refreshStatus.onNext(LD_RefreshStatus.beingHeaderRefresh)
        scrollView?.mj_footer?.resetNoMoreData()
    }

    /// 结束刷新数据：没有总页数
    public func ld_endRefresh(isEmpty:Array<Any>? = nil) {
        self.refreshStatus.onNext(LD_RefreshStatus.endHeaderRefresh)
        if self.scrollView?.mj_footer != nil {
            self.refreshStatus.onNext(LD_RefreshStatus.endFooterRefresh)
            if isEmpty?.count == 0 {
                self.refreshStatus.onNext(LD_RefreshStatus.noMoreData)
            }
        }
    }

    /// 重置颜色
    /// - Parameters:
    ///   - color: 颜色
    ///   - style: 类型
    public func ld_resetTincolor(_ color:UIColor,style:UIActivityIndicatorView.Style){
        (scrollView?.mj_header as! MJRefreshNormalHeader).stateLabel?.textColor = color
        (scrollView?.mj_header as! MJRefreshNormalHeader).loadingView?.style = style
        (scrollView?.mj_footer as! MJRefreshBackNormalFooter).stateLabel?.textColor = color
        (scrollView?.mj_footer as! MJRefreshBackNormalFooter).loadingView?.style = style
    }

    /// 设置空数据时，背景图
    /// - Parameters:
    ///   - tableView: 被添加的UITableView
    ///   - noticeStr: 提示内容
    ///   - clouse: DataSetView需要重新定义
    public func ld_setEmptyView(_ tableView:UIScrollView, _ noticeStr:String? = nil,image:UIImage? = nil,foregroundColor:UIColor = UIColor.white,clouse:((EmptyDataSetView)->Void)? = nil) {

        unowned let weakSelf = self
        tableView.emptyDataSetView { (emptyDataSetView) in
            emptyDataSetView.titleLabelString(NSAttributedString.init(string: (noticeStr != nil) ? noticeStr! : "暂无数据", attributes: [.font:UIFont.systemFont(ofSize: 14,weight: .medium), .foregroundColor:foregroundColor as Any]))
                .image(image)
                .dataSetBackgroundColor(UIColor.white)
                .verticalOffset(0)
                .verticalSpace(15)
                .shouldDisplay(true)
                .shouldFadeIn(true)
                .isTouchAllowed(true)
                .isScrollAllowed(true)
                .didTapContentView {
                    weakSelf.ld_beginRefresh()
                }
            clouse?(emptyDataSetView)
        }
    }

    /// 添加下拉刷新组建
    /// - Parameters:
    ///   - scrollView: 被添加的UITableView
    ///   - footer: 是否有上拉加载
    public func ld_addReresh(_ scrollView:UIScrollView, footer: Bool) {
        self.scrollView = scrollView
        ld_setEmptyView(scrollView)

        if scrollView.mj_header != nil {
            return
        }
        weak var weakSelf = self
        if (footer) {
            self.refreshStatusBind(to: self.scrollView!, {
                weakSelf!.page = 1
                weakSelf!.ld_getData()
            }) {

                do {
                    let status = try weakSelf?.refreshStatus.value()
                    print("--->\(status)")
                    switch status {
                        case .endFooterRefresh:
                            weakSelf!.page += 1
                        default:break
                    }
                    weakSelf!.ld_getData(isHeader: false)
                } catch  {

                }
            }.disposed(by: LD_disposeBag)
        }else {
            self.refreshStatusBind(to: self.scrollView!, {
                weakSelf!.ld_getData()
                weakSelf!.ld_endRefresh()
            }, nil).disposed(by: LD_disposeBag)
        }
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        (scrollView.mj_header as! MJRefreshNormalHeader).lastUpdatedTimeLabel!.isHidden = true
    }
}
