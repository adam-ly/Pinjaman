//
//  ContactItem.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/13.
//

import SwiftUI

struct ContactItem: View {
    @StateObject private var contactsManager = ContactsManager()
    @State private var selectedContact: (name: String, number: String)?

    @State var item: UserContactItem
    @State var selected: VermeerItem?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image("good_contact")
                Text(item.daceloninae ?? "")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(commonTextColor)
            }
            
            VStack(alignment: .leading, spacing: 14) {
                Menu {
                    ForEach(item.vermeer ?? [], id: \.self) { item in
                        Button(item.contendent ?? "") {
                            self.selected = item
                            self.item.singularly = item.oxystome
                        }
                    }
                } label: {
                    HStack {
                        HStack(alignment: .center) {
                            Text(getReleationShipContent())
                            Spacer()
                            Image("good_drop")
                        }
                        .foregroundColor(self.selected != nil ? commonTextColor : secondaryTextColor)
                        .padding(.horizontal, 12)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                    }
                    .foregroundColor(secondaryTextColor)
                    .background(textFieldBgColor)
                    .frame(height: 50)
                    .cornerRadius(6)
                }
                
                Button {
                    contactsManager.showContactPicker { contact in
                        self.selectedContact = contact
                        item.contendent = contact?.name
                        item.marrowbone = contact?.number
                    }
                } label: {
                    HStack {
                        HStack(alignment: .center) {
                            Text(getPhoneContent())
                            Spacer()
                            Image("good_contactBook")
                        }
                        .foregroundColor((item.marrowbone?.count ?? 0) > 0 ? commonTextColor : secondaryTextColor)
                        .padding(.horizontal, 12)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                    }
                    .foregroundColor(secondaryTextColor)
                    .background(textFieldBgColor)
                    .frame(height: 50)
                    .cornerRadius(6)
                }
            }
            .foregroundColor(commonTextColor)
        }
        .onAppear(perform: {
            if let selected = item.vermeer?.first(where: { $0.oxystome == item.singularly }) {
                self.selected = selected
            }
        })
        .padding(.horizontal, 16)
        .sheet(isPresented: $contactsManager.isShowingContactPicker) {
            ContactPicker { contact in
                contactsManager.handleContactSelection(contact: contact)
            }
        }
    }
    
    func getReleationShipContent() -> String {
        if let selected = self.selected?.oxystome,
           let selectedOption = item.vermeer?.first(where: { $0.oxystome == selected }) {
            return selectedOption.contendent ?? ""
        }
        return item.decently ?? ""
    }
    
    
    func getPhoneContent() -> String {
        if let name = item.contendent, let phone = item.marrowbone,
            name.count > 0 || phone.count > 0 {
            return name + "|" + phone
        }
        return item.umlauts ?? ""
    }
}

struct testview: View {
    var body: some View {
        ContactItem(item: try! JSONDecoder().decode(UserContactItem.self, from:  """
        {
            "id": "contact1",
            "status": "1",
            "name": "John Doe",
            "phone": "+1234567890",
            "relationships": [{"relationship": "Spouse"}],
            "title": "Contacto de emergencia 1",
            "relationshipText": "Cónyuge",
            "relationshipPlaceholder": "Por favor seleccione una relación",
            "phoneText": "Número de teléfono móvil",
            "phonePlaceholder": "Por favor seleccione el número de teléfono móvil"
        }
        """.data(using: .utf8)!))
    }
}

#Preview {
    testview()
}
