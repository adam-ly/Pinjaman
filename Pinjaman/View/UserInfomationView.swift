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
    @MainActor @State private var showLoading: Bool = false
    @State private var destination: (String, String) = ("","")
    @State private var shouldPush: Bool = false
    // 控制全屏下拉菜单的显示
    @State var userInfoModel: UserIndivisualModel?
    @State var showCityPicker: Bool = false
    @State var cityItem: SpotItem?
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
            
            NavigationLink(destination: NavigationManager.navigateTo(for: destination.0, prodId: destination.1),
                           isActive: $shouldPush) {}
            
            Spacer()
            
            PrimaryButton(title: "Next") {
                onsubmitUserInfo()
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle(Text("Authentication Security"))
        .hideTabBarOnPush(showTabbar: false)
        .loading(isLoading: $showLoading)
        .onAppear {
            onFetchUserInfo()
            TrackHelper.share.onCatchUserTrack(type: .personalInfo)
        }
        .overlay(content: {
            if showCityPicker {
                ZStack(alignment: .bottom) {
                    Color.clear.ignoresSafeArea()
                    CityPickerView(present: $showCityPicker, onCallBack: { address in
                        if let index = self.userInfoModel?.spot?.firstIndex(where: { $0.goss == self.cityItem?.goss }) {
                            let userModel = self.userInfoModel
                            userInfoModel?.spot?[index].dynastes = address
                            self.userInfoModel = userModel
                        }
                    })
                }
            }
        })
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
                        .onTapGesture {
                            hideKeyboard()
                            self.cityItem = item
                            showCityPicker = true
                        }
                default:
                    Text("")
                }
            }
        }
    }
}

extension UserInfomationView {
    func onFetchUserInfo() {
        Task {
            do {
                showLoading = true
                let payload = GetUserInfoSecondItemPayload(christhood: prodId)
                let homeResponse: PJResponse<UserIndivisualModel> = try await NetworkManager.shared.request(payload)
                showLoading = false
                self.userInfoModel = homeResponse.unskepticalness
            } catch {
                showLoading = false
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
                showLoading = true
                let payload = SaveUserInfoSecondItemPayload(param: param)
                let homeResponse: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payload)
                print("sucess")
                TrackHelper.share.onUploadRiskEvent(type: .personalInfo, orderId: "")

//                showLoading = false
//                onFetchUserInfo()
                onCheckNext()
            } catch {
                showLoading = false
            }
        }
    }
    
    func onCheckNext() {
        Task {
            do {
                let payload = ProductDetailsPayload(christhood: prodId)
                let response: PJResponse<ProductDetailModel> = try await NetworkManager.shared.request(payload)
                showLoading = false
                onGoToNext(detailModel: response.unskepticalness)
            } catch {
                showLoading = false
            }
        }
    }
    
    func onGoToNext(detailModel: ProductDetailModel) {
        if let next = detailModel.noneuphoniousness?.oversceptical { // 跳到下一项
            destination = (next, prodId)
            shouldPush = next.count > 0
        }
    }
}

#Preview {
    UserInfomationView(prodId: "")
}
