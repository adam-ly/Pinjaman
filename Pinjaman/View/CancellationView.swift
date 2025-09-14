//
//  CancellationView.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/11.
//

import SwiftUI

struct CancellationView: View {
    @EnvironmentObject var appSeting: AppSettings
    @MainActor @State private var showLoading: Bool = false
    @State private var agree = false

    var body: some View {
        content
            .hideTabBarOnPush(showTabbar: false)
            .navigationTitle(appSeting.userCenterModel?.roshelle?.daceloninae ?? "")
    }
    
    var content: some View {
        VStack(spacing: 36) {
            Image("me_cancellation")
            Text(appSeting.userCenterModel?.roshelle?.anticreationist ?? "")
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
            Text(appSeting.userCenterModel?.roshelle?.expatriated ?? "")
                .font(.system(size: 14, weight: .regular))
        }
        .padding(.horizontal, 16)
    }
    
    func onCancellation() {
        guard agree else {
            return
        }
        
        Task {
            do {
                showLoading = true
                let payload = DeactivateAccountPayload()
                let response: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payload)
                showLoading = false
                appSeting.logout()
            } catch {
                showLoading = false
            }
        }
    }
}

#Preview {
    CancellationView()
}
