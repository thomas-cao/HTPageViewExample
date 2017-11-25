//
//  UIColor+Extension.swift
//  HTPageViewExample
//
//  Created by emppu－cao on 2017/11/22.
//  Copyright © 2017年 魏小庄. All rights reserved.
//

import UIKit

extension UIColor {
   
    // 扩展便利构造函数
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
    
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    class func getRGBDelta(_ firstColor: UIColor, seccondColor: UIColor) -> (CGFloat, CGFloat, CGFloat) {
    
        let firstColor = firstColor.getRGB()
        let secondColor = seccondColor.getRGB()
        return (firstColor.0 - secondColor.0, firstColor.1 - secondColor.1, firstColor.2 - secondColor.2)
    }
    
    func getRGB() -> (CGFloat, CGFloat, CGFloat) {
        guard let cmps = cgColor.components else {
             fatalError("保证普通颜色是RGB方式传入")
        }
        
        return (cmps[0] * 255, cmps[1] * 255, cmps[2] * 255)
    }
    
}
