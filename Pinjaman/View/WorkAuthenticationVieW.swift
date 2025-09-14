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
    @MainActor @State private var showLoading: Bool = false
    @State private var destination: (String, String) = ("","")
    @State private var shouldPush: Bool = false
    // 控制全屏下拉菜单的显示
    @State private var isShowingDropdown = false
    @State var workModel: UserWorkModel?
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
                onsubmitWorkInfo()
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle(Text("Authentication Security"))
        .hideTabBarOnPush(showTabbar: false)
        .loading(isLoading: $showLoading)
        .onAppear {
            onFetchUserInfo()
            TrackHelper.share.onCatchUserTrack(type: .jobInfo)
        }
        .overlay(content: {
            if showCityPicker {
                ZStack(alignment: .bottom) {
                    Color.clear.ignoresSafeArea()
                    CityPickerView(present: $showCityPicker, onCallBack: { address in
                        if let index = self.workModel?.spot?.firstIndex(where: { $0.goss == self.cityItem?.goss }) {
                            let userModel = self.workModel
                            workModel?.spot?[index].dynastes = address
                            self.workModel = userModel
                        }
                    })
                }
            }
        })
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
                        .onTapGesture {
                            hideKeyboard()
                            self.cityItem = item
                            showCityPicker = true
                        }
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
                showLoading = true
                let payload = GetWorkInfoPayload(christhood: prodId)
                let homeResponse: PJResponse<UserWorkModel> = try await NetworkManager.shared.request(payload)
                self.workModel = homeResponse.unskepticalness
                showLoading = false
            } catch {
                showLoading = false
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
                showLoading = true
                let payload = SaveWorkInfoPayload(param: param)
                let homeResponse: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payload)
                print("sucess")
                TrackHelper.share.onUploadRiskEvent(type: .jobInfo, orderId: "")
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

