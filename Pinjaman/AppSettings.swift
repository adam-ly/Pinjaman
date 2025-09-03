//
//  AppSettings.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/2.
//

import Foundation

class AppSettings: ObservableObject {
    @Published var isLogin: Bool = false
    @Published var user: UserInfo?
    @Published var configModal: Response<ConfigModel>?
}
