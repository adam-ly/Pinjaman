//
//  AuthenticationVie.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/30.
//

import SwiftUI

struct WorkAuthenticationVieW: View {
    
    @State var prodId: String = ""
    @State private var phoneNumber = ""

    // 控制全屏下拉菜单的显示
    @State private var isShowingDropdown = false
    @State var workModel: UserWorkModel?

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
                onsubmitWorkInfo()
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
            ForEach(workModel?.spot ?? []) { item in
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

extension WorkAuthenticationVieW {
    func onFetchUserInfo() {
        Task {
            do {
                let payload = GetWorkInfoPayload(christhood: prodId)
                let homeResponse: PJResponse<UserWorkModel> = try await NetworkManager.shared.request(payload)
                self.workModel = homeResponse.unskepticalness
            } catch {
                
            }
        }
    }
    
    func onsubmitWorkInfo() {
        var param:[String: String] = ["christhood": prodId]
        for item in self.workModel?.spot ?? [] {
            print("item.goss = \(item.goss) item.oxystome = \(item.oxystome) item.dynastes = \(item.dynastes) ")
            if item.machiavellian == "Adinida" { // option
                param[item.goss ?? ""] = item.oxystome
            } else {
                param[item.goss ?? ""] = item.dynastes
            }
        }
        print("param = \(param)")
        Task {
            do {
                let payload = SaveWorkInfoPayload(param: param)
                let homeResponse: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payload)
                print("sucess")
                onFetchUserInfo()
            } catch {
                
            }
        }
        
    }
}

