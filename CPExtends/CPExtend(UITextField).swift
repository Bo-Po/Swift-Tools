//
//  CPExtend(UITextField).swift
//  swift-OC
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019年 bo. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    struct AssociatedKey {
        static var clickBothEndsAction = "clickBothEndsAction";
        static var didTextChange = "didTextChange";
        static var leftCanClick = "leftCanClick";
        static var rightCanClick = "rightCanClick";
        static var maxLength = "maxLength";
        static var maxCharLength = "maxCharLength";
        static var maxByteLength = "maxByteLength";
    }
}

extension UITextField {
    // 设置两端图片(可IB设置)
    @IBInspectable var leftImage : UIImage? {
        set {
            let sender = UIButton(frame: CGRect(x: 0, y: 4, width: bounds.size.height - 8, height: bounds.size.height - 8));
            sender.setImage(newValue, for: .normal);
            sender.tag = 10;
            leftView = sender;
            leftViewMode = .always;
        }
        get {
            return (leftView as! UIButton).imageView!.image;
        }
    }
    @IBInspectable var rightImage : UIImage? {
        set {
            let sender = UIButton(frame: CGRect(x: 0, y: 4, width: bounds.size.height - 8, height: bounds.size.height - 8));
            sender.setImage(newValue, for: .normal);
            sender.tag = 11;
            rightView = sender;
            rightViewMode = .always;
        }
        get {
            return (rightView as! UIButton).imageView!.image;
        }
    }
    
    // 控制两端是否可点 (默认可点)(可IB设置)
    @IBInspectable var leftCanClick : Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.leftCanClick, newValue, .OBJC_ASSOCIATION_ASSIGN)
            (leftView as! UIButton).isUserInteractionEnabled = newValue;
        }
        get {
            return (objc_getAssociatedObject(self, &AssociatedKey.leftCanClick) != nil)
        }
    }
    @IBInspectable var rightCanClick : Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.rightCanClick, newValue, .OBJC_ASSOCIATION_ASSIGN)
            (rightView as! UIButton).isUserInteractionEnabled = newValue;
        }
        get {
            return (objc_getAssociatedObject(self, &AssociatedKey.rightCanClick) != nil)
        }
    }
    
}

extension UITextField {
    typealias ClickBackAction = (_ sender:UIButton)->Void;
    // 点击两端回调(相当于OC的block)
    var clickBothEndsAction : ClickBackAction? {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.clickBothEndsAction, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            (leftView as! UIButton).addTarget(self, action: #selector(UITextField.clickBothAction(sender:)), for: .touchUpInside);
            (rightView as! UIButton).addTarget(self, action: #selector(UITextField.clickBothAction(sender:)), for: .touchUpInside);
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.clickBothEndsAction) as? ClickBackAction
        }
    }
    
    @objc func clickBothAction(sender:UIButton) -> Void {
        if let block = clickBothEndsAction {
            block(sender);
        }
    }
    
}

extension UITextField {
    typealias ValueChangeAction = (_ text:String?)->Void;
    // 输入框内容变化时执行 (didTextChange 相当于OC 的block) ，销毁前记得置空，否则通知无法销毁
    var didTextChange : ValueChangeAction? {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.didTextChange, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            if let _ = newValue {
                NotificationCenter.default.addObserver(self, selector: #selector(UITextField.textFieldTextDidChange(sender:)), name: .UITextFieldTextDidChange, object: nil);
            } else {
                NotificationCenter.default.removeObserver(self, name: .UITextFieldTextDidChange, object: nil);
            }
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.didTextChange) as? ValueChangeAction
        }
    }
    
    @objc func textFieldTextDidChange(sender: Notification) {
        if let _ = text {
            guard let _: UITextRange = self.markedTextRange else {
                var str = Substring(text!);
                if maxLength != 0 {
                    while UInt64(text!.count) > maxLength {
                        str = str.prefix(Int(maxLength));
                    }
                    text = String(str);
                    print("self.text.length   ===   "+"\(text!.count)")
                }
                if maxCharLength != 0 {
                    while text!.charLength() > maxCharLength {
                        str = str.prefix(text!.count-1);
                        text = String(str);
                    }
                    print("self.text.charLength   ===   "+"\(text!.charLength())")
                }
                if maxByteLength != 0 {
                    while text!.lengthOfBytes(using: .utf8) > maxByteLength {
                        str = str.prefix(text!.count-1);
                    }
                    text = String(str);
                    print("self.text.byteLength   ===   "+"\(text!.lengthOfBytes(using: .utf8))")
                }
                if let block = didTextChange {
                    block(text);
                }
                return;
            }
        }
    }
}

extension UITextField {
    /// 设置了这三个属性 则必须实现 didTextChange
    // 最大字符数 (直接 eg. text.count)(可IB设置)
    @IBInspectable var maxLength : UInt64 {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.maxLength, newValue, .OBJC_ASSOCIATION_ASSIGN)
            objc_setAssociatedObject(self, &AssociatedKey.maxCharLength, 0, .OBJC_ASSOCIATION_ASSIGN)
            objc_setAssociatedObject(self, &AssociatedKey.maxByteLength, 0, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return (objc_getAssociatedObject(self, &AssociatedKey.maxLength) ?? 0) as! UInt64
        }
    }
    // 最大字符数 (1 个汉字 = 2 个字符数)(可IB设置)
    @IBInspectable var maxCharLength : UInt64 {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.maxLength, 0, .OBJC_ASSOCIATION_ASSIGN)
            objc_setAssociatedObject(self, &AssociatedKey.maxCharLength, newValue, .OBJC_ASSOCIATION_ASSIGN)
            objc_setAssociatedObject(self, &AssociatedKey.maxByteLength, 0, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return (objc_getAssociatedObject(self, &AssociatedKey.maxCharLength) ?? 0) as! UInt64
        }
    }
    // 最大字节数 (1 个汉字 = 3 个字节数)(可IB设置)
    @IBInspectable var maxByteLength : UInt64 {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.maxLength, 0, .OBJC_ASSOCIATION_ASSIGN)
            objc_setAssociatedObject(self, &AssociatedKey.maxCharLength, 0, .OBJC_ASSOCIATION_ASSIGN)
            objc_setAssociatedObject(self, &AssociatedKey.maxByteLength, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return (objc_getAssociatedObject(self, &AssociatedKey.maxByteLength) ?? 0) as! UInt64
        }
    }
    
}
