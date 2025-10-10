//
//  File.swift
//  Pinjaman
//
//  Created by MAC on 2025/10/11.
//

import SwiftUI
struct RoundedWhiteBorder: ViewModifier {
    let cornerRadius: CGFloat        
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white, lineWidth: 1) // 设置颜色为白色，宽度为1
            )
    }
}

extension View {
    func roundedWhiteBorder(cornerRadius: CGFloat) -> some View {
        self.modifier(RoundedWhiteBorder(cornerRadius: cornerRadius))
    }
}
