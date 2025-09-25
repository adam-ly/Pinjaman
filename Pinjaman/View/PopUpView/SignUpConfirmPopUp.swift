//
//  LoginConfirmPopUp.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/18.
//

import SwiftUI

struct SignUpConfirmPopUp: View {
    var onTap: ()->Void
    var onClose: () -> Void
    var body: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            ZStack(alignment: .top) {
                VStack(spacing: 15) {
                    Text(LocalizeContent.signout.text())
                        .font(.system(size: 22, weight: .medium))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)

                    Text(LocalizeContent.signoutAlert.text())
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16, weight: .regular))
                        .lineSpacing(6)
                        .foregroundColor(commonTextColor)
                        .padding(.horizontal, 10)
                    Spacer()
                }
                .padding(.horizontal, 50)
                .padding(.top, 70)
                
                VStack {
                    Spacer()
                    PrimaryButton(title: LocalizeContent.signout.text()) {
                        onTap()
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 10)
                }
                
            }.background(
                ZStack(alignment: .top, content: {
                    Image("signup_popup")
                        .resizable()
                        .frame(height: 265)
                    HStack {
                        Text(LocalizeContent.signout.text())
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.top,5)
                        Spacer()
                    }
                    .padding(.leading, 15)
                    
                    HStack {
                        Spacer()
                        Image("pd_popupClose")
                            .onTapGesture {
                                onClose()
                            }
                    }
                    .padding(.top, 20)
                    .padding(.trailing, 10)
                })
            )
            .frame(height: 265)
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    SignUpConfirmPopUp {
        
    } onClose: {
        
    }
}
