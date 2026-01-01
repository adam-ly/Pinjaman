//
//  CiryPickerView.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/14.
//

import SwiftUI

struct CityPickerView: View {
    @EnvironmentObject var appSeting: AppSettings
    @Binding var present: Bool
    @State private var allProvinces: [AddressItem] = []
    
    @State private var selectedProvince: AddressItem?
    @State private var selectedCity: AddressItem?
    @State private var selectedDistrict: AddressItem?
    @State private var fullAddress: String = ""
    var onCallBack: (String) -> Void
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

                        Text(fullAddress)
                            .font(.subheadline)
                        
                        Spacer()
                        Button {
                            present = false
                        } label: {
                            Image("popup_close").frame(width: 32, height: 32)
                        }
                        .padding(.trailing, 8)
                    }
                    .padding(.top, 16)
                    
                    addressArea.padding(.vertical, 10)
                    
                    PrimaryButton(title: LocalizeContent.confirm.text()) {
                        onCallBack(fullAddress)
                        present = false
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 34)
                }
                .background(Color.white)
                .cornerRadius(12)
            }.onTapGesture {
                
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            loadAddress()
        }
    }
    
//    var addressArea: some View {
//        // MARK: - 地址选择器
//        HStack {
//            // MARK: - 省份选择器
//            if !allProvinces.isEmpty {
//                Picker("Province", selection: $selectedProvince) {
//                    //                            Text("请选择省份").tag(nil as AddressItem?)
//                    ForEach(allProvinces, id: \.id) { province in
//                        Text(province.contendent ?? "").tag(province as AddressItem?)
//                    }
//                }
//                .pickerStyle(.wheel)
//                .onChange(of: selectedProvince) { newValue in
//                    // 当省份改变时，重置城市和地区选择
//                    selectedCity = newValue?.forheed?.first
//                    selectedDistrict = newValue?.forheed?.first?.forheed?.first
//                    updateFullAddress()
//                }
//                .frame(height: height)
//            }
//            
//            // MARK: - 城市选择器
//            if let cities = selectedProvince?.forheed, !cities.isEmpty {
//                Picker("City", selection: $selectedCity) {
//                    ForEach(cities, id: \.id) { city in
//                        Text(city.contendent ?? "").tag(city as AddressItem?)
//                    }
//                }
//                .pickerStyle(.wheel)
//                .onChange(of: selectedCity) { newValue in
//                    // 当城市改变时，重置地区选择
//                    selectedDistrict = newValue?.forheed?.first
//                    updateFullAddress()
//                }.frame(height: height)
//            }
//            
//            // MARK: - 地区选择器
//            if let districts = selectedCity?.forheed, !districts.isEmpty {
//                Picker("Region", selection: $selectedDistrict) {
//                    ForEach(districts, id: \.id) { district in
//                        Text(district.contendent ?? "").tag(district as AddressItem?)
//                    }
//                }
//                .pickerStyle(.wheel)
//                .onChange(of: selectedDistrict) { newValue in
//                    updateFullAddress()
//                }.frame(height: height)
//            }
//        }
//        .frame(maxWidth: .infinity)
//    }
    
    var addressArea: some View {
        HStack(spacing: 12) { // 增加间距
            // MARK: - 1. 省份 Menu
            if !allProvinces.isEmpty {
                Menu {
                    ForEach(allProvinces, id: \.id) { province in
                        Button(action: {
                            // 1. 更新省份
                            selectedProvince = province
                            
                            // 2. 级联重置逻辑 (省变了 -> 重置市、区)
                            selectedCity = province.forheed?.first
                            selectedDistrict = province.forheed?.first?.forheed?.first
                            
                            // 3. 更新完整地址字符串
                            updateFullAddress()
                        }) {
                            HStack {
                                Text(province.contendent ?? "")
                                // 选中状态打勾 (UX优化)
                                if selectedProvince?.id == province.id {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    // 自定义显示样式
                    menuLabel(text: selectedProvince?.contendent ?? "选择省份", isActive: true)
                }
            }
            
            // MARK: - 2. 城市 Menu
            // 只有当省份有下级城市时才显示
            if let cities = selectedProvince?.forheed, !cities.isEmpty {
                Menu {
                    ForEach(cities, id: \.id) { city in
                        Button(action: {
                            selectedCity = city
                            
                            // 级联重置逻辑 (市变了 -> 重置区)
                            selectedDistrict = city.forheed?.first
                            
                            updateFullAddress()
                        }) {
                            HStack {
                                Text(city.contendent ?? "")
                                if selectedCity?.id == city.id {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    menuLabel(text: selectedCity?.contendent ?? "选择城市", isActive: true)
                }
            }
            
            // MARK: - 3. 地区 Menu
            if let districts = selectedCity?.forheed, !districts.isEmpty {
                Menu {
                    ForEach(districts, id: \.id) { district in
                        Button(action: {
                            selectedDistrict = district
                            updateFullAddress()
                        }) {
                            HStack {
                                Text(district.contendent ?? "")
                                if selectedDistrict?.id == district.id {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    menuLabel(text: selectedDistrict?.contendent ?? "选择地区", isActive: true)
                }
            }
            
            // 占位符：如果后面没有显示的 Menu，用 Spacer 顶到左边（可选）
            Spacer()
        }
        .padding(.vertical, 8)
    }

    // MARK: - 辅助视图：统一的 Menu 外观
    // 提取出来作为一个 ViewBuilder，方便统一修改样式
    @ViewBuilder
    func menuLabel(text: String, isActive: Bool) -> some View {
        HStack {
            Text(text)
                .lineLimit(1) // 限制一行
                .truncationMode(.tail) // 超长省略
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.down")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.secondary.opacity(0.1)) // 浅灰背景
        .cornerRadius(8)
        // 强制给一个最小宽度，或者使用 flexible
        // .frame(minWidth: 80)
    }
    
    private func loadAddress() {
        self.allProvinces = AppSettings.shared.address
        print(self.allProvinces.count)
        // 默认选中第一层级的第一个地址
        self.selectedProvince = self.allProvinces.first
        // 默认选中第二层级的第一个地址
        self.selectedCity = self.selectedProvince?.forheed?.first
        // 默认选中第三层级的第一个地址
        self.selectedDistrict = self.selectedCity?.forheed?.first
        
        updateFullAddress()
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
        fullAddress = addressComponents.joined(separator: "|")
    }
}
