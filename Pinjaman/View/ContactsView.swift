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
    @State private var showLoading = false
    @State private var destination: (String, String) = ("","")
    @State private var shouldPush: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                content
                    .padding(.top, 16)
            }
            
            NavigationLink(destination: NavigationManager.navigateTo(for: destination.0, prodId: destination.1),
                           isActive: $shouldPush) {}
            
            Spacer()
            PrimaryButton(title: "Next") {
                onsubmitContacts()
            }
            .padding(.horizontal, 24)
        }
        .hideTabBarOnPush(showTabbar: false)
        .navigationTitle(Text("Emergency contact"))
        .loading(isLoading: $showLoading)
        .onAppear {
            onFetchContactInfo()
            TrackHelper.share.onCatchUserTrack(type: .contact)
        }
    }
    
    var content: some View {
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
        showLoading = false
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
                print("success")
//                showLoading = false
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
    ContactsView()
}
