//
//  CancellationView.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/11.
//

import SwiftUI

struct CancellationView: View {
    @State private var agree = true

    var body: some View {
        VStack(spacing: 36) {
            Image("me_cancellation")
            Text("The account cannot be restored after cancellation. To ensure the security of your account, before submitting a request, please confirm that you have successfully managed the services related to your account and note:")
                .multilineTextAlignment(.center)
                .font(.system(size: 16, weight: .regular))
                .padding(.horizontal, 24)
            Spacer()
            agreement
            PrimaryButton(title: "Confirm") {

            }
            .padding(.horizontal, 60)
        }.padding(.top, 36)
    }
    
    var agreement: some View {
        HStack {
            Button {
                agree.toggle()
            } label: {
                Image(agree ? "option_select" : "option_unselect")
            }
            
            Text("I consent to the")
                .foregroundColor(secondaryTextColor)
            Text("<Privacy policy>")
                .underline()
                .onTapGesture {
                    print("privacy click")
                }
        }
    }
}

#Preview {
    CancellationView()
}
