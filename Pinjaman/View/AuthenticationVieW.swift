//
//  AuthenticationVie.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/30.
//

import SwiftUI

enum AuthenticationType {
    case text
    case option
}

struct AuthenticationVieW: View {
    
    @State private var phoneNumber = ""
    
    var body: some View {
        VStack(spacing: 20) {
            AuthenticateTextItem()
            AuthenticateOptionItem()
        }
    }

    func AuthenticateTextItem() -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Title")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(commonTextColor)
        
            HStack {
                TextField("Please fill out", text: $phoneNumber)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .foregroundColor(.black)
                    .accentColor(.black)
            }
            .foregroundColor(secondaryTextColor)
            .background(textFieldBgColor)
            .frame(height: 50)
            .cornerRadius(6)
        }
        .foregroundColor(commonTextColor)
        .padding(.horizontal, 16)
    }        
}

struct AuthenticateOptionItem: View {
    private let dropdownOptions = ["Option A", "Option B", "Option C"]

    // State variable to track whether the dropdown is shown.
    @State private var isShowingDropdown = false
    @State private var selectedOption: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Title")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(commonTextColor)

            Button(action: {
                // Toggling the state variable to show/hide the dropdown.
                isShowingDropdown.toggle()
            }, label: {
                HStack(alignment: .center) {
                    Text(selectedOption ?? "please choose")
                    Spacer()
                    Image("good_optionIcon")
                }
                .foregroundColor(secondaryTextColor)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
            })
            .frame(height: 50)
            .background(textFieldBgColor)
            .cornerRadius(6)
            // Use .overlay() to place the dropdown view on top
            .overlay(
                VStack(alignment: .leading, spacing: 0) {
                    if isShowingDropdown {
                        ForEach(dropdownOptions, id: \.self) { option in
                            Button(action: {
                                self.selectedOption = option
                                self.isShowingDropdown = false
                            }) {
                                Text(option)
                                    .foregroundColor(commonTextColor)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, 12)
                        }
                        .background(Color.white)
                    }
                }
                .offset(y: 50)
                ,alignment: .topLeading
            )
        }
        .padding(.horizontal, 16)
        // Add a tap gesture to dismiss the dropdown when tapping outside
        .onTapGesture {
            self.isShowingDropdown = false
        }
    }
}


#Preview {
    AuthenticationVieW()
}
