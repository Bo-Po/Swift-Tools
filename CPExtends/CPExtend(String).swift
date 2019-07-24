//
//  CPExtend(String).swift
//  swift-OC
//
//  Created by mac on 2019/4/19.
//  Copyright © 2019年 bo. All rights reserved.
//

import Foundation
import UIKit

extension String {
    // 1 个汉字 = 2 个字符 (表情可看成1个或多个汉子)
    func charLength() -> UInt64 {
        var asciiLength : UInt64 = 0;
        let str = self as NSString;
        for index in 0..<str.length {
            asciiLength += 1;
            let uc = str.character(at: index);
            if isascii(Int32(uc)) == 0 {
                asciiLength += 1;
            }
        }
        return asciiLength;
    }
    // 1 个汉字 = 2 个字符 (表情可看成1个字母)(不常用)
    func charLengthOnlyChinese() -> UInt64 {
        var asciiLength : UInt64 = 0;
        for (_, value) in self.enumerated() {
            asciiLength += 1;
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                asciiLength += 1;
            }
        }
        return asciiLength;
    }
    
}

extension String {
    // 是否包含find
    func contains(find: String) -> Bool{
        return range(of: find) != nil
    }
    // 是否包含find（不区分大小写）
    func containsIgnoringCase(find: String) -> Bool{
        return range(of: find, options: .caseInsensitive) != nil
    }
    
    /// 截取第任意位置到结束
    func subString(start: Int) -> String {
        if !(start < count) { return "截取超出范围" }
        let sRang = index(startIndex, offsetBy: start)
        return String(self[sRang...])
    }
    /// 截取第一个到第任意位置
    public func subString(end: Int) -> String {
        if !(end < self.count) { return "截取超出范围" }
        let sInde = index(startIndex, offsetBy: end)
        return String(self[...sInde])
    }
    /// 字符串任意位置插入
    func stringInsert(content: String,locat: Int) -> String {
        if !(locat < count) { return "截取超出范围" }
        let str1 = subString(end: locat)
        let str2 = subString(start: locat+1)
        return str1 + content + str2
    }
    /// 判断是否有emoji
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case
            0x00A0...0x00AF,
            0x2030...0x204F,
            0x2120...0x213F,
            0x2190...0x21AF,
            0x2310...0x329F,
            0x1F000...0x1F9CF:
                return true
            default:
                continue
            }
        }
        return false
    }
}

extension String {
    /// Range<String.Index>转换为Range<Int>
    public func Range(from range: Range<String.Index>) -> Range<Int> {
        let nsrange = NSRange(range, in: self);
        return nsrange.location..<(nsrange.location+nsrange.length);
    }
}

extension String {
    /// Range<String.Index>转换为Range<Int>
    var floatValue: CGFloat {
        get {
            let dd = Double(self);
            return CGFloat(dd ?? 0.0);
        }
    };
    
    public func floatValue(from range: Range<String.Index>) -> Range<Int> {
        let nsrange = NSRange(range, in: self);
        return nsrange.location..<(nsrange.location+nsrange.length);
    }
}

extension NSAttributedString {
//    static func configAttributedString(_ strings: Array<String>, fonts: Array<UIFont>, colors: Array<UIColor>) -> NSAttributedString {
//        return self.configAttributedString(strings, fonts: fonts, colors: colors, links: nil);
//    }
    static func configAttributedString(_ strings: Array<String>, fonts: Array<UIFont>, colors: Array<UIColor>, links: Dictionary<Int, String>? = nil) -> NSAttributedString {
        let frist: NSMutableAttributedString = NSMutableAttributedString(string: "");
        for (index, string) in strings.enumerated() {
            let other = NSMutableAttributedString(string: string);
            var otherAttributes: [NSAttributedStringKey : Any];
            if fonts.count == 1 {
                otherAttributes = [.font:fonts[0]];
            } else {
                otherAttributes = [.font:fonts[index]];
            }
            if colors.count == 1 {
                otherAttributes.updateValue(colors[0], forKey: .foregroundColor);
            } else {
                otherAttributes.updateValue(colors[index], forKey: .foregroundColor);
            }
            if let _ = links {
                for (key, value) in links! {
                    if key == index {
                        otherAttributes.updateValue(URL.init(string: value)!, forKey: .link)
                    }
                }
            }
            other.setAttributes(otherAttributes, range: NSRange.init(location: 0, length: string.count));
            frist.append(other);
        }
        return frist;
    }
}

extension Character {
    func toInt() -> Int
    {
        print("Character  "+"\(self)")
        var intFromCharacter:Int = 0
        for scalar in String(self).unicodeScalars
        {
            intFromCharacter = Int(scalar.value)
        }
        print("Character int "+"\(intFromCharacter)")
        return intFromCharacter
    }
}
