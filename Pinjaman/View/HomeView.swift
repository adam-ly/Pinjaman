//
//  HomeView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appSeting: AppSettings
    @State private var shouldNavigate = false
    @State var homeModel: HomeModel?
    @State var destination: String = ""
    @State var showLoading: Bool = false
    
    var body: some View {
        NavigationView {
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
                    NavigationLink(destination: NavigationManager.navigateTo(for: destination, prodId: "\(homeModel?.getprdId() ?? 0)"), isActive: $shouldNavigate) {
                        EmptyView() // 隐藏的 NavigationLink 标签
                    }
                })
                .background(productBgColor)
            }
            .hideTabBarOnPush()
            .onReceive(NotificationCenter.default.publisher(for: .didLogin)) { n in
                self.onFetchData()
            }
            .ignoresSafeArea(edges: .top)
            .loading(isLoading: $showLoading)
            .onAppear {
                self.onFetchData()
                self.onTrackLocation()
            }
        }.tint(.white)
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
        ForEach(0..<(homeModel?.getProdList()?.count ?? 0), id: \.self) { _ in
            HomeProductListItem()
        }
    }
}

struct HomeProductListItem: View {
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
            Image("AppLogo")
            Text("Pinjaman Hebat")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(primaryColor)
            
            Spacer()
            
            Button {

            } label: {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(primaryColor)
                    Text("Apply")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
                }
                .frame(width: 96, height: 28)
            }

        }
    }
    
    var bottomArea: some View {
        HStack {
            VStack {
                Text("Loan term")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(primaryColor)
                Text("120 day")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(secondaryTextColor)
            }
            
            Spacer()
            
            VStack {
                Text("Interest rate")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(primaryColor)
                Text("0.03%/day")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(secondaryTextColor)
            }
            
            Spacer()
            
            VStack(spacing: 6) {
                Text("Interest rate")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(primaryColor)
                Text("0.03%/day")
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
                    destination = path
                    shouldNavigate = true
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
    
    func onTrackLocation() {
        appSeting.adressManager.onLocationUpdate = { _ in
            TrackHelper.share.onUploadPosition()
            appSeting.adressManager.stopUpdatingLocation()
        }
        
        TrackHelper.share.onUploadGoogleMarket()
        TrackHelper.share.onUploadDeviceInfo()
    }
}

#Preview {
    HomeView()
}
