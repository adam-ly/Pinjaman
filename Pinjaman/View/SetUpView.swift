//
//  SetUpView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/24.
//

import SwiftUI

struct SetUpView: View {
    @EnvironmentObject private var router: NavigationRouter
    @EnvironmentObject var appSeting: AppSettings
    @MainActor @State private var showLoading: Bool = false
    var body: some View {
        VStack {
            // 主内容
            VStack(spacing: 30) {
                appIcon
                
                appVersion
                                
                cancelAndLogout
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle(LocalizeContent.setup.text())
    }
    
    var appIcon: some View {
        // 应用图标和名称
        VStack(spacing: 10) {
            Image("AppLogo") // 假设项目中有这个图标
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(16)

            Text(UIDevice.appName())
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
        }
        .padding(.top, 20)
    }
    
    var appVersion: some View {
        // 版本信息
        VStack {
            HStack {
                Text(LocalizeContent.version.text())
                    .font(.system(size: 16))
                    .foregroundColor(commonTextColor)
                Spacer()
                Text(UIDevice.appVersion())
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(commonTextColor)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(Color.white)
        .cornerRadius(10)
    }
    
    var cancelAndLogout: some View {
        // 选项列表
        VStack(spacing: 1) {
            // 账户取消
            Button {                
                router.push(to: NavigationPathElement.init(destination: .cancellation, parameter: ""))
            } label: {
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.pink)
                        .frame(width: 24, height: 24)

                    Text(LocalizeContent.cancellation.text())
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(Color.white)
            }

            // 登出
            Button {
                logout()
            } label: {
                HStack {
                    Image(systemName: "arrow.left.square")
                        .foregroundColor(.pink)
                        .frame(width: 24, height: 24)

                    Text(LocalizeContent.logout.text())
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(Color.white)
            }
        }
        .cornerRadius(10)
    }
    
    var explaination: some View {
        // 底部内容
        Text("© 2025 Pinjaman Hebat. All rights reserved.")
            .font(.system(size: 12))
            .foregroundColor(.gray)
            .padding(.bottom, 20)
    }
}

extension SetUpView {    
    func logout() {
        Task {
            do {
                showLoading = true
                let payLoad = LogoutPayload()
                let loginResponse: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payLoad)
                showLoading = false
                appSeting.logout()
//                navigationState.shouldGoToRoot = false
                router.popToRoot()
                NotificationCenter.default.post(name: .didLogout, object: nil)
            } catch {
                showLoading = false
            }
        }
    }
}

struct SetUpView_Previews: PreviewProvider {
    static var previews: some View {
        SetUpView()
    }
}
