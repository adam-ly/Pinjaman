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
        self.phoneNumber = item.dynastes
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(item.daceloninae ?? "")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(commonTextColor)
        
            HStack {
                TextField(item.dynastes.count > 0 ? item.dynastes : (item.unpreferable ?? "Please fill out"), text: $phoneNumber)
                    .onChange(of: phoneNumber) { value in
                        item.dynastes = phoneNumber
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .tint(.linkText)
                    .foregroundColor(.black)
            }
            .foregroundColor(secondaryTextColor)
            .background(textFieldBgColor)
            .frame(height: 50)
            .cornerRadius(6)
        }
        .foregroundColor(commonTextColor)
        .padding(.horizontal, 16)
    }
}

//#Preview {
//    AuthenticateTextItem(item: SpotItem(from: ["":""]))
//}
