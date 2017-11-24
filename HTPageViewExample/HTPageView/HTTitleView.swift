//
//  HTTitleView.swift
//  HTPageViewExample
//
//  Created by emppu－cao on 2017/11/22.
//  Copyright © 2017年 魏小庄. All rights reserved.
//

import UIKit
// 定义代理
protocol HTTitileViewDelegate: class {
    func titleView(_ titleView: HTTitleView, didSelectedidx: Int) -> ()
}

class HTTitleView: UIView {

    // MARK: - 定义属性
    fileprivate var titles: [String]
    fileprivate var style: HTTitleStyle
    weak var delegate: HTTitileViewDelegate?
    fileprivate var currentIdx : Int = 0
    //                   数组名  : 指定数组类型 = 创建数组
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    fileprivate lazy var scrollView : UIScrollView = {
       let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
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
            titleLable.font = style.titleFont
            titleLable.textColor = i == 0 ? style.selectedTextColor : style.normalTextColor
            titleLable.tag = i
           scrollView.addSubview(titleLable)
            // 将label添加数组
            titleLabels.append(titleLable)
            // 给label添加点击手势
            let tapGse = UITapGestureRecognizer(target: self, action: #selector(titleItemClick(_:)))
            titleLable.isUserInteractionEnabled = true
            titleLable.addGestureRecognizer(tapGse)
            
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
                // 根据文字多少计算宽度
                w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : label.font], context: nil).width
                // 计算x
                if i == 0{
                    x = style.itemMargin * 0.5
                }else{
                    x = titleLabels[i - 1].frame.maxX + style.itemMargin
                }
            }else{
              w = bounds.width / CGFloat(titleCount)
              x = w * CGFloat(i)
            }
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        scrollView.contentSize = style.isScrollEnable ? CGSize(width: titleLabels.last!.frame.maxX + style.itemMargin * 0.5, height: 0) : CGSize.zero
    }
}
// MARK: - 监听点击事件
extension HTTitleView{
    
    @objc fileprivate func titleItemClick(_ tapges: UITapGestureRecognizer){
        // 获取点击的view
        let targetLabel =  tapges.view as! UILabel
        
        adjustTitleLable(targetLabel.tag)
        delegate?.titleView(self, didSelectedidx: targetLabel.tag)
    }
    
    fileprivate func adjustTitleLable(_ targetIdx: Int){
        if targetIdx == currentIdx {return}
        // 取出label
        let targetLable = titleLabels[targetIdx]
        // 上一次选中的
        let sourceLabel = titleLabels[currentIdx]
        targetLable.textColor = style.selectedTextColor
        sourceLabel.textColor = style.normalTextColor
        currentIdx = targetIdx
        // 调整位置
        if style.isScrollEnable {
            var offsetX = targetLable.center.x - scrollView.bounds.width * 0.5
            if offsetX < 0{
                offsetX = 0
            }
            if offsetX > (scrollView.contentSize.width - scrollView.bounds.width){
                offsetX = scrollView.contentSize.width - scrollView.bounds.width
            }
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
}

extension HTTitleView: HTContentViewDelegate{
    
    func contentView(_ contentView: HTContentView, targetIdx: Int) {
        adjustTitleLable(targetIdx)
    }
    func contentView(_ contentView: HTContentView, targetIdx: Int, progress: CGFloat) {
        // 取出label
        let targetLable = titleLabels[targetIdx]
        // 上一次选中的
        let sourceLabel = titleLabels[currentIdx]
        // 设置颜色渐变
        let daltaRGB = UIColor.getRGBDelta(style.selectedTextColor, seccondColor: style.normalTextColor)
        let selectRGB = style.selectedTextColor.getRGB()
        let normalRGB = style.normalTextColor.getRGB()
        
        targetLable.textColor = UIColor(r: normalRGB.0 + daltaRGB.0 * progress, g: normalRGB.1 + daltaRGB.1 * progress, b: normalRGB.2 + daltaRGB.2 * progress)
        
        sourceLabel.textColor = UIColor(r: selectRGB.0 - daltaRGB.0 * progress, g: selectRGB.1 - daltaRGB.1 * progress, b: selectRGB.2 - daltaRGB.2 * progress)

    }
}

