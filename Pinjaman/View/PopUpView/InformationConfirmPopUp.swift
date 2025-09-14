//
//  InformationConfirmPopUp.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/11.
//

import SwiftUI

struct InformationConfirmPopUp: View {
    @Binding var isPresented: Bool
    @Binding var identityCardModel: IdentityCardResponse?
    
    var onConfirm: (([String: String]) -> Void)?
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(isPresented ? 0.4 : 0)
                .ignoresSafeArea()

            ZStack(alignment: .top) {
                VStack(spacing: 10) {
                    ForEach(identityCardModel?.unexcorticated ?? []) { item in
                        if item.goss == "geanticlinal" {
                            ConfirmationTimeItem(item: item)
                        } else {
                            ConfirmationTextItem(item: item)
                        }
                    }
                    Text("Check identity information and make sure it is true after sending it cannot be changed!")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(linkTextColor)
                        .padding(.horizontal, 10)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 80)
                
                VStack {
                    Spacer()
                    PrimaryButton(title: "Confirm") {
                        isPresented = false
                        onConfirm?(getParam())
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                }
                
            }.background (
                ZStack(alignment: .top, content: {
                    Image("pd_popupBg")
                        .resizable()
                        .frame(height: 508)
                    HStack {
                        Text("Confirm information")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.top,8)
                        Spacer()
                    }
                    .padding(.leading, 15)
                })
            )
            .frame(height: 508)
            .padding(.horizontal, 30)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    func getParam() -> [String: String] {
        return identityCardModel?.unexcorticated?.reduce(into: [String: String]()) { dictionary, item in
            // 确保 samplings 和 estaminets 都不为 nil
            if let key = item.goss, let value = item.estaminets as? String {
                dictionary[key] = value
            }
        } ?? ["":""]
    }
}

struct ConfirmationTextItem: View {
    @State var item: IdentityInfoItem
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(item.samplings ?? "")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(commonTextColor)
        
            HStack {
                TextField("Please fill out", text: $item.estaminets)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .foregroundColor(.black)
                    .accentColor(.black)
                    .focused($isFocused)
            }
            .foregroundColor(secondaryTextColor)
            .background(textFieldBgColor)
            .frame(height: 44)
            .cornerRadius(10)
        }
        .foregroundColor(commonTextColor)
        .padding(.horizontal, 16)
    }
}

struct ConfirmationTimeItem: View {
    @State var item: IdentityInfoItem
    @State private var selectedDate = Date()
    @State var dateString: String
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        return formatter
    }()
    
    init(item: IdentityInfoItem) {
        self.item = item
        self.selectedDate = dateFormatter.date(from: item.estaminets) ?? Date()
        self.dateString = item.estaminets
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(item.samplings ?? "")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(commonTextColor)
        
            ZStack {
                ZStack {
                    DatePicker( "",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .tint(linkTextColor)
                    .labelsHidden() // 隐藏 DatePicker 默认的标签
                    .datePickerStyle(.automatic)
                    .scaleEffect(x:4, y:1)
                    .onChange(of: selectedDate) { newValue in
                        self.item.estaminets = dateFormatter.string(from: selectedDate)
                        self.dateString = self.item.estaminets
                        print("self.dateString = \(self.dateString)")
                    }
                    
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(textFieldBgColor)
                        .background(textFieldBgColor)
                        .frame(height: 44)
                        .allowsHitTesting(false)
                }
                
                HStack(content: {
                    Text(dateString)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .foregroundColor(commonTextColor)
                    Spacer()
                })
                .allowsHitTesting(false)
            }
            .foregroundColor(secondaryTextColor)
            .frame(height: 44)
            .cornerRadius(10)
        }
        .foregroundColor(commonTextColor)
        .padding(.horizontal, 16)
    }
}
