//
//  HTTitleView.swift
//  HTPageViewExample
//
//  Created by emppu－cao on 2017/11/22.
//  Copyright © 2017年 魏小庄. All rights reserved.
//

import UIKit

class HTTitleView: UIView {

    // MARK: - 定义属性
    fileprivate var titles: [String]
    fileprivate var style: HTTitleStyle
    //                   数组名  : 指定数组类型 = 创建数组
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    fileprivate lazy var scrollView : UIScrollView = {
       let scrollView = UIScrollView(frame: self.bounds)
        return scrollView
    }()
    
    init(frame: CGRect, titles: [String], style: HTTitleStyle){
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HTTitleView {
    
    fileprivate func setUpUI(){
        // 添加scrollView
        addSubview(scrollView)
        // 添加lable 到scrollView
        addTitleToScroll()
        // 布局title
        setUpTitlesLayout()
    }
    
    private func addTitleToScroll(){
        for (i, title) in titles.enumerated(){
          // 创建lable
            let titleLable = UILabel()
            titleLable.text = title
            titleLable.textAlignment = .center
            titleLable.tag = i
            titleLable.backgroundColor = UIColor.randomColor()
           scrollView.addSubview(titleLable)
            // 将label添加数组
            titleLabels.append(titleLable)
        }
    }
    
    private func setUpTitlesLayout(){
        
        var x: CGFloat = 0
        let y: CGFloat = 0
        var w: CGFloat = 0
        let h: CGFloat = bounds.size.height
        let titleCount = titleLabels.count
        
        
        for (i, label) in titleLabels.enumerated(){
            
            // 判断是否可以滚动
            if style.isScrollEnable {
                
            }else{
              w = bounds.width / CGFloat(titleCount)
              x = w * CGFloat(i)
            }
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
        }
    }
}
