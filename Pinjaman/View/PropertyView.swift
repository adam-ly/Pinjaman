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
    @MainActor @State private var showLoading: Bool = false
    @State private var destination: (String, String) = ("","")
    @State private var shouldPush: Bool = false
    @State private var phoneNumber = ""
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
            
            NavigationLink(destination: NavigationManager.navigateTo(for: destination.0, prodId: destination.1),
                           isActive: $shouldPush) {}
            
            Spacer()
            
            PrimaryButton(title: "Next") {
                onsubmitBankInfo()
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle(Text("Authentication Security"))
        .hideTabBarOnPush(showTabbar: false)
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
            destination = (next, prodId)
            shouldPush = next.count > 0
        }
    }
}

#Preview {
    PropertyView(prodId: "")
}
