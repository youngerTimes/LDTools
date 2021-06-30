//
//  LD_baseTableView.swift
//  Differentiator
//
//  Created by 无故事王国 on 2021/6/29.
//

import UIKit

open class LD_BaseTableView: UITableView {
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        separatorStyle = .none
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        separatorStyle = .none
    }


    open override func awakeFromNib() {
        super.awakeFromNib()
        separatorStyle = .none
    }
}
