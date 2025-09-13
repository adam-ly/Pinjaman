//
//  NotificationName.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/9.
//

import Foundation


extension Notification.Name {
    static let showToast = Notification.Name("com.PJ.showToast")
    static let showAlert = Notification.Name("showAlert")
    static let showLogin = Notification.Name("showLogin")
    static let didLogin  = Notification.Name("didLogin")
    static let showLoading = Notification.Name("showLoading")
    static let hideLoading = Notification.Name("hideLoading")
    static let userInfoScrolling = Notification.Name("userInfoScrolling")
    static let didOpenPicker = Notification.Name("didOpenPicker")
}

