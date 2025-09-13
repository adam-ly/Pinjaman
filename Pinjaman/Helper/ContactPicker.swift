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
            var phoneNumber: String = "No Number"
            if let number = contact.phoneNumbers.first?.value.stringValue {
                phoneNumber = number.filter { $0.isNumber }
            }
            // 调用闭包，将数据传回
            self.parent.onCompletion((name: fullName, number: phoneNumber))
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
