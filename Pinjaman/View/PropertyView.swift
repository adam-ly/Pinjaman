//
//  PropertyView.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/13.
//

import Foundation
import SwiftUI

struct PropertyView: View {
    @EnvironmentObject var navigationState: NavigationState
    @MainActor @State private var showLoading: Bool = false
    @State var prodId: String = ""
    @State private var phoneNumber = ""
    @State var bankInfoModel: BankInfoModel?

    let coordinateSpaceName = "scrollView"

    var body: some View {
        VStack {
            ScrollView {
                ScrollViewOffsetTracker(coordinateSpaceName: coordinateSpaceName)
                list.padding(.top, 16)
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
        .ignoresSafeArea(.keyboard, edges: .bottom) // 讓視圖忽略鍵盤安全區
        .navigationTitle(Text("Authentication Security"))
        .loading(isLoading: $showLoading)
        .onAppear {
            onFetchBankInfo()
            TrackHelper.share.onCatchUserTrack(type: .bindCard)
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
    func onFetchBankInfo() {
        Task {
            do {
                showLoading = true
                let payload = GetBankInfoPayload(christhood: prodId)
                let homeResponse: PJResponse<BankInfoModel> = try await NetworkManager.shared.request(payload)
                showLoading = false
                self.bankInfoModel = homeResponse.unskepticalness
            } catch {
                showLoading = false
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
                showLoading = true
                let payload = SubmitBankInfoPayload(param: param)
                let homeResponse: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payload)
                TrackHelper.share.onUploadRiskEvent(type: .bindCard, orderId: "")
                print("sucess")
//                showLoading = false
//                onFetchBankInfo()
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

#Preview {
    PropertyView(prodId: "")
}
