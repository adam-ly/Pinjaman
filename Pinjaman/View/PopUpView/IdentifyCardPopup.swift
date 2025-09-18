//
//  IdentifyCardPopup.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/18.
//

import SwiftUI

struct IdentifyCardPopup: View {
    var identityType: String = "11"
    var onConfirm: () -> Void
    var body: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            ZStack(alignment: .top) {
                VStack(spacing: 10) {
                    Text(LocalizeContent.cardPopUpTitle.text())
                        .font(.system(size: 14, weight: .medium))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)

                    Image(isCard() ? "pd_cardFront_popup_titleImg" : "pd_faceFront_popup_titleImg")

                    Text(LocalizeContent.cardPopUpDesc.text())
                        .font(.system(size: 14, weight: .medium))
                    
                    HStack {
                        VStack(alignment: .center) {
                            Image(isCard() ? "pd_cardFront_popup_guide_01" : "pd_faceFront_popup_guide_01")
                            Image("pd_identity_popup_wrong")
                        }
                        VStack(alignment: .center) {
                            Image(isCard() ? "pd_cardFront_popup_guide_02" : "pd_faceFront_popup_guide_02")
                            Image("pd_identity_popup_wrong")
                        }
                        VStack(alignment: .center) {
                            Image(isCard() ? "pd_cardFront_popup_guide_03" : "pd_faceFront_popup_guide_03")
                            Image("pd_identity_popup_wrong")
                        }
                    }
                    
                    Text(LocalizeContent.cardPopUpContent.text())
                        .font(.system(size: 14, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                }
                .padding(.horizontal, 20)
                .padding(.top, 55)
                
                VStack {
                    Spacer()
                    PrimaryButton(title: LocalizeContent.confirm.text()) {
                        onConfirm()
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
                        Text(isCard() ? LocalizeContent.cardPopUpWindowTitle.text() : LocalizeContent.facePopUpWindowTitle.text())
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
    
    func isCard() -> Bool {
        return identityType == "11"
    }
}

#Preview {
    IdentifyCardPopup(identityType: "11") { 
        
    }
}
