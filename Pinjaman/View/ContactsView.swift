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
    
    var body: some View {
        VStack {
            ScrollView {
                content
                    .padding(.top, 16)
            }
            Spacer()
            
            PrimaryButton(title: "Next") {
                onsubmitContacts()
            }
            .padding(.horizontal, 24)
        }
        .hideTabBarOnPush(showTabbar: false)
        .navigationTitle(Text("Emergency contact"))
        .onAppear {
            onFetchContactInfo()
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
        Task {
            do {
                let payload = GetContactInfoPayload(christhood: prodId)
                let homeResponse: PJResponse<UserContactModel> = try await NetworkManager.shared.request(payload)
                self.contactModel = homeResponse.unskepticalness
            } catch {
                
            }
        }
    }
    
    func onsubmitContacts() {
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
                    return
                }
                print("jsonString = \(jsonString)")
                let payload = SaveContactInfoPayload(christhood: prodId, unskepticalness: jsonString)
                let response: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payload)
                print("success")
            } catch {
                
            }
        }
    }
}

#Preview {
    ContactsView()
}
