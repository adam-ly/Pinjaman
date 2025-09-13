//
//  Tabbar.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/11.
//

import SwiftUI

/// 一个用于在 iOS 15 上隐藏 Tab Bar 的视图修饰符
struct TabBarHiddenModifier: ViewModifier {
    @State var showTabbar: Bool = true
    func body(content: Content) -> some View {
        content
            .padding(.bottom, 34)
            .ignoresSafeArea(edges: .bottom)
            .onAppear {
                // 视图出现时，隐藏 Tab Bar
                findTabBarController(isHidden: !showTabbar)
            }
    }
    
    private func findTabBarController(isHidden: Bool) {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        var nextViewController: UIViewController? = rootViewController
        while let current = nextViewController {
            if let tabBarController = current as? UITabBarController {
                tabBarController.tabBar.isHidden = isHidden
                return
            }
            nextViewController = current.children.first
            if let nav = current as? UINavigationController {
                nextViewController = nav.topViewController
            }
        }
    }
}

// 扩展，让视图更容易使用
extension View {
    func hideTabBarOnPush(showTabbar: Bool = true) -> some View {
        self.modifier(TabBarHiddenModifier(showTabbar: showTabbar))
    }
}
