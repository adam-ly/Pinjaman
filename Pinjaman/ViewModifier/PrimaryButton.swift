//
//  PrimaryButton.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/24.
//

import SwiftUI

struct PrimaryButton: View {
    var title: String = ""
    var height: CGFloat = 50
    var font: Font = .system(size: 17, weight: .heavy)
    var backgroundColor: Color = Color("primaryColor")
    
    var onTap: ()->Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: height * 0.5)
                    .frame(height: height)
                    .foregroundColor(backgroundColor)
                Text(title)
                    .foregroundColor(.white)
                    .font(font)
            }
        }
    }
}

#Preview {
    PrimaryButton(title: "button") {
        
    }
    .padding(.horizontal,10)
    
}
