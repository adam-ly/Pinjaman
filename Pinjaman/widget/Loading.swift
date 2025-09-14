//
//  Loading.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/10.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    @Binding var isLoading: Bool

    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            
            // 原始视图内容，当加载时可以禁用其交互
            content
                .disabled(isLoading)

            // 加载指示器视图
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(20)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .tint(.black)
            }
        }
    }
}

extension View {
    /// 在视图上显示加载指示器
    /// - Parameter isLoading: 一个布尔类型的绑定变量，用于控制加载状态。
    func loading(isLoading: Binding<Bool>) -> some View {
        self.modifier(LoadingModifier(isLoading: isLoading))
    }
}
