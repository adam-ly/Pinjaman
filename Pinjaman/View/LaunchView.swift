//
//  LaunchView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/24.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("launch")
                .resizable()
                .ignoresSafeArea()
            PrimaryButton(title: "button") {
                
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
        .onAppear {
            checkNetwork()
        }
    }
    
    func checkNetwork() {
        
    }
}

#Preview {
    LaunchView()
}
