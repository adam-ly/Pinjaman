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

/// 一个用于管理 IDFA 权限和获取的单例类
class IDFAManager {

    /// 单例共享实例
    static let shared = IDFAManager()

    /// 私有初始化方法，确保外部无法创建新实例
    private init() { }

    /// 请求 IDFA 追踪权限，并在获得权限后获取 IDFA
    ///
    /// - 注：此方法需要您的应用 Info.plist 中包含 `NSUserTrackingUsageDescription` 键。
    /// - 此方法是异步的，应该在适当的时机调用，例如在应用启动或特定功能前。
    ///
    /// - returns: 一个元组，包含 IDFA 字符串（如果可用）和授权状态。
    func requestIDFA() async -> (idfa: String?, status: ATTrackingManager.AuthorizationStatus) {
        
        // 异步请求追踪授权
        let status = await ATTrackingManager.requestTrackingAuthorization()

        // 根据授权状态进行处理
        switch status {
        case .authorized:
            // 用户授权了追踪，获取 IDFA
            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            if idfa != "00000000-0000-0000-0000-000000000000" {
                print("已授权并获取 IDFA: \(idfa)")
                return (idfa, status)
            } else {
                print("获取到无效的 IDFA")
                return (nil, status)
            }
        case .denied:
            // 用户拒绝了追踪
            print("用户拒绝了 IDFA 追踪")
            return (nil, status)
        case .notDetermined:
            // 权限尚未决定（通常不会发生，因为我们已经请求了）
            print("IDFA 追踪权限未确定")
            return (nil, status)
        case .restricted:
            // 权限受限，例如家长控制
            print("IDFA 追踪权限受限")
            return (nil, status)
        @unknown default:
            print("未知的授权状态")
            return (nil, status)
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
    func fetchIDFV() -> String? {
        if let idfv = UIDevice.current.identifierForVendor?.uuidString {
            print("已获取 IDFV: \(idfv)")
            return idfv
        } else {
            print("无法获取 IDFV")
            return nil
        }
    }
}

