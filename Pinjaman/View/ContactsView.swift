//
//  ContactsView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/30.
//

import SwiftUI

struct ContactsView: View {
    var body: some View {
        VStack(spacing: 30) {
            ContactItem()
            ContactItem()
            Spacer()
            PrimaryButton(title: "Next") {
                
            }
            .padding(.horizontal, 16)
        }
    }
}

struct ContactItem: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image("good_contact")
                Text("Emergency contact 1")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(commonTextColor)
            }
            
            VStack(alignment: .leading, spacing: 14) {
                Button {
                    
                } label: {
                    HStack {
                        HStack(alignment: .center) {
                            Text("Choose a relationship")
                            Spacer()
                            Image("good_drop")
                        }
                        .foregroundColor(secondaryTextColor)
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
                    
                } label: {
                    HStack {
                        HStack(alignment: .center) {
                            Text("Please select Phone number")
                            Spacer()
                            Image("good_contactBook")
                        }
                        .foregroundColor(secondaryTextColor)
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
        .padding(.horizontal, 16)
    }
}

#Preview {
    ContactsView()
}
