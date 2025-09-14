//
//  DeviceExtension.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/10.
//

import UIKit
import UIKit
import Network
import SystemConfiguration
import CoreTelephony
import AdSupport
import AppTrackingTransparency
import SystemConfiguration.CaptiveNetwork
import CoreLocation

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

extension UIDevice {
    static func getDeviceInfo() -> String {
        var json: [String: Any] = [:]
        
        // 1. 存储信息（单位：字节）
        json["engraphy"] = [
            "beefwood": getAvailableDiskSpace(),   // 可用存储
            "xenotropic": getTotalDiskSpace(),      // 总存储
            "shift": getTotalMemory(),        // 总内存
            "antimonarchal": getFreeMemory()            // 可用内存
        ]
        
        // 2. 电池信息
        json["hypnotizable"] = [
            "phosphorescently": Int(getBatteryLevel() * 100),  // 剩余电量百分比
            "onrushes": isDeviceCharging() ? 1 : 0            // 是否充电
        ]
        
        // 3. 设备信息
        json["oxygenized"] = [
            "customly": UIDevice.current.systemVersion,   // 系统版本
            "procollectivist": UIDevice.current.model,      // 设备品牌（如iPhone）
            "cofounder": getDeviceModelIdentifier()         // 原始设备型号（如iphone10,3）
        ]
        
        // 4. 安全状态
        json["deceivance"] = [
            "blunter": isSimulatorRunning() ? 1 : 0,   // 是否模拟器
            "endangium": isDeviceJailbroken() ? 1 : 0  // 是否越狱
        ]
        
        // 5. 环境信息
        json["untoured"] = [
            "pimas": TimeZone.current.identifier,              // 时区ID
            "metroptosis": IDFAManager.shared.fetchIDFV() ?? "",     // IDFV
            "bilirubinic": AppSettings.shared.configModal?.filesniff,      // 语言
            "dipsey": getCurrentNetworkType(),               // 网络类型
            "alemannish": IDFAManager.shared.fetchIDFA()                           // IDFA
        ]
        
        // 6. 当前WiFi信息
        if let wifiInfo = getCurrentWifiInfo() as? (String?, String?),
           let name = wifiInfo.0,
           let mac = wifiInfo.1 {
            json["photoanamorphosis"] = ["enrollments": ["maghrib": mac, "contendent": name]]
        } else {
            json["photoanamorphosis"] = ["enrollments": ["": ""]]   // 无WiFi时返回空对象
        }
        
        // 将 JSON 对象转换为 Data
        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        return ""
    }
    
    
    // 获取总内存大小
    static func getTotalMemory() -> String {
        let totalMemorySize = ProcessInfo.processInfo.physicalMemory
        return formatFileSize(totalMemorySize)
    }
    
    // 获取当前可用内存
    static func getFreeMemory() -> String {
        let hostPort = mach_host_self()
        var size = mach_msg_type_number_t(MemoryLayout<vm_statistics64_data_t>.stride / MemoryLayout<integer_t>.stride)
        var vmStats = vm_statistics64()
        
        let result = withUnsafeMutablePointer(to: &vmStats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
                host_statistics64(hostPort, HOST_VM_INFO64, $0, &size)
            }
        }
        
        guard result == KERN_SUCCESS else {
            return "获取内存失败"
        }
        
        let pageSize = UInt64(vm_kernel_page_size)
        let free = UInt64(vmStats.free_count)
        let inactive = UInt64(vmStats.inactive_count)
        let speculative = UInt64(vmStats.speculative_count)
        
