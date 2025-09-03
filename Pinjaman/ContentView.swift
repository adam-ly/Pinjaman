//
//  ContentView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/8.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("欢迎使用 Pinjaman 应用")
                    .font(.title)
                    .padding()
                
                Text("这是首页内容")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // 可以在这里添加更多首页内容
                
                Spacer()
            }
            .navigationTitle("首页")
        }
    }
}

#Preview {
    ContentView()
}
