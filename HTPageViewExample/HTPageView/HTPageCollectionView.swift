//
//  HTPageCollectionView.swift
//  HTPageViewExample
//
//  Created by emppu－cao on 2017/12/6.
//  Copyright © 2017年 魏小庄. All rights reserved.
//

import UIKit


protocol HTPageCollectionViewDataSource: NSObjectProtocol {
    
    func numberOfSections(in pageCollectionView: HTPageCollectionView) -> Int
    func pageCollectionView(_ collectionView: HTPageCollectionView, numberOfItemsInSection section: Int) -> Int
    func pageCollectionView(_ PageCollectionView: HTPageCollectionView,_  collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}
protocol HTPageCollectionViewDelegate: NSObjectProtocol {
    func pageCollectionView(_ pageCollectionView: HTPageCollectionView, didSelectedItemAt indexPath: IndexPath)
}

class HTPageCollectionView: UIView {
    fileprivate var style: HTTitleStyle
    fileprivate var isTitleInTop: Bool
    fileprivate var titles: [String]
    fileprivate var layout: HTPageCollectionViewLayout
    fileprivate var pageControl: UIPageControl!
    fileprivate var collectionView: UICollectionView!
    fileprivate var titleView: HTTitleView!
    // 记录当前的section
    fileprivate var sourceIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    weak var dataSource: HTPageCollectionViewDataSource?
    weak var delegate: HTPageCollectionViewDelegate?
    init(frame: CGRect, titles: [String], style: HTTitleStyle, isTitleInTop: Bool , layout: HTPageCollectionViewLayout) {
        self.style = style
        self.isTitleInTop = isTitleInTop
        self.titles = titles
        self.layout = layout
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension HTPageCollectionView{
    
  fileprivate func setUpUI() {
    
        // 创建ttitleView
    let titleY = isTitleInTop ? 0 : bounds.height - style.titleViewHeight
    
    let titleRect = CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleViewHeight)
    titleView = HTTitleView(frame: titleRect, titles: titles, style: style)
    titleView.delegate = self
    addSubview(titleView)
    
    // 添加pageControl
    let pageHeight: CGFloat = 20
    let pageY = isTitleInTop ? (bounds.height -  pageHeight) : (bounds.height - style.titleViewHeight - pageHeight)
    let pageRect = CGRect(x: 0, y: pageY, width: bounds.width, height: pageHeight)
    pageControl = UIPageControl.init(frame: pageRect)
    pageControl.numberOfPages = 4
    pageControl.pageIndicatorTintColor = UIColor.gray
    pageControl.currentPageIndicatorTintColor = .red
    pageControl.isEnabled = false
    addSubview(pageControl)
    
    
    // 添加cllection
    let collectionY = isTitleInTop ? style.titleViewHeight : 0
    
    let collectionFrame = CGRect(x: 0, y: collectionY, width: bounds.width, height: bounds.height - style.titleViewHeight - pageHeight)
    collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
    addSubview(collectionView)
    pageControl.backgroundColor = collectionView.backgroundColor
    
    }
}
//MARK: - 对外暴露的方法
extension HTPageCollectionView{
    public func register(cell: AnyClass?, identifier: String){
        collectionView.register(cell, forCellWithReuseIdentifier: identifier)
    }
    
   public func register(nib: UINib, identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    public func reloadData(){
        collectionView.reloadData()
    }
    
}


extension HTPageCollectionView: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        if section == 0{
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
        }
        return itemCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageCollectionView(self, collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionView(self, didSelectedItemAt: indexPath)
    }
    
    // 监听拖拽
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewEndScroll()
    }
    
    // 修改拖拽后的UI
    fileprivate func scrollViewEndScroll(){
        // 取出在屏幕中显示的cell
        let  point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else{return}
        // 进入下一组
        if sourceIndexPath.section != indexPath.section {
            // 修改pageControl的个数\
        let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1

            // 设置titleView选中
            titleView.adjustTitleLable(indexPath.section)
            
            // 记录最新的indexPath
            sourceIndexPath = indexPath
        }
        pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
        
    }
}

extension HTPageCollectionView: HTTitileViewDelegate{
    
    func titleView(_ titleView: HTTitleView, didSelectedidx: Int) {
        let index = IndexPath(item: 0, section: didSelectedidx)
        collectionView.scrollToItem(at: index, at: .left, animated: false)
        collectionView.contentOffset.x -= layout.sectionInset.left
        scrollViewEndScroll()
    }
}
