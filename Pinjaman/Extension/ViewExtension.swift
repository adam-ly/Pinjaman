//
//  ViewExtension.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/11.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    /// 找到当前视图的 UINavigationController
    private func findNavigationController(view: UIView) -> UINavigationController? {
        if let nextResponder = view.next as? UIViewController {
            return nextResponder.navigationController
        } else if let nextResponder = view.next as? UIView {
            return findNavigationController(view: nextResponder)
        } else {
            return nil
        }
    }
    
    /// Pop 回到导航栈中的第一个视图（根视图）
    func popToRoot() {
        findNavigationController(view: UIView())?.popToRootViewController(animated: true)
    }
    
    /// Pop 回到指定名称的视图
    func popTo<Content: View>(_ viewType: Content.Type) {
        guard let navigationController = findNavigationController(view: UIView()) else {
            return
        }
        
        // 遍历视图控制器栈，找到目标视图控制器
        for viewController in navigationController.viewControllers {
            if viewController.children.first(where: { String(describing: type(of: $0.view)) == String(describing: viewType) }) != nil {
                navigationController.popToViewController(viewController, animated: true)
                return
            }
        }
    }
}
