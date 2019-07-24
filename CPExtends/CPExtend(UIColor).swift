//
//  CPExtend(UIColor).swift
//  swift-OC
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019年 bo. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    // 接受hex颜色设置 eg. "ffffff"、"#ffffff"
    convenience init(hexCode: String) {
        var cString:String = hexCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if let range = cString.range(of: "0X") {
            cString.removeSubrange(range);
        }
        if ((cString.count) != 6) {
            self.init()
        } else {
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: 1)
        }
    }
}
