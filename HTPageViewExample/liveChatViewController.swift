//
//  liveChatViewController.swift
//  HTPageViewExample
//
//  Created by 魏小庄 on 2017/12/6.
//  Copyright © 2017年 魏小庄. All rights reserved.
//

import UIKit

private let chatToolsHeight: CGFloat = 45
private let kscreenH : CGFloat = UIScreen.main.bounds.height
class liveChatViewController: UIViewController {

    fileprivate lazy var chatTools: chatToolsView = chatToolsView.loadForNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       title = "直播"
        chatTools.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: chatToolsHeight)
        chatTools.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        view.addSubview(chatTools)
        
        // 监听键盘frame改变的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatTools.inputTextField.resignFirstResponder()
    }
    
    // 聊天
    @IBAction func chatClick(_ sender: Any) {
      chatTools.inputTextField.becomeFirstResponder()
    }
    // 送礼物
    @IBAction func sendGift(_ sender: Any) {
    }
    //  喜欢
    @IBAction func likeClick(_ sender: Any) {
        
        
    }
    
}

extension liveChatViewController{
    
    @objc fileprivate func keyboardWillChange(_ note: NSNotification){
        
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey]as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - chatToolsHeight
        
    
    UIView.animate(withDuration: duration) {
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 5)!)
        let endY = inputViewY == (kscreenH - chatToolsHeight) ? kscreenH : inputViewY
        self.chatTools.frame.origin.y = endY
    }
        
    }
}

