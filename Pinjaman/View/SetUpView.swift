//
//  SetUpView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/24.
//

import SwiftUI

struct SetUpView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {          
            // 主内容
            VStack(spacing: 30) {
                // 应用图标和名称
                VStack(spacing: 10) {
                    Image("AppLogo") // 假设项目中有这个图标
                        .resizable()
                        .frame(width: 80, height: 80)
                        .cornerRadius(16)

                    Text("Pinjaman Hebat")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
                .padding(.top, 20)

                // 版本信息
                VStack {
                    HStack {
                        Text("Version")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        Spacer()
                        Text("V1.0.0")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(Color.white)
                .cornerRadius(10)

                // 选项列表
                VStack(spacing: 1) {
                    // 账户取消
                    Button {
                        // 账户取消操作
                    } label: {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.pink)
                                .frame(width: 24, height: 24)

                            Text("Account cancellation")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(Color.white)
                    }

                    // 登出
                    Button {
                        // 登出操作
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left.square")
                                .foregroundColor(.pink)
                                .frame(width: 24, height: 24)

                            Text("Logout")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(Color.white)
                    }
                }
                .cornerRadius(10)

                Spacer()

                // 底部内容
                Text("© 2025 Pinjaman Hebat. All rights reserved.")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
        }
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct SetUpView_Previews: PreviewProvider {
    static var previews: some View {
        SetUpView()
    }
}
