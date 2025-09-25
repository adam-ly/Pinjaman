////
////  Tabbar.swift
////  Pinjaman
////
////  Created by MAC on 2025/9/11.
////
import SwiftUI

// 这个 enum 定义了我们的返回按钮可以执行的所有操作类型
enum BackButtonAction {
    /// 返回上一页
    case pop
    /// 返回到导航根页面
    case popToRoot
    /// 返回到指定的页面
    case popTo(destination: Destination)
}

struct CustomBackButtonModifier: ViewModifier {
    // 从环境中获取我们的导航路由器
    @EnvironmentObject var router: NavigationRouter
    // 存储需要执行的返回操作类型
    var action: BackButtonAction
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true) // 隐藏系统默认的返回按钮
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // 根据传入的 action 类型，执行不同的 router 方法
                        switch action {
                        case .pop:
                            router.pop()
                        case .popToRoot:
                            router.popToRoot()
                        case .popTo(let destination):
                            router.pop(to: destination)
                        }
                    } label: {
                        Image("pd_back") // 使用 SF Symbols 图标
                    }
                }
            }
    }
}

extension View {
    /// 添加一个自定义的返回按钮，并指定其返回行为。
    /// - Parameter action: 返回按钮要执行的操作，例如 .pop, .popToRoot, 或 .popTo(destination: .certify)。
    func customBackButton(action: BackButtonAction) -> some View {
        self.modifier(CustomBackButtonModifier(action: action))
    }
}
