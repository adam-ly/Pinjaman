//
//  ToolbarDoneButton.swift
//  Pinjaman
//
//  Created by MAC on 2025/10/10.
//

import SwiftUI

// 定义 ViewModifier 结构体
struct ToolbarDoneButton: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .foregroundColor(linkTextColor)
                }
            }
    }
}

// 为 View 扩展一个便捷方法
extension View {
    func addDoneButton() -> some View {
        self.modifier(ToolbarDoneButton())
    }
}
