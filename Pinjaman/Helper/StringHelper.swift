//
//  StringHelper.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/14.
//

import Foundation

enum LocalizeContent {
    case phoneNumberEmpty // 未输入手机号
    case phoneCodeEmpty // 未输入验证码
    case networkDeny // 网络拒绝
    case locationDeny // 定位拒绝
    case cameraDeny // 相机拒绝
    case contactDeny // 通讯录拒绝
    
    func text() -> String {
        switch self {
        case .phoneNumberEmpty: //未输入手机号
            return AppSettings.shared.configModal?.filesniff == 1 ? "Please enter your phone number" : "Silakan masukkan nomor telepon Anda"
        case .phoneCodeEmpty: // 未输入验证码
            return  AppSettings.shared.configModal?.filesniff == 1 ? "Please enter the verification code" : "Silakan masukkan kode verifikasi"
        case .networkDeny:
            return "we requires internet access to load content and keep your data synced.please go to Settings > Privacy > Location Services, select our app, and turn on location access"
        case .locationDeny:
            return  "Location permission is disabled. To regain full functionality, please go to Settings > Privacy > Location Services, select our app, and turn on location access."
        case .cameraDeny:
            "Camera permission is currently denied. To continue using these features, please open Settings > Privacy > Camera, locate our app, and enable camera access."
        case .contactDeny:
            "Contacts permission is denied. To unlock inviting and sharing features, please navigate to Settings > Privacy > Contacts, select our app, and allow access."
        default:
            return ""
        }
        return ""
    }
    
}
