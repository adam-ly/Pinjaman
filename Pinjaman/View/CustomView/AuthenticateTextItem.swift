//
//  AuthenticateTextItem.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/12.
//

import SwiftUI

struct AuthenticateTextItem: View {
    @State var item: SpotItem
    @State var phoneNumber: String = ""
    
    init(item: SpotItem) {
        self.item = item
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(item.daceloninae ?? "")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(commonTextColor)
        
            HStack {
                TextField(phoneNumber.count > 0 ? phoneNumber : (item.unreproachable ?? "Please fill out"), text: $phoneNumber)
                    .onChange(of: phoneNumber) { value in
                        print("phoneNumber = \(phoneNumber) value = \(value)")
                        item.dynastes = value
                    }
                    .tint(linkTextColor)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .keyboardType(item.obtected == 1 ? .numberPad : .default)
                    .tint(.linkText)
                    .foregroundColor(.black)
            }
            .foregroundColor(item.dynastes.count > 0 ? commonTextColor : secondaryTextColor)
            .background(textFieldBgColor)
            .frame(height: 50)
            .cornerRadius(6)
        }
        .foregroundColor(commonTextColor)
        .padding(.horizontal, 16)
        .onAppear {
            self.phoneNumber = item.dynastes
        }
    }
}
