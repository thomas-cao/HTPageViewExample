//
//  HTContentView.swift
//  HTPageViewExample
//
//  Created by emppu－cao on 2017/11/22.
//  Copyright © 2017年 魏小庄. All rights reserved.
//

import UIKit

private let kContainerCellID = "kContainerCellID"

protocol HTContentViewDelegate: class {
    func contentView(_ contentView: HTContentView, targetIdx: Int)
    func contentView(_ contentView: HTContentView, targetIdx: Int, progress: CGFloat)
}
class HTContentView: UIView {

    fileprivate var childVcs: [UIViewController]
    fileprivate var parentVc: UIViewController
    fileprivate var isDidingScroll: Bool = false
    fileprivate var progress : CGFloat = 0.0
    fileprivate var targetIdx : Int = 0
    weak var delegate: HTContentViewDelegate?
    fileprivate var startOfSetX: CGFloat = 0
    fileprivate lazy var containerView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.bounds.size
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
       let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContainerCellID)
        return collectionView
    }()
    init(frame: CGRect, childVcs: [UIViewController], parentVc: UIViewController){
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        setUpContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HTContentView {
    fileprivate func setUpContentView(){
        // 添加所有控制器到parentVC中
        for childVc in childVcs {
            parentVc.addChildViewController(childVc)
        }
        // 初始化内容的containerView
        addSubview(containerView)
    }
}

extension HTContentView : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContainerCellID, for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        
        for subview in cell.contentView.subviews{
            subview.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        containerEndScroll()
        scrollView.isScrollEnabled = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            containerEndScroll()
        }else{
            scrollView.isScrollEnabled = false
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDidingScroll = false
        startOfSetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        computationsIndex(scrollView)
    }
    
    private func computationsIndex(_ scrollView: UIScrollView){
        
        guard startOfSetX != scrollView.contentOffset.x, !isDidingScroll else{
            return
        }
        let currentIdx = Int(startOfSetX / scrollView.bounds.width)
        if startOfSetX < scrollView.contentOffset.x { // 左滑动
            targetIdx = currentIdx + 1
            progress = (scrollView.contentOffset.x - startOfSetX) / scrollView.bounds.width
            
        }else{
            
            targetIdx = currentIdx - 1
            progress = (startOfSetX - scrollView.contentOffset.x) / scrollView.bounds.width
        }
        // 限制越界
        if targetIdx >= childVcs.count {
            targetIdx = childVcs.count - 1
        }else if targetIdx <= 0{
            targetIdx = 0
        }
        // 通知代理更改item
        delegate?.contentView(self, targetIdx: targetIdx, progress: progress)
    }
    
    private func containerEndScroll(){
        
        guard !isDidingScroll else {return}
        // 获取当前滑动的idx
        var currentIdx = Int(containerView.contentOffset.x / containerView.bounds.width)
        if currentIdx >= childVcs.count {
            currentIdx = childVcs.count
        }
        delegate?.contentView(self, targetIdx: currentIdx)
    }
    
}

extension HTContentView: HTTitileViewDelegate{
    func titleView(_ titleView: HTTitleView, didSelectedidx: Int) {
        isDidingScroll = true
        let indexPath = IndexPath(item: didSelectedidx, section: 0)
        containerView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}
