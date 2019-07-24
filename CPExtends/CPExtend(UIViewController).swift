//
//  CPExtend(ViewController).swift
//  swift-OC
//
//  Created by mac on 2019/5/5.
//  Copyright © 2019年 bo. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    struct AssociatedKey {
        static var isBackRefresh = "isBackRefresh";
        static var isNeedRefresh = "isNeedRefresh";
    }
    typealias IsUseRefresh = (Any?) -> Void
    
    // 属否需要返回刷新回调(相当于OC的block)
    var isBackRefresh : IsUseRefresh? {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.isBackRefresh, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.isBackRefresh) as? IsUseRefresh
        }
    }
    // 是否需要刷新当前页面
    var isNeedRefresh : Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.isNeedRefresh, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.isNeedRefresh) as? Bool ?? false
        }
    }
}

extension UIViewController {
    public typealias AlertClickAction = (_ alertAction: UIAlertAction, _ idx: Int) -> Void;
    // 弹出提示框
    public func show(_message: String? = nil, _title: String? = nil, _delay: Int = 0, _buttonTitles: [String]?, _result: AlertClickAction? = nil) {
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.alert)
        var isCancelAction: Bool = false;
        if let _ = _buttonTitles {
            for (idx, title) in _buttonTitles!.enumerated() {
                var action: UIAlertAction?;
                if title == "取消" {
                    isCancelAction = true;
                    action = UIAlertAction(title: title, style: .cancel) { (alertAction) in
                        if let _ = _result {
                            _result!(alertAction, 0);
                        }
                    }
                } else {
                    let finalIdx = isCancelAction ? idx : (idx+1);
                    action = UIAlertAction(title: title, style: .default) { (alertAction) in
                        if let _ = _result {
                            _result!(alertAction, finalIdx);
                        }
                    }
                }
                alert.addAction(action!);
            }
        }
        self.present(alert, animated: true, completion: nil)
        if _delay != 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(integerLiteral: _delay)) {
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
