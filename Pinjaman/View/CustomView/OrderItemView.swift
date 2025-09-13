//
//  OrderItemView.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/13.
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
        content
    }
    
    var content: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                
                headerArea
                
                contentArea
                
                bottomArea
            }
            .padding(15)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal, 20)
            .padding(.bottom, isLastItem ? 20 : 15)
        }
    }
    
    var headerArea: some View {
        HStack {
            Image("AppLogo")
                .resizable()
                .frame(width: 32, height: 32)
                .cornerRadius(4)
            Text(order.name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
        }
    }
    
    var contentArea: some View {
        VStack {
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
        }
        .padding(15)
        .background(productBgColor)
        .cornerRadius(8)
    }
    
    var bottomArea: some View {
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
                    .frame(height: 32)
                    .frame(minWidth: 60)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .background(primaryColor)
                    .cornerRadius(16)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.yellow.ignoresSafeArea()
        OrderItemView(order: OrderItem(name: "Pinjaman Rebat", amount: "8,900,000", duration: "120days", interestRate: "0.05%", borrowDate: "08-28-2022", repaymentDate: "12-28-2023"), isLastItem: false, onApplyTap: {
            
        })
    }
}
