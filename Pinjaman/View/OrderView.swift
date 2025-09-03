//
//  OrderView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/24.
//

import SwiftUI

// 订单数据模型
struct OrderItem: Identifiable {
    let id = UUID()
    let name: String
    let amount: String
    let duration: String
    let interestRate: String
    let borrowDate: String
    let repaymentDate: String
}

// 可复用的订单项视图
struct OrderItemView: View {
    let order: OrderItem
    let isLastItem: Bool
    let onApplyTap: () -> Void

    var body: some View {
        VStack {
            HStack {
                Image("user_avatar") // 假设项目中有这个头像图片
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
                Text(order.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(.bottom, 10)

            HStack {
                Text(order.amount)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
                Text(order.duration)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Text(order.interestRate)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.leading, 5)
            }
            .padding(.bottom, 10)

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Borrowing date")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Spacer()
                    Text(order.borrowDate)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }
                HStack {
                    Text("Repayment date")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Spacer()
                    Text(order.repaymentDate)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }
            }
            .padding(.bottom, 10)

            HStack {
                Button {
                    // 处理贷款协议点击
                    print("Loan agreement tapped")
                } label: {
                    Text("Loan Agreement")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                        .underline()
                }
                Spacer()
                Button {
                    onApplyTap()
                } label: {
                    Text("Apply")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(Color.black)
                        .cornerRadius(5)
                }
            }
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 20)
        .padding(.bottom, isLastItem ? 20 : 15)
    }
}

struct OrderView: View {
    // 标签页状态
    @State private var selectedTab = 0
    let tabs = ["All", "Apply", "Repayment", "Finished"]
    
    // 模拟订单数据
    let orders = [
        OrderItem(name: "Pinjaman Rebat", amount: "8,900,000", duration: "120days", interestRate: "0.05%", borrowDate: "08-28-2022", repaymentDate: "12-28-2023"),
        OrderItem(name: "Pinjaman Rebat", amount: "8,900,000", duration: "120days", interestRate: "0.05%", borrowDate: "08-28-2022", repaymentDate: "12-28-2023"),
        OrderItem(name: "Pinjaman Rebat", amount: "8,900,000", duration: "120days", interestRate: "0.05%", borrowDate: "08-28-2022", repaymentDate: "12-28-2023")
    ]

    var body: some View {
        VStack {
            // 顶部标签栏
            HStack {
                ForEach(0..<tabs.count, id: \.self) {
                    index in
                    Button {
                        selectedTab = index
                    } label: {
                        Text(tabs[index])
                            .font(.system(size: 16, weight: selectedTab == index ? .bold : .medium))
                            .foregroundColor(selectedTab == index ? .black : .gray)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 15)
                    }
                }
            }
            .padding(.top, 5)
            .padding(.horizontal, 10)
            .border(bottom: true, color: .gray.opacity(0.2), width: 1)

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
                .padding(.top, 15)
            }
            .background(Color(UIColor.systemGray6))
        }
        .background(Color(UIColor.systemGray6))
    }
}

// 扩展View添加底部边框
extension View {
    func border(bottom: Bool = false, top: Bool = false, color: Color, width: CGFloat) -> some View {
        let border = Rectangle()
            .foregroundColor(color)
            .frame(height: width)
        
        if bottom {
            return Group {
                self.overlay(border, alignment: .bottom)
            }
        } else if top {
            return Group {
                self.overlay(border, alignment: .top)
            }
        }
        return self
    }
}

#Preview {
    OrderView()
}
