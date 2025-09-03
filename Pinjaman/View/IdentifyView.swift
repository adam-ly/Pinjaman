//
//  IdentifyView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/30.
//

import SwiftUI

struct IdentifyView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 14) {
            Text("Please fill in your personal data (don't worry, your information and data are protected)")
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(tipsbgColor)
                .foregroundColor(tipsColor)
                        
            VStack(spacing: 28) {
                VStack(spacing: 14) {
                    Text("PAN Card Front")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(commonTextColor)
                    Button {
                        
                    } label: {
                        Image("good_person_card")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 38)
                    }
                }

                
                VStack(spacing: 14) {
                    Text("Face recognition")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(commonTextColor)
                    Button {
                        
                    } label: {
                        Image("good_person_face")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 100)
                    }
                }
            }
            
            Spacer()
            
            PrimaryButton(title: "Next") {
                
            }
            .padding(.horizontal, 24)
        }
        .padding(0)
    }
}

#Preview {
    IdentifyView()
}
