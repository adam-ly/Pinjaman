//
//  CancellationView.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/11.
//

import SwiftUI

struct CancellationView: View {
    @EnvironmentObject private var router: NavigationRouter
    @EnvironmentObject var appSeting: AppSettings
    @MainActor @State private var showLoading: Bool = false
    @State private var agree = false

    var body: some View {
        content
            .navigationTitle(appSeting.userCenterModel?.roshelle?.daceloninae ?? "")
    }
    
    var content: some View {
        ZStack {
            VStack(spacing: 36) {
                Image("me_cancellation")
                Text(appSeting.userCenterModel?.roshelle?.anticreationist ?? "")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16, weight: .regular))
                    .padding(.horizontal, 24)
                Spacer()
                agreement
                PrimaryButton(title: LocalizeContent.confirm.text()) {
                    onCancellation()
                }
                .padding(.horizontal, 60)
            }
            .padding(.top, 36)
        }
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
            ToastManager.shared.show(LocalizeContent.agreement.text())
            return
        }        
        cancellation()
    }
    
    func cancellation() {
        Task {
            do {
                showLoading = true
                let payload = DeactivateAccountPayload()
                let response: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payload)
                showLoading = false
                appSeting.logout()
                router.popToRoot()
                NotificationCenter.default.post(name: .didLogout, object: nil)
            } catch {
                showLoading = false
            }
        }
    }
}

#Preview {
    CancellationView()
}
