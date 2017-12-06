//
//  EmotionkeyBoardView.swift
//  HTPageViewExample
//
//  Created by emppu－cao on 2017/12/6.
//  Copyright © 2017年 魏小庄. All rights reserved.
//

import UIKit

private let emotionCellID = "emotionCellID"
class EmotionkeyBoardView: UIView {

    fileprivate lazy var titles: [String] = ["普通", "VIP","收藏","斗图"]
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.brown
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmotionkeyBoardView{
    
    fileprivate func setUpUI(){
        let style = HTTitleStyle()
        style.isShowBottomLine = false
        style.isTitleZoom = false
        let layout = HTPageCollectionViewLayout()
        layout.cols = 8
        layout.rows = 3
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
       // 创建表情容器的View。
        let pageCollectionView = HTPageCollectionView(frame: bounds, titles: titles, style: style, isTitleInTop: false, layout: layout)
        addSubview(pageCollectionView)
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        pageCollectionView.register(cell: UICollectionViewCell.self, identifier: emotionCellID)
    }
    
}

extension EmotionkeyBoardView: HTPageCollectionViewDataSource, HTPageCollectionViewDelegate{
    func numberOfSections(in pageCollectionView: HTPageCollectionView) -> Int {
        return titles.count
    }
    func pageCollectionView(_ collectionView: HTPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 10
        case 1:
            return 46
        case 2:
            return 77
        case 3:
            return 91
        default:
            return 30
        }
    }
    
    func pageCollectionView(_ PageCollectionView: HTPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: emotionCellID, for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
    
    func pageCollectionView(_ pageCollectionView: HTPageCollectionView, didSelectedItemAt indexPath: IndexPath) {
        print("\(indexPath)")
    }
}

