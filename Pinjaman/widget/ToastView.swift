//
//  ToastView.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/6.
//

import SwiftUI

// 只需加上 Equatable
struct ToastView: View, Equatable {
    static func == (lhs: ToastView, rhs: ToastView) -> Bool {
        return lhs.message.id == rhs.message.id
    }
    
    let message: ToastContent
    var body: some View {
        Text(message.title)
            .id(message.id)
            .padding()
            .background(Color.black.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct ToastContent: Identifiable {
    let id = UUID()
    let title: String
}

struct ToastModifier<ToastContent: View & Equatable>: ViewModifier {
    
    @Binding var isPresented: Bool
    let duration: TimeInterval
    var toastContent: ToastContent // 直接持有 View content
    @State private var workItem: DispatchWorkItem?

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                VStack {
                    Spacer()
                    toastContent
                    Spacer()
                }
                .onAppear(perform: scheduleDismissal)
                .onDisappear(perform: cancelDismissal)
                // 【核心改動】: 監聽 toastContent 本身的變化
                // 如果 Toast 正在顯示時內容變了，就重置計時器
                .onChange(of: toastContent) { _ in
                    scheduleDismissal()
                }
            }
        }        
        // 當 isPresented 從 false -> true 時，也需要觸發
        .onChange(of: isPresented) { newValue in
            if newValue {
                scheduleDismissal()
            }
        }
    }

    private func scheduleDismissal() {
        workItem?.cancel()
        let task = DispatchWorkItem {
            withAnimation {
                isPresented = false
            }
        }
        self.workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }

    private func cancelDismissal() {
        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    // 修改擴展以接受一個 content View，而不是 ViewBuilder
    func toast<Content: View & Equatable>(
        isPresented: Binding<Bool>,
        content: Content,
        duration: TimeInterval = 2
    ) -> some View {
        modifier(ToastModifier(isPresented: isPresented,
                               duration: duration,
                               toastContent: content))
    }
}

class ToastManager {
    static let shared = ToastManager()
    
    func show(_ message: String) {
        DispatchQueue.main.async(execute:{
            let content = ToastContent(title: message)
            NotificationCenter.default.post(name: .showToast, object: nil, userInfo: ["content": content])
        })
    }
}

struct ToastDemo: View {
    // 使用 optional 类型来处理没有 toast 的情况
    @State private var currentToast: ToastContent?
    @State private var showToast = false

    var body: some View {
        VStack(spacing: 20) {
            Text("这是主要的 App 内容")
            
            // 在任何你想要显示 toast 的地方，调用 ToastManager
            Button("显示 Toast 1") {
                ToastManager.shared.show("这是第一则全局消息")
            }
            
            Button("显示 Toast 2") {
                ToastManager.shared.show("这是一则不同的消息！")
            }
        }
        .padding()
        // 在最顶层视图监听通知
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
            content: ToastView(message: self.currentToast ?? ToastContent(title: ""))
        )
    }
}

#Preview {
    ToastDemo()
}
