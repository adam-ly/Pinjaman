//
//  ToolbarDoneButton.swift
//  Pinjaman
//
//  Created by MAC on 2025/10/10.
//

import SwiftUI
import Combine
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

// ============================================================================================================

/// 一个 ViewModifier，它通过监听键盘通知来为任何激活的 TextField 或 TextView
/// 附加一个带有“完成”按钮的工具栏。
/// 这在混合了 UIKit 导航的 SwiftUI 视图中特别有用。
struct KeyboardDoneButtonModifier: ViewModifier {
    
    // 使用 @StateObject 来确保 Helper 的生命周期与视图绑定
    @StateObject private var keyboardHelper = KeyboardObserverHelper()

    func body(content: Content) -> some View {
        content
            .onAppear(perform: keyboardHelper.addObservers)
            .onDisappear(perform: keyboardHelper.removeObservers)
    }
}

// MARK: - 便捷的 View 扩展
extension View {
    /// 为视图层级内的所有 TextField/TextView 添加一个键盘上方的“完成”按钮。
    func addKeyboardDoneButton() -> some View {
        self.modifier(KeyboardDoneButtonModifier())
    }
}


// MARK: - 核心逻辑的辅助类
private final class KeyboardObserverHelper: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    /// 添加键盘通知的观察者
    func addObservers() {
        // 使用 Combine 来发布通知，代码更简洁
        NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)
            .sink { [weak self] _ in
                self?.addDoneButtonToKeyboard()
            }
            .store(in: &cancellables)
    }

    /// 移除观察者，防止内存泄漏
    func removeObservers() {
        cancellables.removeAll()
    }

    /// "完成" 按钮被点击时调用的方法
    @objc func doneButtonTapped() {
        // 全局地让第一响应者放弃焦点，从而收起键盘
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    /// 查找当前激活的输入框并为其添加工具栏
    /// 查找当前激活的输入框并为其添加工具栏
    private func addDoneButtonToKeyboard() {
        // 延迟到下一个运行时循环，以确保第一响应者已经设置好
//        DispatchQueue.main.async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // 1. 查找第一响应者（即当前激活的输入框）
            guard let firstResponder = self.findFirstResponder() else {
                return
            }
            
            // 2. 检查它是否是 UITextField 或 UITextView
            //    并避免重复添加工具栏
            if let textField = firstResponder as? UITextField, textField.inputAccessoryView == nil {
                textField.inputAccessoryView = self.createDoneToolbar()
            } else if let textView = firstResponder as? UITextView, textView.inputAccessoryView == nil {
                textView.inputAccessoryView = self.createDoneToolbar()
            }
        }
    }
    
    /// 创建一个标准的“完成”工具栏
    private func createDoneToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonTapped))
        toolbar.items = [flexibleSpace, doneButton]
        toolbar.sizeToFit()
        return toolbar
    }

    /// 递归查找视图层级中的第一响应者
    private func findFirstResponder(in view: UIView? = UIApplication.shared.windows.first { $0.isKeyWindow }) -> UIResponder? {
        guard let view = view else { return nil }
        
        if view.isFirstResponder {
            return view
        }

        for subview in view.subviews {
            if let responder = findFirstResponder(in: subview) {
                return responder
            }
        }
        
        return nil
    }
}
