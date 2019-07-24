//
//  CPInsetsLabel.swift
//  swift-OC
//
//  Created by mac on 2019/6/10.
//  Copyright © 2019年 bo. All rights reserved.
//

import UIKit

class CPInsetsLabel: UILabel {
    
    var textInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, textInsets), limitedToNumberOfLines: numberOfLines);
        rect.origin.x       -= textInsets.left;
        rect.origin.y       -= textInsets.top;
        rect.size.width     += (textInsets.left + textInsets.right);
        rect.size.height    += (textInsets.top + textInsets.bottom);
        return rect;
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets));
    }

}
