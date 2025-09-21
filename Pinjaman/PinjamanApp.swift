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
    @StateObject private var router = NavigationRouter()
    @State var canEnterHomePage: Bool = false
    @State var showToast: Bool = false
    @State var currentToast = ToastContent(title: "")
    
    init() {
        setupNavigationBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            content
            .tint(.white)
            .environmentObject(AppSettings.shared)
            .environmentObject(router)
            .alertSnack()
            .onReceive(NotificationCenter.default.publisher(for: .showToast)) { notification in
                if let content = notification.userInfo?["content"] as? ToastContent {
                    self.currentToast = content
                    self.showToast = true
                }
            }
            .toast(
                isPresented: $showToast,
                content: ToastView(message: self.currentToast)
            )
        }
    }
    
    var content: some View {
        ZStack {
            if !canEnterHomePage {
                LaunchView(canEnterHomePage: $canEnterHomePage)
            } else {
                TabBarView()
            }
        }        
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
