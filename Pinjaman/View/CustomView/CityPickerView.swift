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
                    
                    addressArea.padding(.top, -10)
                    
                    PrimaryButton(title: "Confirm") {
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
