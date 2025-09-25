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
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(item.daceloninae ?? "")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(commonTextColor)
            menu
        }
        .onAppear(perform: {
            if let selectedItem = item.vermeer?.first(where: { $0.oxystome == item.oxystome }) {
                self.selectedOption = selectedItem
            }
        })
        .padding(.horizontal, 16)
        .onTapGesture {
            self.isShowingDropdown = false
        }
    }
    
    var menu: some View {
        Menu {
            ForEach(item.vermeer ?? [], id: \.self) { item in
                Button(item.contendent ?? "") {
                    self.selectedOption = item
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
        .onChange(of: self.selectedOption) { newValue in
            self.item.oxystome = self.selectedOption?.oxystome ?? ""
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
                "contendent": "高中",
                "oxystome": "SMA"
              },
              {
                "contendent": "本科",
                "oxystome": "Sarjana"
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

        let spotItems = try! JSONDecoder().decode(SpotItem.self, from: jsonDataString.data(using: .utf8)!)

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
