//
//  LDGuideVC.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/2/8.
//

import UIKit

public protocol LD_GuideDelegate:NSObject{
    func currtentPage(page:Int,imgView:UIImageView) //当前页
    func guideImagesView(imgView:[UIImageView]) //画廊每一个图片
    func browseComplete() //浏览完成
}

/**
 ## 启动时的向导页 ##
 如果需要改进，可以继承并改动

 */
public class LDGuideVC: UIViewController{

    //向导页的图片
    public private(set) var guideImages = [UIImage]()
    public var imgsView = [UIImageView]()
    public weak var delegate:LD_GuideDelegate?
    private let scrollView = UIScrollView()
    private var pageControl:UIPageControl?


    public convenience init(_ images:[UIImage],showPageControl:Bool = false){
        self.init()
        guideImages = images

        if showPageControl {
            pageControl = UIPageControl(frame: CGRect.zero)
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.setStatusBarHidden(true, with: .fade)
    }

    public override var prefersStatusBarHidden: Bool{
        return true
    }

    public override func viewDidLoad(){
        super.viewDidLoad()

        let frame = LD_KeyWindow.frame
        //scrollView的初始化
        scrollView.frame = frame
        scrollView.delegate = self
        //为了能让内容横向滚动，设置横向内容宽度为3个页面的宽度总和
        scrollView.contentSize = CGSize(width:frame.size.width * CGFloat(guideImages.count),height:frame.size.height)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false

        for (index,img) in guideImages.enumerated() {
            let imgView = UIImageView(image: img)
            imgView.contentMode = .scaleToFill
            imgView.frame = CGRect(x:frame.size.width*CGFloat(index), y:CGFloat(0),
                                   width:frame.size.width, height:frame.size.height)
            scrollView.addSubview(imgView)
            imgsView.append(imgView)
        }

        scrollView.contentOffset = CGPoint.zero
        self.view.addSubview(scrollView)
        delegate?.guideImagesView(imgView: imgsView)

        if pageControl != nil {
            pageControl?.currentPage = 0
            pageControl?.numberOfPages = guideImages.count
            view.addSubview(pageControl!)
            pageControl?.snp.makeConstraints({ (make) in
                make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom:0, right: 20))
                make.bottom.equalTo(-(LD_SafeEdges.bottom + 20))
                make.height.equalTo(50)
            })
        }
    }

    public func loadAtWindow(){
        if let window = UIApplication.shared.keyWindow{
            window.addSubview(self.view)
            self.view.frame = window.frame
        }
    }

    public func hiddenGuide(_ withDuration:TimeInterval = 2.0){
        UIView.animate(withDuration: withDuration) {
            self.view.alpha = 0
        } completion: { (complete) in
            self.removeFromParent()
        }
    }
}

extension LDGuideVC:UIScrollViewDelegate{
    //scrollview滚动的时候就会调用
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
        let page = Int(scrollView.contentOffset.x/self.view.bounds.size.width)
        pageControl?.currentPage = page
        delegate?.currtentPage(page: page, imgView: imgsView[page])
        let twidth = CGFloat(guideImages.count-1) * self.view.bounds.size.width
        //如果在最后一个页面继续滑动的话就会跳转到主页面
        if(scrollView.contentOffset.x >= twidth)
        {
            self.delegate?.browseComplete()
        }
    }
}
