//
//  PropertyView.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/13.
//

import Foundation
import SwiftUI

struct PropertyView: View {
    @State var prodId: String = ""
    @State private var phoneNumber = ""

    // 控制全屏下拉菜单的显示
    @State private var isShowingDropdown = false
    @State var bankInfoModel: BankInfoModel?

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
                onsubmitBankInfo()
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
            ForEach(bankInfoModel?.spot ?? []) { item in
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

extension PropertyView {
    func onFetchUserInfo() {
        Task {
            do {
                let payload = GetBankInfoPayload(christhood: prodId)
                let homeResponse: PJResponse<BankInfoModel> = try await NetworkManager.shared.request(payload)
                self.bankInfoModel = homeResponse.unskepticalness
            } catch {
                
            }
        }
    }
    
    func onsubmitBankInfo() {
        var param:[String: String] = ["christhood": prodId]
        for item in self.bankInfoModel?.spot ?? [] {
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
    PropertyView(prodId: "")
}
