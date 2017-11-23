//
//  ViewController.swift
//  HTPageViewExample
//
//  Created by emppu－cao on 2017/11/22.
//  Copyright © 2017年 魏小庄. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let titles = ["aa","bb","cc"]
        let titleStyle = HTTitleStyle()
        var childVc = [UIViewController]()
        for _ in titles {
            let vc = UIViewController()
            childVc.append(vc)
        }
        let pageframe = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 400)
        let  pageView  = HTPageView(frame: pageframe, titles: titles, childVcs: childVc, parentVc: self, titleStyle: titleStyle)
        pageView.backgroundColor = UIColor.yellow
      
        view.addSubview(pageView)
        
    }

}

