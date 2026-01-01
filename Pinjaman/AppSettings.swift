//
//  AppSettings.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/2.
//

import Foundation
import SwiftUI

class AppSettings: ObservableObject {    
    static let shared = AppSettings()
    
    lazy var adressManager = AddressManager.shared
    
    var address: [AddressItem] = []
    
    @Published var configModal: ConfigModel?
    
    
    @Published var userCenterModel: PersonCenterModel?
    @Published var loginModel: LoginModel? {
        didSet {
            // Step 3: Automatically save the model whenever it changes
            if let model = loginModel {
                if let encoded = try? JSONEncoder().encode(model) {
                    UserDefaults.standard.set(encoded, forKey: "loginModelKey")
                }
            } else {
                UserDefaults.standard.removeObject(forKey: "loginModelKey")
            }
        }
    }
    
    // 用于在 UserDefaults 中存储时间戳的键
    private let locationTimestampKey = "locationPermissionTimestampKey"
    
    /// 一个计算属性，用于检查距离上次记录时间是否已超过24小时。
    var checkLocationPermission: Bool {
        get {
            // 1. 从 UserDefaults 中取出存储的时间戳 (TimeInterval)
            // 如果键不存在，`double(forKey:)` 会返回 0.0
            let savedTimestamp = UserDefaults.standard.double(forKey: locationTimestampKey)
            
            // 2. 如果从未存储过时间戳 (值为0)，则认为需要检查，返回 true
            if savedTimestamp == 0 {
                return true
            }
            
            // 3. 获取当前时间的时间戳
            let currentTimestamp = Date().timeIntervalSince1970
            
            // 4. 计算24小时对应的秒数
            
#if DEBUG
            let twentyFourHoursInSeconds: TimeInterval = 30
            #else
            let twentyFourHoursInSeconds: TimeInterval = 24 * 60 * 60
#endif            
            let timeDifference = currentTimestamp - savedTimestamp
            return timeDifference > twentyFourHoursInSeconds
        }
        
        set {
            if newValue {
                let timestamp = Date().timeIntervalSince1970
                UserDefaults.standard.set(timestamp, forKey: locationTimestampKey)
                print("记录了新的时间戳: \(timestamp)")
            } else {
                UserDefaults.standard.removeObject(forKey: locationTimestampKey)
                print("清除了时间戳")
            }
            
            objectWillChange.send()
        }
    }
    
    init() {
        if let savedData = UserDefaults.standard.data(forKey: "loginModelKey") {
            if let decodedModel = try? JSONDecoder().decode(LoginModel.self, from: savedData) {
                self.loginModel = decodedModel
            }
        }
    }
    
    
    func isLogin() -> Bool {
        loginModel != nil
    }
    
    func logout(){
        loginModel = nil
        userCenterModel = nil
    }
}
