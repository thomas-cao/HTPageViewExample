//
//  chatToolsView.swift
//  HTPageViewExample
//
//  Created by emppu－cao on 2017/12/6.
//  Copyright © 2017年 魏小庄. All rights reserved.
//

import UIKit

class chatToolsView: UIView {

    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
   
    fileprivate lazy var emotionView: EmotionkeyBoardView = EmotionkeyBoardView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 250))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 设置输入框
        setUpInputTextUI()
    }
  
    private func setUpInputTextUI(){
        
        let changeBtn = UIButton()
        changeBtn.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        changeBtn.setImage(UIImage.init(named: "chat_btn_emoji") , for: .normal)
        changeBtn.setImage(UIImage.init(named: "chat_btn_keyboard") , for: .selected)
        changeBtn.addTarget(self, action: #selector(changeEmojiOrKeyboard(_:)), for: .touchUpInside)
        inputTextField.rightViewMode = .always
       inputTextField.rightView = changeBtn
        
    }
   
}

extension chatToolsView{
    
    class func loadForNib() -> chatToolsView{
        
        return Bundle.main.loadNibNamed("chatToolsView", owner: nil, options: nil)?.first as! chatToolsView
    }
    
    // MARK: - methods
    @objc fileprivate func changeEmojiOrKeyboard(_ btn: UIButton){
        btn.isSelected = !btn.isSelected
        
        // 切换键盘
        inputTextField.resignFirstResponder()
        inputTextField.inputView = inputTextField.inputView == nil ? emotionView : nil
        
        inputTextField.becomeFirstResponder()
    }
    
    @IBAction func textFiledDidEndChange(_ sender: UITextField) {
        sendBtn.isEnabled = sender.text!.count != 0
    }
}
