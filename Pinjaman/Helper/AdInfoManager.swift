//
//  AdInfoManager.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/14.
//

import Foundation
import AdSupport
import AppTrackingTransparency
import UIKit
import Security

/// 一个用于管理 IDFA 权限和获取的单例类
class IDFAManager {

    /// 单例共享实例
    static let shared = IDFAManager()

    /// 私有初始化方法，确保外部无法创建新实例
    private init() { }
    
    func requestIDFA(completion: @escaping (_ idfa: String?, _ status: ATTrackingManager.AuthorizationStatus) -> Void) {
        
        // 调用带 completion handler 的 API
        ATTrackingManager.requestTrackingAuthorization { status in
            // 根据授权状态进行处理
            switch status {
            case .authorized:
                // 用户授权了追踪，获取 IDFA
                let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                if idfa != "00000000-0000-0000-0000-000000000000" {
                    print("已授权并获取 IDFA: \(idfa)")
                    completion(idfa, status)
                } else {
                    print("获取到无效的 IDFA")
                    completion(nil, status)
                }
                
            case .denied:
                // 用户拒绝了追踪
                print("用户拒绝了 IDFA 追踪")
                completion(nil, status)
                
            case .notDetermined:
                // 权限尚未决定（在回调中这通常意味着请求被某种方式中断）
                print("IDFA 追踪权限未确定")
                completion(nil, status)
                
            case .restricted:
                // 权限受限，例如家长控制
                print("IDFA 追踪权限受限")
                completion(nil, status)
                
            @unknown default:
                print("未知的授权状态")
                completion(nil, status)
            }
        }
    }
    
    /// 获取当前可用的 IDFA。
    /// 此方法不会请求权限。只有当权限已授权时，才会返回 IDFA。
    ///
    /// - returns: IDFA 字符串（如果可用），否则为 nil。
    func fetchIDFA() -> String? {
        // 检查当前授权状态
        let status = ATTrackingManager.trackingAuthorizationStatus
        guard status == .authorized else {
            // 如果未授权，则无法获取 IDFA
            print("未获取到 IDFA，因为权限未授权")
            return nil
        }

        // 如果已授权，则从 ASIdentifierManager 获取
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        
        // 检查 IDFA 是否有效
        if idfa != "00000000-0000-0000-0000-000000000000" {
            print("已获取 IDFA: \(idfa)")
            return idfa
        }
        
        print("获取到无效的 IDFA")
        return nil
    }
    
    /// 获取设备的 Vendor Identifier (IDFV)。
    /// IDFV 专用于同一供应商（开发团队）的应用。
    /// 此方法不需要用户授权。
    ///
    /// - returns: IDFV 字符串（如果可用），否则为 nil。
    func fetchIDFV() -> String {        
        if let persistentIDFV = IDFVManager.getPersistentIDFV() {
            print("已获取 IDFV: \(persistentIDFV)")
            return persistentIDFV
        } else {
            print("无法获取 IDFV")
            return ""
        }
    }
}


class IDFVManager {
    private static let keychainKey = "com.pinjaman.idfv" // 替换为你自己的 bundle ID 或唯一标识

    static func getPersistentIDFV() -> String? {
        // 1. 尝试从 Keychain 获取
        if let savedIDFV = loadFromKeychain() {
            return savedIDFV
        }

        // 2. 如果没有，则从系统获取 IDFV
        guard let idfv = UIDevice.current.identifierForVendor?.uuidString else {
            return nil
        }

        // 3. 保存到 Keychain
        saveToKeychain(idfv)

        return idfv
    }

    private static func saveToKeychain(_ value: String) {
        let data = value.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey,
            kSecValueData as String: data
        ]

        // 先删除已存在的项（避免重复）
        SecItemDelete(query as CFDictionary)

        // 添加新项
        SecItemAdd(query as CFDictionary, nil)
    }

    private static func loadFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let data = result as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }
}
