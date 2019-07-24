//
//  CPExtend.swift
//  swift-OC
//
//  Created by mac on 2018/11/30.
//  Copyright © 2018年 bo. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    func removeNullValueForKey() -> AnyObject? {
        
        func dictionaryHandle(with obj:[AnyHashable: Any])->AnyObject {
            var dic = obj;
            for key in obj.keys {
                if let value = obj[key] {
                    if (value as! NSObject).isKind(of: [AnyHashable: Any].self as! AnyClass) {
                        dic = dictionaryHandle(with: value as! [AnyHashable : Any]) as! [AnyHashable : Any]
                    }
                } else {
                    dic.removeValue(forKey: key)
                }
            }
            return dic as AnyObject;
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: []) as! NSObject
            if json.isKind(of: [AnyHashable: Any].self as! AnyClass) {
                 let dic = dictionaryHandle(with: json as! [AnyHashable : Any])
                let josnData = try JSONSerialization.data(withJSONObject: dic as Any, options: [])
                let jsonString = String(data: josnData, encoding: String.Encoding.utf8)
                return jsonString as AnyObject
            }
        } catch {
            print("ERROR")
            print(error)
        }
        return nil
//        if self.isKind(of: Dictionary<String, Any> as! AnyObject) {
//            
//        }
    }
}

public enum DeviceType: Int {
    case simulator
    case appleTV2
    case appleTV3
    case appleTV4
    case appleTV4K
    case homePod
    
    case iPod1
    case iPod2
    case iPod3
    case iPod4
    case iPod5
    
    case iPad2
    case iPad3
    case iPad4
    case iPad5
    case iPadAir1
    case iPadAir2
    
    case iPadMini1
    case iPadMini2
    case iPadMini3
    case iPadMini4
    
    case iPadPro9_7
    case iPadPro12_9
    case iPadPro10_5
    
    case iPhone4
    case iPhone4S
    case iPhone5
    case iPhone5C
    case iPhone5S
    case iPhoneSE
    case iPhone6
    case iPhone6plus
    case iPhone6S
    case iPhone6Splus
    case iPhone7
    case iPhone7plus
    case iPhone8
    case iPhone8plus
    
    case iPhoneX
    case iPhoneXR
    case iPhoneXS
    case iPhoneXSMax
    
    case unrecognized
}

public enum ScreenType: Int {
    case none
    case bangs
}

extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        // iPod touch
        case "iPod1,1":                                  return "iPod Touch 1"
        case "iPod2,1":                                  return "iPod Touch 2"
        case "iPod3,1":                                  return "iPod Touch 3"
        case "iPod4,1":                                  return "iPod Touch 4"
        case "iPod5,1":                                  return "iPod Touch 5"
        case "iPod7,1":                                  return "iPod Touch 6"
            
        // iPad
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":            return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":            return "iPad 4"
        case "iPad6,11", "iPad6,12":                     return "iPad 5"
        case "iPad7,5", "iPad7,6":                       return "iPad 6"
        case "iPad4,1", "iPad4,2", "iPad4,3":            return "iPad Air 1"
        case "iPad5,3", "iPad5,4":                       return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":            return "iPad Mini 1"
        case "iPad4,4", "iPad4,5", "iPad4,6":            return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":            return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                       return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                       return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                       return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                       return "iPad Pro 12.9 Inch 2.Generation"
        case "iPad7,3", "iPad7,4":                       return "iPad Pro 10.5 Inch"
            
        // iPhone
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":      return "iPhone 4"
        case "iPhone4,1":                                return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                   return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                   return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                   return "iPhone 5s"
        case "iPhone7,2":                                return "iPhone 6"
        case "iPhone7,1":                                return "iPhone 6 Plus"
        case "iPhone8,1":                                return "iPhone 6s"
        case "iPhone8,2":                                return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                   return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                   return "iPhone 7 Plus"
        case "iPhone8,4":                                return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                 return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                 return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                 return "iPhone X"
        case "iPhone11,2":                               return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                 return "iPhone XS Max"
        case "iPhone11,8":                               return "iPhone XR"
            
        // Apple TV
        case "AppleTV2,1":                               return "Apple TV 2"
        case "AppleTV3,1", "AppleTV3,2":                 return "Apple TV 3"
        case "AppleTV5,3":                               return "Apple TV 4"
        case "AppleTV6,2":                               return "Apple TV 4K"
        case "AudioAccessory1,1":                        return "HomePod"
        case "i386", "x86_64":                           return "Simulator"
        default:                                         return identifier
        }
    }
    
    var type: DeviceType {
        switch self.modelName {
        case "iPod Touch 1":                    return .iPod1
        case "iPod Touch 2":                    return .iPod2
        case "iPod Touch 3":                    return .iPod3
        case "iPod Touch 4":                    return .iPod4
        case "iPod Touch 5":                    return .iPod5
        case "iPod Touch 6":                    return .iPod5
            
        case "iPad 2":                          return .iPad2
        case "iPad 3":                          return .iPad3
        case "iPad 4":                          return .iPad4
        case "iPad 5":                          return .iPad5
        case "iPad Air 1":                      return .iPadAir1
        case "iPad Air 2":                      return .iPadAir2
        case "iPad Mini 1":                     return .iPadMini1
        case "iPad Mini 2":                     return .iPadMini2
        case "iPad Mini 3":                     return .iPadMini3
        case "iPad Mini 4":                     return .iPadMini4
        case "iPad Pro 9.7 Inch":               return .iPadPro9_7
        case "iPad Pro 12.9 Inch":              return .iPadPro12_9
        case "iPad Pro 12.9 Inch 2.Generation": return .iPadPro12_9
        case "iPad Pro 10.5 Inch":              return .iPadPro10_5
            
        case "iPhone 4":                        return .iPhone4
        case "iPhone 4s":                       return .iPhone4S
        case "iPhone 5":                        return .iPhone5
        case "iPhone 5c":                       return .iPhone5C
        case "iPhone 5s":                       return .iPhone5S
        case "iPhone 6":                        return .iPhone6
        case "iPhone 6 Plus":                   return .iPhone6plus
        case "iPhone 6s":                       return .iPhone6S
        case "iPhone 6s Plus":                  return .iPhone6Splus
        case "iPhone 7":                        return .iPhone7
        case "iPhone 7 Plus":                   return .iPhone7plus
        case "iPhone SE":                       return .iPhoneSE
        case "iPhone 8":                        return .iPhone8
        case "iPhone 8 Plus":                   return .iPhone8plus
        case "iPhone X":                        return .iPhoneX
        case "iPhone XS":                       return .iPhoneXS
        case "iPhone XS Max":                   return .iPhoneXSMax
        case "iPhone XR":                       return .iPhoneXR
            
        case "Apple TV 2":                      return .appleTV2
        case "Apple TV 3":                      return .appleTV3
        case "Apple TV 4":                      return .appleTV4
        case "Apple TV 4K":                     return .appleTV4K
        case "HomePod":                         return .homePod
        case "Simulator":                       return .simulator
            
        default:                                return .unrecognized
        }
    }
    
    var screenType : ScreenType {
        switch self.type {
        case .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR:  return .bangs
            
        default:                                            return .none
        }
    }
    
    static var isFullScreen: Bool {
        if #available(iOS 11, *) {
            guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
                return false
            }
            
            if unwrapedWindow.safeAreaInsets.bottom > 0 {
                print(unwrapedWindow.safeAreaInsets)
                return true
            }
        }
        return false
    }
    
}

extension UIDevice {
    
    public var ipAddress: String {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first ?? "0.0.0.0"
    }
    //获取本机ip
    func getLocalIPAddressForCurrentWiFi() -> String? {
        
        var address: String?
        
        // get list of all interfaces on the local machine
        
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        
        guard getifaddrs(&ifaddr) == 0 else { return nil  }
        guard let firstAddr = ifaddr else { return nil }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
}
