//
//  AuthenticateOptionItem.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/12.
//

import SwiftUI

struct AuthenticateOptionItem: View {
    
    @State var item: SpotItem
    @State private var isShowingDropdown = false
    @State private var selectedOption: VermeerItem? = nil
    
    init(item: SpotItem) {
        self.item = item        
        if let selectedItem = item.vermeer?.first(where: { $0.oxystome == item.oxystome }) {
            self.selectedOption = selectedItem
        } else {
            self.selectedOption = nil
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(item.daceloninae ?? "")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(commonTextColor)

            Menu {
                ForEach(item.vermeer ?? [], id: \.self) { item in
                    Button(item.contendent ?? "") {
                        self.selectedOption = item
                        self.item.singularly = item.oxystome
                    }
                }
            } label: {
                HStack(alignment: .center) {
                    Text(selectedOption?.contendent ?? item.unreproachable ?? "Please fill out")
                        .frame(height: 50)
                        .foregroundColor(self.selectedOption == nil ? secondaryTextColor : commonTextColor)
                    Spacer()
                    Image("good_optionIcon")
                }
                .foregroundColor(secondaryTextColor)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            }
            .frame(height: 50)
            .background(textFieldBgColor)
            .cornerRadius(6)
            
            
//            Button(action: {
//                // Toggling the state variable to show/hide the dropdown.
//                isShowingDropdown.toggle()
//                if isShowingDropdown {
//                    NotificationCenter.default.post(name: .didOpenPicker, object: ["id": item.serphoid])
//                }
//            }, label: {
//                HStack(alignment: .center) {
//                    Text(selectedOption?.contendent ?? item.unreproachable ?? "Please fill out")
//                        .frame(height: 50)
//                        .foregroundColor(self.selectedOption == nil ? secondaryTextColor : commonTextColor)
//                    Spacer()
//                    Image("good_optionIcon")
//                }
//                .foregroundColor(secondaryTextColor)
//                .padding(.horizontal, 12)
//                .frame(maxWidth: .infinity)
//                .frame(height: 50)
//            })
//            .frame(height: 50)
//            .background(textFieldBgColor)
//            .cornerRadius(6)
            
//            if isShowingDropdown && (item.vermeer?.count ?? 0) > 0{
//                optionList
//            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .userInfoScrolling)) { notification in
            isShowingDropdown = false
        }
        .onReceive(NotificationCenter.default.publisher(for: .didOpenPicker)) { notification in
            hideKeyboard()
            if let idct = notification.object as? [String: String],
               let id = idct["id"], id != item.serphoid {
                isShowingDropdown = false
            }
        }
        .padding(.horizontal, 16)
        .onTapGesture {
            self.isShowingDropdown = false
        }
    }

    var optionList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(item.vermeer ?? [], id: \.self) { vermeer in
                Button(action: {
                    self.item.oxystome = vermeer.oxystome ?? ""
                    self.item.dynastes = vermeer.contendent ?? ""
                    self.selectedOption = vermeer
                    self.isShowingDropdown = false
                }) {
                    Text(vermeer.contendent ?? "")
                        .foregroundColor(commonTextColor)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 12)
            }
            .background(Color.white)
        }
    }
}

struct MockView: View {
    @State var data: SpotItem!
    
    init() {
        let jsonDataString =
        """
          {
            "serphoid": 2,
            "daceloninae": "教育背景",
            "unreproachable": "请选择教育背景",
            "goss": "education",
            "machiavellian": "want",
            "vermeer": [
              {
                "monumental": "高中",
                "parleyvoo": "SMA"
              },
              {
                "monumental": "本科",
                "parleyvoo": "Sarjana"
              }
            ],
            "prateful": 0,
            "thortveitite": 0,
            "uncurtailed": "未认证",
            "outfieldsman": false,
            "oxystome": "本科",
            "dynastes": "Sarjana",
            "ootid": 1,
            "obtected": 0
          }        
        """
        
        if let spotItems = try JSONDecoder().decode(SpotItem.self, from: jsonData)
            
        self.data = spotItems
    }
    
    var body: some View {
        AuthenticateOptionItem(item: data)
    }
}

#Preview {
    ZStack {
        Color.yellow.ignoresSafeArea()
        MockView()
    }
}
