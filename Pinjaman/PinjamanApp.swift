//
//  PinjamanApp.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/8.
//

import SwiftUI
import Network

@main
struct PinjamanApp: App {
    @StateObject var settings = AppSettings.shared
    @State var canEnterHomePage: Bool = false
    @State var showLoginView: Bool = false
    @State var showToast: Bool = false
    @State var currentToast = ToastContent(title: "")
    @State var showLoading: Bool = false
    
    var body: some Scene {
        WindowGroup {
            content
                .environmentObject(settings)
                .alertSnack()
                .loading(isLoading: $showLoading)
                .onReceive(NotificationCenter.default.publisher(for: .showLoading)) { notification in
                    guard let dict = notification.userInfo as? [String: Bool] else {
                        return
                    }
                    self.showLoading = dict[Notification.Name.showLogin.rawValue] ?? false
                }
                .onReceive(NotificationCenter.default.publisher(for: .showToast)) { notification in
                    // 从通知的 userInfo 中获取数据
                    if let content = notification.userInfo?["content"] as? ToastContent {
                        // 更新状态，这将触发 Toast 的显示和计时器重置
                        self.currentToast = content
                        self.showToast = true
                    }
                }
                // 将 toast 修饰符应用到整个视图上
                .toast(
                    isPresented: $showToast,
                    // 如果 currentToast 为 nil，提供一个空的 ToastContent
                    content: ToastView(message: self.currentToast)
                )
        }
    }
    
    var content: some View {
        ZStack {
            TabBarView(showLoginView: $showLoginView)
            if !canEnterHomePage {
                LaunchView(canEnterHomePage: $canEnterHomePage)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showLogin)) { n in
            guard let hasLogin = n as? Bool, !hasLogin else {
                return
            }
            withAnimation {
                showLoginView = true
            }
        }
        .overlay(content: {
            if showLoginView {
                LoginView(isPresented: $showLoginView)
                    .ignoresSafeArea()
            } else {
                Color.clear
            }
        }
        )
        
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
}
