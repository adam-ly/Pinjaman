//
//  HomeView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appSeting: AppSettings
    @State var homeModel: HomeModel?
    
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
        .ignoresSafeArea(edges: .top)
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
                Text(self.homeModel?.getProdLimitContent() ?? "").font(.system(size: 18, weight: .regular))

                Text(self.homeModel?.getProdLimitAmount() ?? "")
                    .font(.system(size: 52, weight: .semibold))

                HStack {
                    Spacer()
                    VStack {
                        Text(self.homeModel?.getProdExpiredContent() ?? "")
                            .font(.system(size: 14, weight: .regular))
                        Text(self.homeModel?.getProdExpiredText() ?? "")
                            .font(.system(size: 24, weight: .semibold))
                    }
                    Spacer()
                    Divider()
                        .frame(width: 1)
                        .background(linkTextColor)
                    
                    Spacer()
                    VStack {
                        Text(self.homeModel?.getProdinterestContent() ?? "")
                            .font(.system(size: 14, weight: .regular))
                        Text(self.homeModel?.getProdinterestRate() ?? "")
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
                    Text(self.homeModel?.getApplayButtonText() ?? "")
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
                let payLoad = AppHomePagePayload()
                let homeResponse: PJResponse<HomeModel> = try await NetworkManager.shared.request(payLoad)
                print("homeModel.unskepticalness.hoised = \(homeResponse.unskepticalness.poikilitic?.sordidnesses)")
                self.homeModel = homeResponse.unskepticalness
            } catch {
                
            }
        }
    }
    
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
    
    func getRequestPermit(with prdId: Int) {
        
    }
}

#Preview {
    HomeView()
}
