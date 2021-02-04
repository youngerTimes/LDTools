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
open class JQ_RefreshTVC: LD_BaseVC,LD_Refreshable{
    public var page = 1 //当前页数
    public var totalPages = -1 //总页数
    private var scrollView:UIScrollView?

    public let refreshStatus = BehaviorSubject(value: LD_RefreshStatus.others)

    /// 获取数据
    /// - Parameter isHeader: 是否是头部刷新
    open func ld_getData(isHeader:Bool = true) {
        if isHeader {
            self.page = 1
            self.refreshStatus.onNext(LD_RefreshStatus.beingHeaderRefresh)
        }else {
            if page >= totalPages {
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
    }

    /// 结束刷新数据
    public func ld_endRefresh() {
        self.refreshStatus.onNext(LD_RefreshStatus.endHeaderRefresh)
        if self.scrollView?.mj_footer != nil {
            self.refreshStatus.onNext(LD_RefreshStatus.endFooterRefresh)
        }
    }

    /// 设置空数据时，背景图
    /// - Parameters:
    ///   - tableView: 被添加的UITableView
    ///   - noticeStr: 提示内容
    ///   - clouse: DataSetView需要重新定义
    public func ld_setEmptyView(_ tableView:UITableView, _ noticeStr:String? = nil,image:UIImage? = nil,bgColor:UIColor = UIColor.white,clouse:((EmptyDataSetView)->Void)? = nil) {

        tableView.separatorStyle = .none

        unowned let weakSelf = self
        tableView.emptyDataSetView { (emptyDataSetView) in
            emptyDataSetView.titleLabelString(NSAttributedString.init(string: (noticeStr != nil) ? noticeStr! : "暂无数据", attributes: [.font:UIFont.systemFont(ofSize: 16), .foregroundColor:bgColor as Any]))
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
        if scrollView.mj_header != nil {
            return
        }
        weak var weakSelf = self
        if (footer) {
            self.refreshStatusBind(to: self.scrollView!, {
                weakSelf!.ld_getData()
            }) {
                weakSelf!.ld_getData(isHeader: false)
            }.disposed(by: LD_disposeBag)
        }else {
            self.refreshStatusBind(to: self.scrollView!, {
                weakSelf!.ld_getData()
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
