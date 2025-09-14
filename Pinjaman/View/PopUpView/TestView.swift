//
//  TestView.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/13.
//

import SwiftUI
import SwiftUI

import SwiftUI

// 从外部文件导入 AddressItem 模型
// import AddressModel // 假设 AddressItem 在单独的文件中

// MARK: - 地址选择器视图
// MARK: - 地址选择器视图
struct AddressPickerView: View {

    // 假设这是从 JSON 解析得到的整个地址数据列表
    @State private var allProvinces: [AddressItem] = []

    // 状态变量，用于存储每个层级的选中项
    @State private var selectedProvince: AddressItem?
    @State private var selectedCity: AddressItem?
    @State private var selectedDistrict: AddressItem?

    // 状态变量，用于显示当前选中的完整地址
    @State private var fullAddress: String = "请选择地址..."

    var height: CGFloat = 150
    var body: some View {
        ZStack(alignment: .trailing) {
            Color.black.opacity(0.3)
            VStack {
                Spacer()
                VStack(spacing: 0) {
                    HStack(alignment: .center) {
                        Image("").frame(width: 32, height: 32)
                        Spacer()
                        // 显示完整的选中地址
                        Text(fullAddress)
                            .font(.subheadline)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        
                        Spacer()
                        Button {
                            
                        } label: {
                            Image("popup_close").frame(width: 32, height: 32)
                        }
                        .padding(.trailing, 8)
                    }
                    .padding(.top, 16)

                    addressArea.padding(.top, -30)
                    
                    PrimaryButton(title: "Confirm") {
                        
                    }
                    .padding(.horizontal, 24)
                }
                .background(Color.white)
                .cornerRadius(12)
                .onAppear {
                    // 在视图出现时加载数据
                    loadAddressData()
                }
            }.onTapGesture {
                
            }
        }
    }
    
    var addressArea: some View {
        // MARK: - 地址选择器
        HStack {
            // MARK: - 省份选择器
            if !allProvinces.isEmpty {
                Picker("省份", selection: $selectedProvince) {
                    //                            Text("请选择省份").tag(nil as AddressItem?)
                    ForEach(allProvinces, id: \.id) { province in
                        Text(province.contendent ?? "").tag(province as AddressItem?)
                    }
                }
                .pickerStyle(.wheel)
                .onChange(of: selectedProvince) { newValue in
                    // 当省份改变时，重置城市和地区选择
                    selectedCity = newValue?.forheed?.first
                    selectedDistrict = newValue?.forheed?.first?.forheed?.first
                    updateFullAddress()
                }
                .frame(height: height)
            }
            
            // MARK: - 城市选择器
            if let cities = selectedProvince?.forheed, !cities.isEmpty {
                Picker("城市", selection: $selectedCity) {
                    //                            Text("请选择城市").tag(nil as AddressItem?)
                    ForEach(cities, id: \.id) { city in
                        Text(city.contendent ?? "").tag(city as AddressItem?)
                    }
                }
                .pickerStyle(.wheel)
                .onChange(of: selectedCity) { newValue in
                    // 当城市改变时，重置地区选择
                    selectedDistrict = newValue?.forheed?.first
                    updateFullAddress()
                }.frame(height: height)
            }
            
            // MARK: - 地区选择器
            if let districts = selectedCity?.forheed, !districts.isEmpty {
                Picker("地区", selection: $selectedDistrict) {
                    //                            Text("请选择地区").tag(nil as AddressItem?)
                    ForEach(districts, id: \.id) { district in
                        Text(district.contendent ?? "").tag(district as AddressItem?)
                    }
                }
                .pickerStyle(.wheel)
                .onChange(of: selectedDistrict) { newValue in
                    updateFullAddress()
                }.frame(height: height)
            }
        }
        .frame(maxWidth: .infinity)
        
    }

    /// 更新完整的地址字符串
    private func updateFullAddress() {
        var addressComponents: [String] = []
        if let provinceName = selectedProvince?.contendent {
            addressComponents.append(provinceName)
        }
        if let cityName = selectedCity?.contendent {
            addressComponents.append(cityName)
        }
        if let districtName = selectedDistrict?.contendent {
            addressComponents.append(districtName)
        }
        fullAddress = addressComponents.joined(separator: " > ")
        
        if fullAddress.isEmpty {
            fullAddress = "请选择地址..."
        }
    }

    /// 模拟加载地址数据
    private func loadAddressData() {
        // 使用您提供的 JSON 数据，这里是硬编码以简化示例
        let jsonString = """
        [
          {
            "serphoid": 1,
            "goss": "0001",
            "contendent": "Sumatera",
            "untripped": null,
            "repartitionable": null,
            "forheed": [
              {
                "serphoid": 1,
                "goss": "00010001",
                "contendent": "Aceh",
                "umbelliferae": "0001",
                "repartitionable": null,
                "forheed": [
                  {
                    "serphoid": 1,
                    "goss": "000100010001",
                    "contendent": "Kabupaten Aceh Barat",
                    "parachor": "00010001",
                    "forheed": []
                  },
                  {
                    "serphoid": 2,
                    "goss": "000100010002",
                    "contendent": "Kabupaten Aceh Barat Daya",
                    "parachor": "00010001",
                    "forheed": []
                  }
                ]
              }
            ]
          },
          {
            "serphoid": 2,
            "goss": "0002",
            "contendent": "Jawa",
            "untripped": null,
            "repartitionable": null,
            "forheed": [
              {
                "serphoid": 1,
                "goss": "00020001",
                "contendent": "Banten",
                "umbelliferae": "0002",
                "repartitionable": null,
                "forheed": [
                  {
                    "serphoid": 1,
                    "goss": "000200010001",
                    "contendent": "Kabupaten Lebak",
                    "parachor": "00020001",
                    "forheed": []
                  }
                ]
              }
            ]
          }
        ]
        """
        
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                // 使用您提供的 AddressItem 模型进行解码
                let addresses = try JSONDecoder().decode([AddressItem].self, from: jsonData)
                self.allProvinces = addresses
                
                // 默认选中第一层级的第一个地址
                self.selectedProvince = self.allProvinces.first
                // 默认选中第二层级的第一个地址
                self.selectedCity = self.selectedProvince?.forheed?.first
                // 默认选中第三层级的第一个地址
                self.selectedDistrict = self.selectedCity?.forheed?.first
                
                // 更新显示地址
                self.updateFullAddress()
            } catch {
                print("解码地址数据失败: \(error)")
            }
        }
    }
}

struct TTView: View {
    @State var openCitySelector: Bool = false

    var body: some View {
        ZStack {
            Color.yellow
            Button {
                openCitySelector = true
            } label: {
                Text("Hello, World!")
            }

        }
        .overlay(content: {
            ZStack(alignment: .bottom) {
                Color.clear.ignoresSafeArea()
                AddressPickerView()
//                    .frame(height: 300) // 这里设置了 popover 的高度
            }
        })
        
    }
}

#Preview {
    TTView()
}
