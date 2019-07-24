//
//  CPMacroDefinition.swift
//  swift-OC
//
//  Created by mac on 2018/12/10.
//  Copyright © 2018年 bo. All rights reserved.
//

import Foundation
import UIKit

/// - ------- 系统 层 ------- -
func Sys_Version() -> CGFloat { return UIDevice.current.systemVersion.floatValue }
func Sys_Ios8_Later() -> Bool { return (Sys_Version()>=8.0) }
func Sys_Ios9_Later() -> Bool { return (Sys_Version()>=9.0) }
func Sys_Ios10_Later() -> Bool { return (Sys_Version()>=10.0) }
func Sys_Ios11_Later() -> Bool { return (Sys_Version()>=11.0) }
func Sys_Ios12_Later() -> Bool { return (Sys_Version()>=12.0) }
func Sys_Language() -> String { return NSLocale.preferredLanguages.first ?? "" }

/// - ------- 尺寸 层 ------- -
func Size_Scr_W() -> CGFloat { return UIScreen.main.bounds.size.width }
func Size_Scr_H() -> CGFloat { return UIScreen.main.bounds.size.height }
func Size_StatusBar_H() -> CGFloat { return UIApplication.shared.statusBarFrame.size.height }
extension UIViewController {
    func Size_NavBar_H() -> CGFloat { return navigationController?.navigationBar.frame.size.height ?? 0.0 }
    func Size_TabBar_H() -> CGFloat { return tabBarController?.tabBar.frame.size.height ?? 0.0 }
    func Size_Safe_Top_Height() -> CGFloat { return (Size_StatusBar_H() + Size_NavBar_H()) }
    func Size_Safe_Bottom_Height() -> CGFloat { return (Size_TabBar_H() != 0.0) ? Size_TabBar_H() : (isIphoneX ? 34.0 : 0.0) }
}

/// - ------- 代码 层 ------- -
func cp_print(_ items: Any..., file: String = ((#file as NSString).lastPathComponent as NSString).deletingPathExtension, line: Int = #line, funcName: String = #function) {
    let log = "\(file).\(funcName)-(\(line))--";
    debugPrint(log);
    debugPrint("--------------------"+String(reflecting: items.first!))
}
