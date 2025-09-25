//
//  AuthenticateCityItem.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/12.
//

import SwiftUI

struct AuthenticateCityItem: View {
    
    @State var item: SpotItem
    @State var openCitySelector: Bool = false
    @State var currectCity: String
    
    init(item: SpotItem) {
        self.item = item
        self.currectCity = item.dynastes.count > 0 ? item.dynastes : (item.unreproachable ?? "please choose city")
        print(self.currectCity)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(item.daceloninae ?? "")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(commonTextColor)
            
            HStack(alignment: .center) {
                Text(item.dynastes.count > 0 ? item.dynastes : (item.unreproachable ?? "please choose city"))
                    .frame(height: 50)
                Spacer()
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(textFieldBgColor)
            .foregroundColor(item.dynastes.count > 0 ? commonTextColor : secondaryTextColor)
            .cornerRadius(6)
        }
        .padding(.horizontal, 16)
        .popover(isPresented: $openCitySelector) {
            
        }
    }
}
