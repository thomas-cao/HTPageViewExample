//
//  HTTitleView.swift
//  HTPageViewExample
//
//  Created by 魏小庄 on 2017/11/22.
//  Copyright © 2017年 魏小庄. All rights reserved.
//

import UIKit
// 定义代理
protocol HTTitileViewDelegate: class {
    func titleView(_ titleView: HTTitleView, didSelectedidx: Int) -> ()
}

private let zoomScale : CGFloat = 0.2
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
    fileprivate lazy var bottomLine: UIView = {
       let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.frame.size.height = self.style.bottomLineHeight
        bottomLine.frame.origin.y = self.bounds.height - self.style.bottomLineHeight
        return bottomLine
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
        // 添加滚动条
        if style.isShowBottomLine {
            scrollView.addSubview(bottomLine)
        }
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
                    if style.isShowBottomLine{
                        bottomLine.frame.origin.x = x
                        bottomLine.frame.size.width = w
                    }
                }else{
                    x = titleLabels[i - 1].frame.maxX + style.itemMargin
                }
            }else{
              w = bounds.width / CGFloat(titleCount)
              x = w * CGFloat(i)
                if style.isShowBottomLine {
                    bottomLine.frame.origin.x = 0
                    bottomLine.frame.size.width = w
                }
            }
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
            
            if i == 0 && style.isTitleZoom{
                label.transform = CGAffineTransform(scaleX: 1.0 + zoomScale, y: 1.0 + zoomScale)
            }
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
        if style.isShowBottomLine{
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.size.width
            })
        }
        delegate?.titleView(self, didSelectedidx: targetLabel.tag)
    }
    
    // 对外暴露
     func adjustTitleLable(_ targetIdx: Int){
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
        if style.isTitleZoom {
            UIView.animate(withDuration: 0.25, animations: {
                targetLable.transform = CGAffineTransform(scaleX: 1.0 + zoomScale, y: 1.0 + zoomScale)
                sourceLabel.transform = CGAffineTransform.identity
            })
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
        if style.isShowBottomLine {
            let deltaX = targetLable.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW =  targetLable.frame.size.width - sourceLabel.frame.size.width
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            bottomLine.frame.size.width = sourceLabel.frame.size.width + deltaW * progress
        }
       
        if style.isTitleZoom {
            let targetScale = 1.0 + progress * zoomScale
            targetLable.transform = CGAffineTransform(scaleX:targetScale, y: targetScale)
            let soucrScale = (1.0 + zoomScale) - (progress * 0.2)
            sourceLabel.transform = CGAffineTransform(scaleX: soucrScale, y: soucrScale)
            
        }
    }
}

