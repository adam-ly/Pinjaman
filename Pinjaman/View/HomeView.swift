//
//  HomeView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/24.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    
    @EnvironmentObject var appSeting: AppSettings
    @EnvironmentObject var navigationState: NavigationState
    
    @State var homeModel: HomeModel?
    @State var showLoading: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0, content: {
                topImg
                amountArea
                playnowButton
                if homeModel != nil {
                    if (homeModel?.getProdList()?.count ?? 0)  == 0 {
                        productIntroView
                    } else {
                        productList
                    }
                }
            })
            .background(productBgColor)
        }
        .onReceive(NotificationCenter.default.publisher(for: .didLogin)) { n in
            self.onFetchData()
        }
        .onReceive(NotificationCenter.default.publisher(for: .onLanding)) { n in
            if let tag = n.userInfo?["tag"] as? Int, tag == 0 {
                self.onFetchData()
            }
        }
        .refreshable(action: {
            Task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.onFetchData()
                })
            }
        })
        .ignoresSafeArea(edges: .top)
        .loading(isLoading: $showLoading)
        .onAppear {
            self.onFetchData()
        }
    }
    
    var topImg: some View {
        Image("home_topImg")
            .resizable()
            .frame(maxWidth: .infinity)
    }
    
    var amountArea: some View {
        VStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(self.homeModel?.getProdLimitContent() ?? " ")
                    .font(.system(size: 18, weight: .regular))

                Text(self.homeModel?.getProdLimitAmount() ?? " ")
                    .font(.system(size: 52, weight: .semibold))

                HStack {
                    Spacer()
                    VStack {
                        Text(self.homeModel?.getProdExpiredContent() ?? " ")
                            .font(.system(size: 14, weight: .regular))
                        Text(self.homeModel?.getProdExpiredText() ?? " ")
                            .font(.system(size: 24, weight: .semibold))
                    }
                    Spacer()
                    Divider()
                        .frame(width: 1)
                        .background(linkTextColor)
                    
                    Spacer()
                    VStack {
                        Text(self.homeModel?.getProdinterestContent() ?? " ")
                            .font(.system(size: 14, weight: .regular))
                        Text(self.homeModel?.getProdinterestRate() ?? " ")
                            .font(.system(size: 24, weight: .semibold))
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .padding(16)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .background(primaryColor)
        .onTapGesture {
            onClickPlayNow()
        }
    }
    
    var playnowButton: some View {
        Button {
            onClickPlayNow()
        } label: {
            ZStack(alignment: .center) {
                LinearGradient(colors: [Color.pink,
                                        Color.pink,
                                        Color.white],
                               startPoint: .bottom,
                               endPoint: .top)
                HStack {
                    Text(self.homeModel?.getApplayButtonText() ?? " ")
                    Image("home_playnowIcon")
                }
                .foregroundColor(.white)
                .font(.system(size: 22, weight: .semibold))
            }
            .frame(height: 57)
        }
    }
    
    var productIntroView: some View {
        VStack {
            Image("home_product_first")
                .resizable()
                .frame(maxWidth: .infinity)
            Image("home_product_second")
                .resizable()
                .frame(maxWidth: .infinity)
            Image("home_product_third")
                .resizable()
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
    
    var productList: some View {
        ForEach(homeModel?.getProdList() ?? []) { item in
            HomeProductListItem(item: item)
        }
    }
}

struct HomeProductListItem: View {
    @State var item: Aladfar
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 12) {
                topArea
                bottomArea
            }
            .padding(14)
            Divider()
        }
        .background(Color.clear)
    }
    
    var topArea: some View {
        HStack {
            if let url = URL(string: item.underspore ?? "") {
                KFImage(url)
                    .resizable()
                    .placeholder({ _ in
                        RoundedRectangle(cornerRadius: 6)
                            .frame(width: 28, height: 28)
                            .background(productBgColor)
                    })
                    .frame(width: 28, height: 28)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(4)
            } else {
                Image("AppLogo")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .cornerRadius(6)
            }
            
            Text(item.multilayer ?? "")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(primaryColor)
            
            Spacer()
            
            Button {
              
            } label: {
                Text(item.bullrushes ?? "")
                    .padding(.horizontal,8)
                    .padding(.vertical,5)
                    .background(primaryColor)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(height: 28)
                    .frame(minWidth: 96)
                    .cornerRadius(8)
            }

        }
    }
    
    var bottomArea: some View {
        HStack {
            VStack {
                Text(item.pithecanthropoid ?? "")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(primaryColor)
                Text(item.plumbog ?? "")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(secondaryTextColor)
            }
            
            Spacer()
            
            VStack {
                Text(item.dirdums ?? "")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(primaryColor)
                Text(item.rhadamanthine ?? "")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(secondaryTextColor)
            }
            
            Spacer()
            
            VStack(spacing: 6) {
                Text(item.infantries ?? "")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(primaryColor)
                Text(item.marocain ?? "")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(secondaryTextColor)
            }
        }
        .frame(width: .infinity)
    }
}

extension HomeView {
    func onFetchData() {
        
        Task {
            self.onUploadInfo()
            do {
                showLoading = true
                let payLoad = AppHomePagePayload()
                let homeResponse: PJResponse<HomeModel> = try await NetworkManager.shared.request(payLoad)
                print("homeModel.unskepticalness.hoised = \(homeResponse.unskepticalness.poikilitic?.sordidnesses)")
                self.homeModel = homeResponse.unskepticalness
                showLoading = false
            } catch {
                showLoading = false
            }
        }
        onfetchAddress()
    }
    
    // 点击按钮
    func onClickPlayNow() {
        if !appSeting.isLogin() {
            NotificationCenter.default.post(name: .showLogin, object: nil)
            return
        }
        guard homeModel != nil,
        let prodId = homeModel?.getprdId()  else {
            return
        }
        getRequestPermit(with: prodId)
    }
    
    // 准入接口
    func getRequestPermit(with prdId: Int) {
        showLoading = true
        Task {
            do {
                let payload = ProductAdmissionPayload(christhood: "\(prdId)")
                let response: PJResponse<ProductRequestModel> = try await NetworkManager.shared.request(payload)
                showLoading = false
                guard let code = response.unskepticalness.overprize, code == 200 else {
                    ToastManager.shared.show(response.unskepticalness.peculated ?? "")
                    return
                }
                
                if let path = response.unskepticalness.nectarium?.getDestination().0 as? String,
                    !path.isEmpty {
//                    destination = path
                    navigationState.destination = path
                    navigationState.param = "\(homeModel?.getprdId() ?? 0)"
                    navigationState.shouldGoToRoot = true
                }
            } catch {
                showLoading = false
            }
        }
    }
    
    func onfetchAddress() {
        guard appSeting.address.count <= 0 else {
            return
        }
        Task {
            do {
                let payload = CityListPayload()
                let response:PJResponse<[AddressItem]> = try await NetworkManager.shared.request(payload)
                appSeting.address = response.unskepticalness
                print(appSeting.address.count)
                print(AppSettings.shared.address.count)
            } catch {
                
            }
        }
    }
    
    func onUploadInfo() {
        appSeting.adressManager.onLocationUpdate = { _ in
            appSeting.adressManager.stopUpdatingLocation()
            TrackHelper.share.onUploadPosition()
        }
        
        TrackHelper.share.onUploadGoogleMarket()
        TrackHelper.share.onUploadDeviceInfo()
        TrackHelper.share.onUploadGoogleMarket()

    }
}

#Preview {
    HomeView()
}
