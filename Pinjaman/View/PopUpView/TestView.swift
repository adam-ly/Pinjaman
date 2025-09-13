//
//  TestView.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/13.
//

import SwiftUI

struct TestView: View {
    @State private var selectedDate = Date()
    // 一个 DateFormatter 实例，用于将 Date 对象格式化为字符串
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 20) {            
            // 使用 Text 视图来显示格式化后的日期
            Text("选中的日期是：")
            Text(dateFormatter.string(from: selectedDate))
                .font(.title)
                .bold()
                .foregroundColor(.blue)
                        
            // DatePicker 绑定到 selectedDate
            DatePicker( "请选择日期",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .labelsHidden() // 隐藏 DatePicker 默认的标签
            .datePickerStyle(.automatic) // 使用图形化样式，更适合选择日期
            .padding()
            .opacity(0.02)
        }
    }
}

#Preview {
    TestView()
}
