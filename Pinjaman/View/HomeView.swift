//
//  HomeView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0, content: {
                topImg
                amountArea
                playnowButton
                productIntroView
                productList
            })
            .background(productBgColor)
        }
        .ignoresSafeArea(edges: .top)
    }
    
    var topImg: some View {
        Image("home_topImg")
            .resizable()
            .frame(width: .infinity)
    }
    
    var amountArea: some View {
        VStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Maximum loan amount")                        .font(.system(size: 18, weight: .regular))

                Text("₹ 8,900,000")
                    .font(.system(size: 52, weight: .semibold))

                HStack {
                    Spacer()
                    VStack {
                        Text("Loan term")
                            .font(.system(size: 14, weight: .regular))
                        Text("120 day")
                            .font(.system(size: 24, weight: .semibold))
                    }
                    Spacer()
                    Divider()
                        .frame(width: 1)
                        .background(linkTextColor)
                    
                    Spacer()
                    VStack {
                        Text("Interest rate")
                            .font(.system(size: 14, weight: .regular))
                        Text("0.03%/day")
                            .font(.system(size: 24, weight: .semibold))
                    }
                    Spacer()
                }
                .frame(width: .infinity)
            }
            .padding(16)
        }
        .foregroundColor(.white)
        .frame(width: .infinity)
        .background(primaryColor)
    }
    
    var playnowButton: some View {
        Button {
            
        } label: {
            ZStack(alignment: .center) {
                LinearGradient(colors: [Color.pink,
                                        Color.pink,
                                        Color.white],
                               startPoint: .bottom,
                               endPoint: .top)
                HStack {
                    Text("Apply Now")
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
                .frame(width: .infinity)
            Image("home_product_second")
                .resizable()
                .frame(width: .infinity)
            Image("home_product_third")
                .resizable()
                .frame(width: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
    
    var productList: some View {
        ForEach(0..<5, id: \.self) { _ in
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

#Preview {
//    ZStack(alignment: .top) {
//        HomeProductListItem()
//    }
    HomeView()
}
