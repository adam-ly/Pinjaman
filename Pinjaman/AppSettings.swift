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
    
    @Published var user: UserInfo?
    @Published var configModal: ConfigModel?
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
}
