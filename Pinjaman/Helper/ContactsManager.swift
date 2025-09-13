//
//  ContactsManager.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/13.
//

import SwiftUI
import Contacts

class ContactsManager: ObservableObject {
    @Published var isShowingContactPicker = false
    @Published var isShowingPermissionAlert = false
    
    // 保存 completionHandler 闭包
    private var completionHandler: ((_ contact: (name: String, number: String)?) -> Void)?
    
    // 新增一个方法，接受一个闭包作为参数
    func showContactPicker(completion: @escaping (_ contact: (name: String, number: String)?) -> Void) {
        let store = CNContactStore()
        
        // 保存闭包，以便在获得权限后调用
        self.completionHandler = completion

        store.requestAccess(for: .contacts) { [weak self] granted, error in
            DispatchQueue.main.async {
                if granted {
                    self?.isShowingContactPicker = true
                } else {
                    self?.isShowingPermissionAlert = true
                    // 如果权限被拒绝，立即调用闭包并传回 nil
                    self?.completionHandler?(nil)
                    self?.completionHandler = nil // 清理闭包
                    NotificationCenter.postAlert(alertType: .contact)
                }
            }
        }
    }
    
    // 这个方法在 ContentView 中调用，用于处理 ContactPicker 返回的结果
    func handleContactSelection(contact: (name: String, number: String)?) {
        // 调用并清理闭包
        self.completionHandler?(contact)
        self.completionHandler = nil
        self.isShowingContactPicker = false
    }
}
