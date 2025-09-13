//
//  PreferenceKey.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/12.
//

import SwiftUI

// 定義一個 PreferenceKey，用於傳遞滾動的 Y 軸偏移量
struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        // 我們只需要最新的值
//        value = nextValue()
    }
}

struct ScrollViewOffsetTracker: View {
    let coordinateSpaceName: String
    
    var body: some View {
        GeometryReader { proxy in
            // 將滾動偏移量寫入 PreferenceKey
            Color.clear.preference(
                key: ScrollViewOffsetPreferenceKey.self,
                value: proxy.frame(in: .named(coordinateSpaceName)).minY
            )
        }
        // 放在最頂部，大小為零，不影響布局
        .frame(height: 0)
    }
}
