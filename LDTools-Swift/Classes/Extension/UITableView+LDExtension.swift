//
//  UITableView+LDExtension.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/2/8.
//

import Foundation

public extension UITableView{

    /// 添加动画
    /// - Parameter type: 动画类型
    func ld_addAni(type:LD_TableAniType){
        DispatchQueue.main.async {
            self.reloadData()
            let cells = self.visibleCells
            var i = 0
            for cell in cells {
                if type == .moveFromLeft{
                    LD_AnisTool.MoveAnimation(cell, Double(LD_ScreenW),i)
                }else if type == .moveFromRight{
                    LD_AnisTool.MoveAnimation(cell, Double(-LD_ScreenW),i)
                }else if type == .fadeDut{
                    cell.alpha = 0
                    LD_AnisTool.FadeDutAnimation(cell, i)
                }else if type == .fadeDut_move{
                    cell.alpha = 0
                    LD_AnisTool.FadeDutAnimationMove(cell,Double(50),i)
                }else if type == .bounds{
                    cell.alpha = 0
                    LD_AnisTool.BoundsAnimation(cell,Double(50),i)
                }else if type == .bothway{
                    cell.alpha = 0
                    LD_AnisTool.BothwayAnimation(cell, Double(LD_ScreenW), i)
                }else if type == .fillOne{
                    LD_AnisTool.FillOneAnimation(cell,Double(50), i)
                }
                i+=1
            }
        }
    }


    /// 此注册于“_nibName”的IDentify格式
    func ld_register(nibName:String){
        register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: "_\(nibName)")
    }
}
