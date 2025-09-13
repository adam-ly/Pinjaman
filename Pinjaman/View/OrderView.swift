//
//  OrderView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/24.
//

import SwiftUI

struct OrderView: View {
    @State private var selectedTab = "All"
    let tabs = ["All", "Apply", "Repayment", "Finished"]
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(linkTextColor)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(secondaryTextColor)], for: .normal)
    }
    
    // 模拟订单数据
    let orders = [
        OrderItem(name: "Pinjaman Rebat", amount: "8,900,000", duration: "120days", interestRate: "0.05%", borrowDate: "08-28-2022", repaymentDate: "12-28-2023"),
        OrderItem(name: "Pinjaman Rebat", amount: "8,900,000", duration: "120days", interestRate: "0.05%", borrowDate: "08-28-2022", repaymentDate: "12-28-2023"),
        OrderItem(name: "Pinjaman Rebat", amount: "8,900,000", duration: "120days", interestRate: "0.05%", borrowDate: "08-28-2022", repaymentDate: "12-28-2023")
    ]
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Order List")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var content: some View {
        VStack(spacing: 12) {
            orderType
                .frame(height: 50)
                .padding(.top, 12)
            
            // 订单列表
            ScrollView {
                VStack {
                    ForEach(0..<orders.count, id: \.self) {
                        index in
                        OrderItemView(
                            order: orders[index],
                            isLastItem: index == orders.count - 1,
                            onApplyTap: {
                                print("Apply for order \(index + 1)")
                            }
                        )
                    }
                }
            }
        }
        .background(Color(UIColor.systemGray6))
    }
    
    var orderType: some View {
        Picker("", selection: $selectedTab) {
            ForEach(tabs, id: \.self) { text in
                Text(text).frame(height: 40)
            }
        }
        .pickerStyle(.segmented)
        .tint(.purple)
        .accentColor(.green)
        .padding(.horizontal)
    }
}

// 扩展View添加底部边框
//extension View {
//    func border(bottom: Bool = false, top: Bool = false, color: Color, width: CGFloat) -> some View {
//        let border = Rectangle()
//            .foregroundColor(color)
//            .frame(height: width)
//
//        if bottom {
//            return Group {
//                self.overlay(border, alignment: .bottom)
//            }
//        } else if top {
//            return Group {
//                self.overlay(border, alignment: .top)
//            }
//        }
//        return self
//    }
//}

#Preview {
    OrderView()
}
