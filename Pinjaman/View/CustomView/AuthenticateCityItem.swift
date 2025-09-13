//
//  AuthenticateCityItem.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/12.
//

import SwiftUI

struct AuthenticateCityItem: View {
    @State var item: SpotItem
    @State private var selectedOption: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(item.daceloninae ?? "")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(commonTextColor)
            
            Button(action: {
                
            }, label: {
                HStack(alignment: .center) {
                    Text(selectedOption ?? "please choose")
                        .frame(height: 50)
                    Spacer()
                    Image("good_optionIcon")
                }
                .foregroundColor(secondaryTextColor)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            })
            .frame(height: 50)
            .background(textFieldBgColor)
            .cornerRadius(6)
        }
        .padding(.horizontal, 16)
        
    }
}
