//
//  ViewController.swift
//  HTPageViewExample
//
//  Created by 魏小庄 on 2017/11/22.
//  Copyright © 2017年 魏小庄. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        let titles = ["aa","bb","cc"]
        let titles = ["美女","段子","特大新闻","我","清凉一夏","直播中"];
        
        let titleStyle = HTTitleStyle()
        titleStyle.isScrollEnable = true
//        titleStyle.normalTextColor = UIColor.yellow
        titleStyle.selectedTextColor = UIColor.purple
        titleStyle.titleFont = UIFont.boldSystemFont(ofSize: 16)

        var childVc = [UIViewController]()
//        for _ in titles {
//            let vc = UIViewController()
//            childVc.append(vc)
//        }
        
        let vc1 = ViewController1()
        childVc.append(vc1)
        let vc2 = ViewController2()
        childVc.append(vc2)
        let vc3 = ViewController3()
        childVc.append(vc3)
        let vc4 = ViewController4()
        childVc.append(vc4)
        let vc5 = ViewController5()
        childVc.append(vc5)

        let vc6 = ViewController6()
        childVc.append(vc6)
        
        let pageframe = CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height - 64)
        let  pageView  = HTPageView(frame: pageframe, titles: titles, childVcs: childVc, parentVc: self, titleStyle: titleStyle)
        pageView.backgroundColor = UIColor.yellow
      
        view.addSubview(pageView)
        
    }

}

