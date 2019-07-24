//
//  CPExtend(UIView).swift
//  swift-OC
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019年 bo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    struct AssociatedKey {
        static var toucheDelegate = "toucheDelegate";
        static var isAllowTouche = "isAllowTouche";
        static var startPoint = "startPoint";
        static var cp_showLine = "cp_showLine";
        static var cp_lineLayer = "cp_lineLayer";
        static var cp_edgeInset = "cp_edgeInset";
    }
}

extension UIView {
    var cp_x: Float {
        set {
            frame.origin.x = CGFloat(newValue);
        }
        get {
            return Float(frame.origin.x);
        }
    }
    var cp_y: Float {
        set {
            frame.origin.y = CGFloat(newValue);
        }
        get {
            return Float(frame.origin.y);
        }
    }
    var cp_right: Float {
        set {
            frame.origin.x = CGFloat(newValue)-frame.size.width;
        }
        get {
            return Float(frame.origin.x+frame.size.width);
        }
    }
    var cp_bottom: Float {
        set {
            frame.origin.y = CGFloat(newValue)-frame.size.height;
        }
        get {
            return Float(frame.origin.y+frame.size.height);
        }
    }
    var cp_width: Float {
        set {
            frame.size.width = CGFloat(newValue);
            if cp_lineLayer != nil {
                if cp_edgeInset != nil {
                    cp_lineLayer!.frame = CGRect(x: cp_edgeInset!.left, y: CGFloat(cp_heigth-0.25), width: CGFloat(newValue)-cp_edgeInset!.left-cp_edgeInset!.right, height: 0.5);
                } else {
                    cp_lineLayer!.frame = CGRect(x: 0, y: CGFloat(cp_heigth-0.25), width: CGFloat(newValue), height: 0.5);
                }
            }
        }
        get {
            return Float(frame.size.width);
        }
    }
    var cp_heigth: Float {
        set {
            frame.size.height = CGFloat(newValue);
            if cp_lineLayer != nil {
                if cp_edgeInset != nil {
                    cp_lineLayer!.frame = CGRect(x: cp_edgeInset!.left, y: CGFloat(newValue-0.25), width: CGFloat(cp_width)-cp_edgeInset!.left-cp_edgeInset!.right, height: 0.5);
                } else {
                    cp_lineLayer!.frame = CGRect(x: 0, y: CGFloat(newValue-0.25), width: CGFloat(cp_width), height: 0.5);
                }
            }
        }
        get {
            return Float(frame.size.height);
        }
    }
    var cp_origin: CGPoint {
        set {
            frame.origin = newValue;
        }
        get {
            return frame.origin;
        }
    }
    var cp_size: CGSize {
        set {
            frame.size = newValue;
            if cp_lineLayer != nil {
                if cp_edgeInset != nil {
                    cp_lineLayer!.frame = CGRect(x: cp_edgeInset!.left, y: CGFloat(newValue.height-0.25), width: CGFloat(newValue.width)-cp_edgeInset!.left-cp_edgeInset!.right, height: 0.5);
                } else {
                    cp_lineLayer!.frame = CGRect(x: 0, y: CGFloat(newValue.height-0.25), width: CGFloat(newValue.width), height: 0.5);
                }
            }
        }
        get {
            return frame.size;
        }
    }
    var cp_centerX: Float {
        set {
            center.x = CGFloat(newValue);
        }
        get {
            return Float(center.x);
        }
    }
    var cp_centerY: Float {
        set {
            center.y = CGFloat(newValue);
        }
        get {
            return Float(frame.origin.y+frame.size.height);
        }
    }
    /// 锚点 ( anchorPoint中的X,Y表示锚点的x,y的相对距离比例值 )
    var cp_anchor: CGPoint {
        set {
            layer.anchorPoint = newValue;
        }
        get {
            return layer.anchorPoint;
        }
    }
    /// position ( position中的X,Y表示sublay锚点相对于supLayer的左上角的距离 )
    var cp_position: CGPoint {
        set {
            layer.position = newValue;
        }
        get {
            return layer.position;
        }
    }
}

