//
//  LornAgreementPopup.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/11.
//

import SwiftUI

struct LornAgreementPopup: View {
    var body: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            ZStack(alignment: .top) {
                VStack(spacing: 10) {
                    Text("Loan Agreement")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)

                    Text("Pinjaman Hebat App is a professionalpersonal credit loan application that canprovide users with up to 80000 yuan infunding services with simple information.We have provided financial services toover one million users, helping themsolve various financial")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14, weight: .regular))
                        .lineSpacing(6)
                        .foregroundColor(commonTextColor)
                        .padding(.horizontal, 10)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 80)
                
                VStack {
                    Spacer()
                    PrimaryButton(title: "Confirm") {
                        //                        onConfirm
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                }
                
            }.background(
                ZStack(alignment: .top, content: {
                    Image("pd_popupBg")
                        .resizable()
                        .frame(height: 450)
                    HStack {
                        Text("Please read carefully")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.top,8)
                        Spacer()
                    }
                    .padding(.leading, 15)
                })
            )
            .frame(height: 450)
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    LornAgreementPopup()
}
