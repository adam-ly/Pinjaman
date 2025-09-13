//
//  UserInfomationView.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/11.
//

import SwiftUI

struct UserInfomationView: View {
    @State var prodId: String = ""
    @State private var phoneNumber = ""

    // 控制全屏下拉菜单的显示
    @State private var isShowingDropdown = false
    @State var userInfoModel: UserIndivisualModel?

    let coordinateSpaceName = "scrollView"

    var body: some View {
        VStack {
            ScrollView {
                ScrollViewOffsetTracker(coordinateSpaceName: coordinateSpaceName)
                list
                .padding(.top, 16)
            }
            .coordinateSpace(name: coordinateSpaceName)
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { offset in
                hideKeyboard()
                NotificationCenter.default.post(name: .userInfoScrolling, object: nil)
            }
            
            Spacer()
            
            PrimaryButton(title: "Next") {
                onsubmitUserInfo()
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle(Text("Authentication Security"))
        .hideTabBarOnPush(showTabbar: false)
        .onAppear {
            onFetchUserInfo()
        }
    }
    
    var list: some View {
        VStack(spacing: 20) {
            ForEach(userInfoModel?.spot ?? []) { item in
                switch item.machiavellian {
                case "Adinida":
                    AuthenticateOptionItem(item: item)
                case "Buber":
                    AuthenticateTextItem(item: item)
                case "Whitsun":
                    AuthenticateCityItem(item: item)
                default: Text("")
                }
            }
        }
    }
}

extension UserInfomationView {
    func onFetchUserInfo() {
        Task {
            do {
                let payload = GetUserInfoSecondItemPayload(christhood: prodId)
                let homeResponse: PJResponse<UserIndivisualModel> = try await NetworkManager.shared.request(payload)
                self.userInfoModel = homeResponse.unskepticalness
            } catch {
                
            }
        }
    }
    
    func onsubmitUserInfo() {
        var param:[String: String] = ["christhood": prodId]
        for item in self.userInfoModel?.spot ?? [] {
//            print("item.goss = \(item.goss) item.oxystome = \(item.oxystome) item.dynastes = \(item.dynastes) ")
            if item.machiavellian == "Adinida" { // option
                param[item.goss ?? ""] = item.oxystome
            } else {
                param[item.goss ?? ""] = item.dynastes
            }
        }
        print("param = \(param)")
        Task {
            do {
                let payload = SaveUserInfoSecondItemPayload(param: param)
                let homeResponse: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payload)
                print("sucess")
                onFetchUserInfo()
            } catch {
                
            }
        }
        
    }
}

#Preview {
    UserInfomationView(prodId: "")
}