extension UIView {
    @IBInspectable var cp_showLine : Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.cp_showLine, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if cp_lineLayer == nil {
                cp_lineLayer = CALayer();
                layoutIfNeeded();setNeedsLayout();
                cp_lineLayer!.backgroundColor = cp_color_line.cgColor;
                layer.addSublayer(cp_lineLayer!);
            }
            self.cp_lineLayer?.isHidden = !newValue;
            if cp_edgeInset != nil {
                cp_lineLayer!.frame = CGRect(x: cp_edgeInset!.left, y: CGFloat(cp_heigth-0.25), width: CGFloat(self.cp_width)-cp_edgeInset!.left-cp_edgeInset!.right, height: 0.5);
            } else {
                cp_lineLayer!.frame = CGRect(x: 0, y: CGFloat(cp_heigth-0.25), width: CGFloat(self.cp_width), height: 0.5);
            }
        }
        get {
            return (objc_getAssociatedObject(self, &AssociatedKey.cp_showLine) != nil)
        }
    }
    var cp_lineLayer : CALayer? {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.cp_lineLayer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.cp_lineLayer) as? CALayer;
        }
    }
    var cp_edgeInset : UIEdgeInsets? {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.cp_edgeInset, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if cp_lineLayer != nil {
                if newValue != nil {
                    cp_lineLayer!.frame = CGRect(x: newValue!.left, y: CGFloat(cp_heigth-0.25), width: CGFloat(self.cp_width)-newValue!.left-newValue!.right, height: 0.5);
                } else {
                    cp_lineLayer!.frame = CGRect(x: 0, y: CGFloat(cp_heigth-0.25), width: CGFloat(self.cp_width), height: 0.5);
                }
            }
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.cp_edgeInset) as? UIEdgeInsets;
        }
    }
    
}

extension UIView {
    // 圆角、边框、边框颜色(可IB设置)
    @IBInspectable var cornerRadius : CGFloat {
        set {
            layer.masksToBounds = (newValue>0.0);
            layer.cornerRadius = newValue;
        }
        get {
            return layer.cornerRadius;
        }
    }
    @IBInspectable var borderWidth : CGFloat {
        set {
            layer.borderWidth = newValue;
        }
        get {
            return layer.borderWidth;
        }
    }
    @IBInspectable var borderColor : UIColor? {
        set {
            layer.borderColor = newValue!.cgColor;
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color);
            }
            else {
                return nil;
            }
        }
    }
    
}

extension UIView {
    // 添加约束(推荐使用第三方库)
    func cp_markConstraint(markView:(_ mark: UIView)-> [NSLayoutConstraint]) -> Void {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = markView(self);
        for constraint in constraints {
            if (constraint.firstItem?.isEqual(self))! {
                if let _ = constraint.secondItem {
                    if (constraint.secondItem?.isEqual(self))! {
                        addConstraint(constraint)
                    } else {
                        superview!.addConstraint(constraint)
                    }
                } else {
                    addConstraint(constraint)
                }
            } else {
                superview!.addConstraint(constraint)
            }
        }
    }
}

protocol UIViewToucheDelegate: NSObjectProtocol {
    func toucheView(_ view: UIView, didMoved startPoint: CGPoint, toPoint: CGPoint);
    func toucheView(_ view: UIView, didEnd point: CGPoint);
}

extension UIView {
    weak var toucheDelegate: UIViewToucheDelegate? {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.toucheDelegate, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.toucheDelegate) as? UIViewToucheDelegate
        }
    }
    var startPoint : CGPoint {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.startPoint, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.startPoint) as! CGPoint
        }
    }
    // 是否允许touche
    var isAllowTouche : Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.isAllowTouche, newValue, .OBJC_ASSOCIATION_ASSIGN)
            isUserInteractionEnabled = newValue;
        }
        get {
            return (objc_getAssociatedObject(self, &AssociatedKey.isAllowTouche) != nil)
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event);
        let touche = touches.first;
        startPoint = touche?.location(in: self) ?? CGPoint(x: 0, y: 0)
        
    }
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if isAllowTouche {
            let touche = touches.first;
            let currentP = touche?.location(in: self)
            let perP = touche?.previousLocation(in: self)
            toucheDelegate?.toucheView(self, didMoved: perP!, toPoint: currentP!)
        }
    }
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isAllowTouche {
            let touche = touches.first;
            let currentP = touche?.location(in: self)
            toucheDelegate?.toucheView(self, didEnd: currentP!)
        }
    }
}

extension UIView {
    func getCurrentViewController() -> UIViewController? {
        var nextObjc = next;
        repeat {
            if nextObjc is UIViewController {
                return nextObjc as? UIViewController;
            }
            nextObjc = nextObjc?.next
        } while nextObjc != nil
        return nil;
    }
    
    ///获取当前视图所在导航控制器
    func getCurrentNavViewController() -> UINavigationController? {
        var n = next
        while n != nil {
            if n is UINavigationController {
                return n as? UINavigationController
            }
            n = n?.next
        }
        return nil
    }
}

extension UIView {
    // 将UIView转成UIImage
    func getImage(scale: CGFloat = UIScreen.main.scale) -> UIImage {
        // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    //将当前视图转为UIImage
    func toImage() -> UIImage {
        var image: UIImage?;
        
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            image = renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext);
            }
        } else {
            // Fallback on earlier versions
            image = getImage();
        }
        return image!;
    }
}
