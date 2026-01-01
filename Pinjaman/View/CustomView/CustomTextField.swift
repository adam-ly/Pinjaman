//
//  CustomTextField.swift
//  Pinjaman
//
//  Created by MAC on 2025/10/18.
//

import SwiftUI
import UIKit

struct CustomTextField: UIViewRepresentable {
    
    // MARK: - Properties
    
    var placeholder: String
    @Binding var text: String
    
    // 1. 升级为 @Binding，以便与 @FocusState 双向同步
    @Binding var isFocused: Bool
    
    // 键盘相关的配置
    var keyboardType: UIKeyboardType = .default
    var returnKeyType: UIReturnKeyType = .done
    
    // 2. 添加 onEditingChanged 回调
    var onEditingChanged: ((Bool) -> Void)?
    // MARK: - UIViewRepresentable Conformance
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.returnKeyType = returnKeyType
        
        // 核心：在创建时就附加 inputAccessoryView
        textField.inputAccessoryView = createDoneToolbar(context: context)
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        // 1. 同步 SwiftUI State -> UIKit
        uiView.text = text
        
        // 2. 同步焦点状态 (SwiftUI -> UIKit)
        if isFocused && !uiView.isFirstResponder {
            // SwiftUI 状态要求获取焦点
            DispatchQueue.main.async { // 延迟以避免视图更新冲突
                uiView.becomeFirstResponder()
            }
        } else if !isFocused && uiView.isFirstResponder {
            // SwiftUI 状态要求失去焦点
            DispatchQueue.main.async {
                uiView.resignFirstResponder()
            }
        }
        
        // 3. 确保 Coordinator 始终拥有最新的回调
        context.coordinator.parent = self
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Helper Methods
    
    private func createDoneToolbar(context: Context) -> UIToolbar {
        // ... (此函数保持不变) ...
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: context.coordinator, action: #selector(Coordinator.doneButtonTapped))
        toolbar.items = [flexibleSpace, doneButton]
        toolbar.sizeToFit()
        return toolbar
    }
    
    // MARK: - Coordinator Class
    
    final class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField
        
        init(_ textField: CustomTextField) {
            self.parent = textField
        }
        
        /// “完成”按钮的点击事件
        @objc func doneButtonTapped() {
            parent.isFocused = false
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
        // MARK: - 3. 实现新的代理方法
        
        /// 当文本框开始编辑时
        func textFieldDidBeginEditing(_ textField: UITextField) {
            // 调用 onEditingChanged 回调
            parent.onEditingChanged?(true)
            
            // 同步焦点状态 (UIKit -> SwiftUI)
            // 延迟以确保 SwiftUI 状态更新不会与当前事务冲突
            DispatchQueue.main.async {
                self.parent.isFocused = true
            }
        }
        
        /// 当文本框结束编辑时
        func textFieldDidEndEditing(_ textField: UITextField) {
            // 调用 onEditingChanged 回调
            parent.onEditingChanged?(false)
            
            // 同步焦点状态 (UIKit -> SwiftUI)
            DispatchQueue.main.async {
                self.parent.isFocused = false
            }
        }
        
        /// 当用户输入时 (保持不变)
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}
