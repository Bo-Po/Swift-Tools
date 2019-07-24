//
//  CPFixed .swift
//  swift-OC
//
//  Created by mac on 2019/5/15.
//  Copyright © 2019年 bo. All rights reserved.
//

import Foundation
import UIKit

/// - ------- 设备 层 ------- -

let IphoneX = (UIDevice.isFullScreen) // 不区分模拟器

let isIphoneX = (UIDevice().screenType == .bangs) // 区分模拟器
let isPad = (UI_USER_INTERFACE_IDIOM() == .pad)
let isPhone = (UI_USER_INTERFACE_IDIOM() == .phone)

/// - ------- App 层 ------- -
let App_Delegate = UIApplication.shared.delegate as! AppDelegate;
let App_Window = App_Delegate.window;
let App_Key_Window = UIApplication.shared.keyWindow;
let App_Version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
let App_Build_Version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")
let App_Name = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String)
let App_Bundle_Id = Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String)

/// - ------- 代码 层 ------- -

/// - ------- 类型定义 层 ------- -
typealias CPClickButton = (Any?, Int64)->Void;