        let availableBytes = (free + inactive + speculative) * pageSize
        return formatFileSize(UInt64(Int64(availableBytes)))
    }
    
    /// 获取设备总磁盘容量
    static func getTotalDiskSpace() -> String {
        var fs = statfs()
        let result = statfs("/var", &fs)
        let totalDiskSize: UInt64
        if result >= 0 {
            totalDiskSize = UInt64(fs.f_bsize) * UInt64(fs.f_blocks)
        } else {
            totalDiskSize = 0
        }
        return formatFileSize(totalDiskSize)
    }
    
    // 获取可用磁盘容量
    static func getAvailableDiskSpace() -> String {
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
        do {
            let values = try tempURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
            if let available = values.volumeAvailableCapacityForImportantUsage {
                return formatFileSize(UInt64(available))
            } else {
                return "-1"
            }
        } catch {
            return "-1"
        }
    }
    
    // 将文件大小转换为字符串
    static func formatFileSize(_ fileSize: UInt64) -> String {
        return "\(fileSize)"
    }
    
    // 电池状态
    private static func getBatteryLevel() -> Float {
        UIDevice.current.isBatteryMonitoringEnabled = true
        return max(0, UIDevice.current.batteryLevel)  // 避免返回-1
    }
    
    private static func isDeviceCharging() -> Bool {
        return UIDevice.current.batteryState == .charging || UIDevice.current.batteryState == .full
    }
    
    // 设备型号标识符（如iphone10,3）
    private static func getDeviceModelIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        return mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
    
    // 安全检测
    private static func isSimulatorRunning() -> Bool {
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }
    
    private static func isDeviceJailbroken() -> Bool {
        let paths = ["/Applications/Cydia.app", "/bin/bash"]
        return paths.contains { FileManager.default.fileExists(atPath: $0) }
    }
    
    
    // wifi
    static func getCurrentWifiInfo() -> (ssid: String?, bssid: String?) {
        var ssid: String?
        var bssid: String?
        
        // 遍历所有网络接口
        guard let interfaces = CNCopySupportedInterfaces() as? [String] else {
            return (nil, nil)
        }
        
        for interface in interfaces {
            guard let info = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: Any] else {
                continue
            }
            ssid = info[kCNNetworkInfoKeySSID as String] as? String
            bssid = info[kCNNetworkInfoKeyBSSID as String] as? String
            break // 取第一个有效接口
        }
        return (ssid, bssid)
    }
    
    
    static func getCurrentNetworkType() -> String {
        // 0. 网络可达性检测
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else { return "OTHER" }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return "OTHER"
        }
        
        // 1. 优先检测 WiFi
        if flags.contains(.reachable) && flags.contains(.isWWAN) == false {
            return "WIFI"
        }
        
        // 2. 蜂窝网络类型检测
        let networkInfo = CTTelephonyNetworkInfo()
        
        // 多 SIM 卡兼容处理（iOS 12+）
        if #available(iOS 12.0, *), let carrierTypes = networkInfo.serviceCurrentRadioAccessTechnology {
            for (_, value) in carrierTypes {
                return parseRadioAccessTechnology(value)
            }
        }
        // 单 SIM 卡处理（iOS 7+）
        else if let radioAccess = networkInfo.currentRadioAccessTechnology {
            return parseRadioAccessTechnology(radioAccess)
        }
        
        return "OTHER"
    }
    
    // 解析蜂窝网络具体类型
    static private func parseRadioAccessTechnology(_ radioAccess: String) -> String {
        switch radioAccess {
            // 2G 类型
        case CTRadioAccessTechnologyGPRS,
            CTRadioAccessTechnologyEdge,
        CTRadioAccessTechnologyCDMA1x:
            return "2G"
            
            // 3G 类型
        case CTRadioAccessTechnologyWCDMA,
            CTRadioAccessTechnologyHSDPA,
            CTRadioAccessTechnologyHSUPA,
            CTRadioAccessTechnologyCDMAEVDORev0,
            CTRadioAccessTechnologyCDMAEVDORevA,
            CTRadioAccessTechnologyCDMAEVDORevB,
        CTRadioAccessTechnologyeHRPD:
            return "3G"
            
            // 4G 类型
        case CTRadioAccessTechnologyLTE:
            return "4G"
            
            // 5G 类型（iOS 14+）
        case "CTRadioAccessTechnologyNRNSA",   // 5G NSA
            "CTRadioAccessTechnologyNR":       // 5G SA
            return "5G"
            
        default:
            return "OTHER"
        }
    }
    
}
