//
//  PJAlert.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/8.
//

import SwiftUI

enum AlertType: String {
    case network, camera, location, contact
    func alertSnack() -> AlertSnack {
        let (title, msg) = titleMessage
        return AlertSnack(
            title: title,
            message: msg
        ) {
            // 统一跳转到 App 的设置页
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    // 本地化文案
    private var titleMessage: (String, String) {
        switch self {
        case .network:
            return (LocalizeContent.networkDenyTitle.text(), LocalizeContent.networkDeny.text())
        case .camera:
            return (LocalizeContent.cameraDenyTitle.text(), LocalizeContent.cameraDeny.text())
        case .location:
            return (LocalizeContent.locationDenyTitle.text(), LocalizeContent.locationDeny.text())
        case .contact:
            return (LocalizeContent.contactDenyTitle.text(), LocalizeContent.contactDeny.text())
        }
    }
}

struct AlertSnack: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    
    let cancelTitle: String = LocalizeContent.cancel.text() // 左侧取消按钮
    let confirmTitle: String = LocalizeContent.goSetting.text() // 右侧按钮文字
    let confirmAction: () -> Void            // 点击回调
}

// 2. ViewModifier 包掉 @State
struct AlertSnackModifier: ViewModifier {
    @State private var snack: AlertSnack? = nil
    
    func body(content: Content) -> some View {
        content
            .alert(item: $snack) { s in
                Alert(
                    title: Text(s.title),
                    message: Text(s.message),
                    primaryButton: .cancel(Text(s.cancelTitle)),
                    secondaryButton: .default(
                        Text(s.confirmTitle),
                        action: s.confirmAction
                    )
                )
            }
            .onReceive(NotificationCenter.default.publisher(for: .showAlert)) { n in
                snack = n.object as? AlertSnack
            }
    }
}

// 3. 一键扩展
extension View {
    func alertSnack() -> some View {
        self.modifier(AlertSnackModifier())
    }
}

extension NotificationCenter {
    static func postAlert(alertType: AlertType) {
        DispatchQueue.main.async(execute: {
            NotificationCenter.default.post(
                name: .showAlert,
                object: alertType.alertSnack()
            )
        })
    }
}

#Preview {
    // 5. 使用：任何地方一句话弹出
    Button("显示封装好的 Alert") {
        NotificationCenter.postAlert(alertType: .network)
    }
    .alertSnack()   // ← 只在最外层写一次即可
}
