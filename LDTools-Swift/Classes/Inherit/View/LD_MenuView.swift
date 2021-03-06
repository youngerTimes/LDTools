//
//  LD_MenuView.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/2/4.
//

import Foundation


/// 下拉列表框
public class LD_MenuView: UIView {
    private var handerVC:UIViewController?
    private var topView:UIView?
    private var tableView:UITableView?
    private var tapView:UIView?
    private var items = [String]()
    private var menuClouse:((NSInteger,String)->Void)?
    private var tableWidth = 0
    private var maxHeight:CGFloat?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        self.frame = CGRect(x: 0, y: 0, width: LD_ScreenW, height: LD_ScreenH)
    }

    /// 显示下拉列表
    /// - Parameters:
    ///   - hander: 受处理的控制器
    ///   - tapView: 点击的师徒
    ///   - items: 需要展示的条目
    ///   - clouse: 回调点击的条目的索引和名称
    public func show(_ hander:UIViewController,tapView:UIView?,items:[String],maxHeight:CGFloat? = nil, clouse:@escaping (NSInteger,String)->Void){
        handerVC = hander
        self.tapView = tapView
        self.items = items
        self.maxHeight = maxHeight
        menuClouse = clouse
        let keyWindow  = UIApplication.shared.keyWindow
        keyWindow?.addSubview(self)

        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.separatorStyle = .none
        tableView!.isScrollEnabled = maxHeight != nil ? true:false
        tableView!.register(MenuItemTCell.self, forCellReuseIdentifier: "_MenuItemTCell")
        tableView!.ld_cornerRadius = 8 * LD_RateW
        addSubview(tableView!)

        if tapView == nil{
            tableView!.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-5 * LD_RateW)
                make.top.equalToSuperview().offset(LD_NavBarHeight)
                make.width.greaterThanOrEqualTo(50 * LD_RateW)
                make.height.equalTo(0)
            }
        }else{
            tableView!.snp.makeConstraints { (make) in
                make.centerX.equalTo(tapView!)
                make.top.equalTo(tapView!.snp.bottom).offset(5 * LD_RateW)
                make.width.equalTo(tapView!.ld_width)
                make.height.equalTo(0)
            }
        }
        layoutIfNeeded()

        UIView.animate(withDuration: 0.2) {
            if tapView == nil{
                self.tableView!.snp.remakeConstraints {[weak self](make) in

                    make.right.equalToSuperview().offset(-5 * LD_RateW)
                    make.top.equalToSuperview().offset(LD_NavBarHeight)
                    make.width.greaterThanOrEqualTo(50 * LD_RateW)
                    if maxHeight != nil && CGFloat(46 * items.count) * LD_RateW > maxHeight!{
                        make.height.equalTo(self!.maxHeight ?? 0)
                    }else{
                        make.height.equalTo(CGFloat(46 * items.count) * LD_RateW)
                    }
                }
            }else{
                self.tableView!.snp.remakeConstraints {[weak self](make) in
                    make.centerX.equalTo(tapView!)
                    make.top.equalTo(tapView!.snp.bottom).offset(5 * LD_RateW)
                    make.width.equalTo(tapView!.ld_width)
                    if maxHeight != nil && CGFloat(46 * items.count) * LD_RateW > maxHeight!{
                        make.height.equalTo(self!.maxHeight ?? 0)
                    }else{
                        make.height.equalTo(CGFloat(46 * items.count) * LD_RateW)
                    }
                }
            }
            self.layoutIfNeeded()
        }
    }

    /// 显示下拉列表
    /// - Parameters:
    ///   - hander: 受处理的View
    ///   - tapView: 点击的师徒
    ///   - items: 需要展示的条目
    ///   - clouse: 回调点击的条目的索引和名称
    public func show(_ hander:UIView,tapView:UIView?,items:[String], clouse:@escaping (NSInteger,String)->Void){
        topView = hander
        self.tapView = tapView
        self.items = items
        menuClouse = clouse
        let keyWindow  = UIApplication.shared.keyWindow
        keyWindow?.addSubview(self)

        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.separatorStyle = .none
        tableView!.isScrollEnabled = false
        tableView!.register(MenuItemTCell.self, forCellReuseIdentifier: "_MenuItemTCell")
        tableView!.ld_cornerRadius = 8 * LD_RateW
        addSubview(tableView!)

        if tapView == nil{
            tableView!.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-5 * LD_RateW)
                make.top.equalToSuperview().offset(LD_NavBarHeight)
                make.width.equalTo(tapView!.ld_width)
                make.height.equalTo(0)
            }
        }else{
            tableView!.snp.makeConstraints { (make) in
                make.centerX.equalTo(tapView!)
                make.top.equalTo(tapView!.snp.bottom).offset(5 * LD_RateW)
                make.width.equalTo(tapView!.ld_width)
                make.height.equalTo(0)
            }
        }
        layoutIfNeeded()

        UIView.animate(withDuration: 0.2) {
            if tapView == nil{
                self.tableView!.snp.remakeConstraints { (make) in
                    make.right.equalToSuperview().offset(-5 * LD_RateW)
                    make.top.equalToSuperview().offset(LD_NavBarHeight)
                    make.width.equalTo(tapView!.ld_width)
                    make.height.equalTo(CGFloat(46 * items.count) * LD_RateW)
                }
            }else{
                self.tableView!.snp.remakeConstraints { (make) in
                    make.centerX.equalTo(tapView!)
                    make.top.equalTo(tapView!.snp.bottom).offset(5 * LD_RateW)
                    make.width.equalTo(tapView!.ld_width)
                    make.height.equalTo(CGFloat(46 * items.count) * LD_RateW)
                }
            }
            self.layoutIfNeeded()
        }
    }


    /// 隐藏视图
    public func hiddenView(){
        UIView.animate(withDuration: 0.2) {
            for cell in self.tableView!.visibleCells{
                cell.contentView.alpha = 0
            }
        }

        UIView.animate(withDuration: 0.4, animations: {
            if self.tapView == nil{
                self.tableView!.snp.remakeConstraints { (make) in
                    make.right.equalToSuperview().offset(-5 * LD_RateW)
                    make.top.equalToSuperview().offset(LD_NavBarHeight)
                    make.width.greaterThanOrEqualTo(50 * LD_RateW)
                    make.height.equalTo(0)
                }
            }else{
                self.tableView!.snp.remakeConstraints { (make) in
                    make.centerX.equalTo(self.tapView!)
                    make.top.equalTo(self.tapView!.snp.bottom).offset(5 * LD_RateW)
                    make.width.equalTo(self.tapView!.ld_width)
                    make.height.equalTo(0)
                }
            }
            self.layoutIfNeeded()
        }) { (complete) in
            self.tableView?.snp.removeConstraints()
            self.tableView = nil
            self.removeFromSuperview()
        }
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hiddenView()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        tableView?.ld_shadow(shadowColor: UIColor(hexStr: "#00575E"), corner: 16, opacity: 0.1)
        tableView?.ld_masksToBounds = true

        self.ld_addShadows(shadowColor: UIColor.gray.withAlphaComponent(0.5), corner: 16, radius: 2, offset: self.frame.size, opacity: 1)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LD_MenuView:UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menuClouse?(indexPath.row,items[indexPath.row])
        hiddenView()
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46 * LD_RateW
    }
}

extension LD_MenuView:UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "_MenuItemTCell") as! MenuItemTCell
        cell.itemNameL?.text = items[indexPath.row]
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear

        if indexPath.row == items.count - 1{
            cell.lineView?.alpha = 0
        }

        if maxHeight == nil {
            cell.contentView.alpha = 0
            UIView.animate(withDuration: 0.1, delay: 0.05 + Double(indexPath.row)/25, options: .layoutSubviews, animations: {
                cell.contentView.alpha = 1
            }) { (complete) in

            }
        }

        return cell
    }
}

public class MenuItemTCell:UITableViewCell{

    var itemNameL:UILabel!
    var lineView:UIView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        itemNameL = UILabel()
        itemNameL.font = UIFont.systemFont(ofSize: 13)
        itemNameL.textAlignment = .center
        contentView.addSubview(itemNameL)
        itemNameL.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(10 * LD_RateW)
            make.bottom.equalTo(-10 * LD_RateW)
        }

        lineView = UIView()
        lineView.backgroundColor = UIColor(hexStr: "E9EBF2")
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10 * LD_RateW, bottom: 0, right: 10 * LD_RateW))
            make.height.equalTo(0.5 * LD_RateW)
            make.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
