//
//  AuthenticationVie.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/30.
//

import SwiftUI

struct WorkAuthenticationVieW: View {
    @EnvironmentObject var navigationState: NavigationState
    @State var prodId: String = ""
    @State private var phoneNumber = ""
    @MainActor @State private var showLoading: Bool = false
    @State private var isShowingDropdown = false
    @State var workModel: UserWorkModel?
    @State var showCityPicker: Bool = false
    @State var cityItem: SpotItem?
    @State private var showingKeyboard: Bool = false
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
                if self.showingKeyboard {                    
                    hideKeyboard()
                    NotificationCenter.default.post(name: .userInfoScrolling, object: nil)
                }
            }
            Spacer()
            
            PrimaryButton(title: LocalizeContent.next.text()) {
                onsubmitWorkInfo()
            }
            .padding(.horizontal, 24)
            .ignoresSafeArea(.keyboard, edges: .bottom) // 讓視圖忽略鍵盤安全區
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.showingKeyboard = true
            })
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            self.showingKeyboard = false
        }
        .navigationTitle(Text(LocalizeContent.authentication.text()))
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
            navigationState.destination = next
            navigationState.param = prodId
            navigationState.shouldGoToRoot = true
        } else {
            navigationState.shouldGoToRoot = false
        }
    }
}

