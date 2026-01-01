//
//  ContactsView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/30.
//

import SwiftUI

struct ContactsView: View {
    @State var prodId: String = ""
    @State var contactModel: UserContactModel?
    @EnvironmentObject private var router: NavigationRouter
    @EnvironmentObject var appSeting: AppSettings
    @State private var showLoading = false
    @State var screenName: String
    
    var body: some View {
        content
            .customBackButton(action: .popTo(destination: .certify))
    }
    
    var content: some View {
        VStack {
            ScrollView {
                contactList
                    .padding(.top, 16)
            }
            
            Spacer()
            PrimaryButton(title: LocalizeContent.next.text()) {
                onsubmitContacts()
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle(Text(screenName))
        .loading(isLoading: $showLoading)
        .onAppear {
            onFetchContactInfo()
            appSeting.adressManager.startUpdatingLocation()
            TrackHelper.share.onCatchUserTrack(type: .contact)
        }
    }
    
    var contactList: some View {
        VStack(spacing: 30) {
            ForEach(self.contactModel?.unthrobbing ?? []) { item in
                ContactItem(item: item)
            }
        }
    }
}

extension ContactsView {
    func onFetchContactInfo() {
        showLoading = true
        Task {
            do {
                let payload = GetContactInfoPayload(christhood: prodId)
                let homeResponse: PJResponse<UserContactModel> = try await NetworkManager.shared.request(payload)
                self.contactModel = homeResponse.unskepticalness
                showLoading = false
            } catch {
                showLoading = false
            }
        }
    }
    
    func onsubmitContacts() {
        showLoading = true
        Task {
            do {
                let contactDictionaries = contactModel?.unthrobbing?.map { item in
                    return [
                        "singularly": item.singularly ?? "",
                        "contendent": item.contendent ?? "",
                        "marrowbone": item.marrowbone ?? ""
                    ]
                }
                guard let jsonData = try? JSONEncoder().encode(contactDictionaries),
                      let jsonString = String(data: jsonData, encoding: .utf8) else {
                    ToastManager.shared.show("Invalid Data")
                    showLoading = false
                    return
                }
                print("jsonString = \(jsonString)")
                let payload = SaveContactInfoPayload(christhood: prodId, unskepticalness: jsonString)
                let response: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payload)
                TrackHelper.share.onUploadRiskEvent(type: .contact, orderId: "")
                print("success")
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
        if let next = detailModel.noneuphoniousness?.oversceptical?.getDestinationPath(parameter: prodId, screenName: detailModel.noneuphoniousness?.daceloninae ?? "") { // 跳到下一项
            router.push(to: next)
        } else {
            router.pop(to: .certify)
        }
    }
}

#Preview {
    ContactsView(screenName: "")
}
