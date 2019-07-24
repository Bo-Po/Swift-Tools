//
//  CPExtend(UILabel).swift
//  swift-OC
//
//  Created by mac on 2019/4/29.
//  Copyright © 2019年 bo. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    struct AssociatedKey {
        static var tapAction = "tapAction";
        static var tapStrings = "tapStrings";
//        static var startPoint = "startPoint";
    }
    
    typealias TapLabelRange = (_ stringModel: CPAttributeStringModel?)->Void;
    // 属性字符串点击回调(相当于OC的block)
    var tapAction : TapLabelRange? {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.tapAction, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.tapAction) as? TapLabelRange
        }
    }
    var tapStrings : [CPAttributeStringModel]? {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.tapStrings, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.tapStrings) as? [CPAttributeStringModel]
        }
    }
}

extension UILabel : UIViewToucheDelegate {
    func toucheView(_ view: UIView, didMoved startPoint: CGPoint, toPoint: CGPoint) {
        
    }
    func toucheView(_ view: UIView, didEnd point: CGPoint) {
        let result = getTouchFrame(point: point);
        if result.0 {
            tapAction?(result.1!);
        }
    }
    
    func setAttributeText(_ strings: Array<String>, fonts: Array<UIFont>, colors: Array<UIColor>) {
        attributedText = NSAttributedString.configAttributedString(strings, fonts: fonts, colors: colors);
    }
    
    func addAttributeTapAction(strings: Array<String>, backCall:@escaping TapLabelRange) -> Void {
        if let _ = tapStrings {
            tapStrings!.removeAll();
        } else {
            tapStrings = [];
        }
        isAllowTouche = true;
        toucheDelegate = self;
        isUserInteractionEnabled = true;
        var string = attributedText?.string;
        for (idx, value) in strings.enumerated() {
            if let range = string?.range(of: value) {
                var str = "";
                cp_print("range  ==  \(String(describing: range))")
                let rge = string?.Range(from: range);
                for _ in rge! {
                    str = str+" ";
                }
                string = string?.replacingCharacters(in: range, with: str);
                var model = CPAttributeStringModel();
                model.range = range;
                model.string = value;
                model.index = idx;
                tapStrings?.append(model);
            }
        }
        
        tapAction = backCall;
    }
    
    func getTouchFrame(point:CGPoint) -> (Bool, CPAttributeStringModel?) {
        //当前点击的行
        let framesetter = CTFramesetterCreateWithAttributedString(self.attributedText!)
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        let ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path.cgPath, nil)
        let lines = CTFrameGetLines(ctframe)
        let lineCount = CFArrayGetCount(lines)
        let height = sizeForText(mutableAttrStr: self.attributedText as! NSMutableAttributedString).height
        
        let lineHeight = height/CGFloat(lineCount)
        
        let lineIndex = Int(point.y / lineHeight)
        
        let clickPoint = CGPoint(x: point.x, y: lineHeight - point.y)
        
        if lineIndex >= 0 && lineIndex < lineCount {
            
            let clickLine = unsafeBitCast(CFArrayGetValueAtIndex(lines, lineIndex), to: CTLine.self)
            
            let startIndex = CTLineGetStringIndexForPosition(clickLine, clickPoint)
            
            for model in tapStrings! {
                if (attributedText?.string.Range(from: model.range!).contains(startIndex as Int))! {
                    return (true, model);
                }
            }
        }
        return (false, nil);
    }
    //计算size
    
    func sizeForText(mutableAttrStr:NSMutableAttributedString, lineSpacing: CGFloat = 0.0) -> CGSize {
//        let font = UIFont.systemFont(ofSize: font_Size)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraphStyle.lineSpacing = lineSpacing
        //要根据设置的paragraphStyle来计算高度，否则计算的不准确，没有计算行间距
        mutableAttrStr.addAttributes([.paragraphStyle:paragraphStyle], range: NSMakeRange(0, mutableAttrStr.length))
        let framesetter = CTFramesetterCreateWithAttributedString(mutableAttrStr)
        //获取要绘制区域的高度
        let restrictSize = CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        let coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil)
        return coreTextSize
    }
}

struct CPAttributeStringModel {
    var range: Range<String.Index>?
    var string: String?
    var index: Int = -1;
    
}
