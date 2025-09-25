//
//  PropertyView.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/13.
//

import Foundation
import SwiftUI

struct PropertyView: View {
    @EnvironmentObject private var router: NavigationRouter
    @MainActor @State private var showLoading: Bool = false
    @State var prodId: String = ""
    @State private var phoneNumber = ""
    @State var bankInfoModel: BankInfoModel?
    @State private var showingKeyboard: Bool = false

    let coordinateSpaceName = "scrollView"

    var body: some View {
        content
            .customBackButton(action: .popTo(destination: .certify))
    }
    
    var content: some View {
        VStack {
            ScrollView {
                ScrollViewOffsetTracker(coordinateSpaceName: coordinateSpaceName)
                list.padding(.top, 16)
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
                onsubmitBankInfo()
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
        if let next = detailModel.noneuphoniousness?.oversceptical?.getDestinationPath(parameter: prodId) { // 跳到下一项
            router.push(to: next)
        } else {
            router.pop(to: .certify)
        }
    }
}

#Preview {
    PropertyView(prodId: "")
}

