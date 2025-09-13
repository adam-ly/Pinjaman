//
//  DeviceExtension.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/10.
//

import UIKit

extension UIDevice {
    // MARK: - 私有方法
    static func appVersion() -> String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    static func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        let identifier = mirror.children.reduce("") { id, element in
            guard let value = element.value as? Int8, value != 0 else { return id }
            return id + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    static func deviceId() -> String {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    static func osVersion() -> String {
        UIDevice.current.systemVersion
    }
}
