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
        
    @State var canEnterHomePage: Bool = false
    @State var showLoginView: Bool = false
    @State var showToast: Bool = false
    @State var currentToast = ToastContent(title: "")
    @State var showLoading: Bool = false
    
    init() {
        setupNavigationBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            content
                .environmentObject(AppSettings.shared)
                .alertSnack()
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
//            if canEnterHomePage {
//                
//            }
//            TabBarView(showLoginView: $showLoginView)
            if !canEnterHomePage {
                LaunchView(canEnterHomePage: $canEnterHomePage)
            } else {
                TabBarView(showLoginView: $showLoginView)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showLogin)) { n in
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
    
    // 在你的 App 入口处调用此方法
    func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(linkTextColor)
        
        let proxy = UINavigationBar.appearance()
        proxy.tintColor = .white
        proxy.standardAppearance = appearance
        proxy.scrollEdgeAppearance = appearance
    }
}
