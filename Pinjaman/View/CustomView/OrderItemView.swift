//
//  OrderItemView.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/13.
//

import SwiftUI
import Kingfisher

// 可复用的订单项视图
struct OrderItemView: View {
    @State var order: OrderModel
    let onApplyTap: (String) -> Void
    
    var body: some View {
        content
            .onTapGesture {
                onApplyTap(order.intertwist ?? "")
            }
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
        }
    }
    
    var headerArea: some View {
        HStack {
            if let url = URL(string: order.underspore ?? "") {
                KFImage(url)
                    .resizable()
                    .placeholder({ _ in
                        RoundedRectangle(cornerRadius: 6)
                            .frame(width: 32, height: 32)
                            .background(productBgColor)
                    })
                    .frame(width: 32, height: 32)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(4)
            } else {
                Image("AppLogo")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .cornerRadius(6)
            }
            Text(order.multilayer ?? "")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
        }
    }
    
    var contentArea: some View {
        VStack {
            HStack {
                Text(order.eveready ?? "")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
                Text(order.duramens ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 10)

            VStack(alignment: .leading, spacing: 5) {
                ForEach(order.forheed ?? []) { item in
                    HStack {
                        Text(item.daceloninae ?? "")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Spacer()
                        Text(item.basilicae ?? "")
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                    }
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
            if let privacy = order.deactivations {
                Button {
                    print(order.romanticalism)
                } label: {
                    Text(privacy)
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                        .underline()
                }
            }
            
            Spacer()
            
            Button {
                onApplyTap(order.intertwist ?? "")
            } label: {
                Text(order.bullrushes ?? "")
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
