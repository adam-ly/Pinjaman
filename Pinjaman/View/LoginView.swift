//
//  LoginView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/24.
//

import SwiftUI

struct LoginView: View {
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var agree = true
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack(alignment: .bottom) {
            // 半透明背景
            Color.yellow.opacity(1)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    // 点击背景关闭登录视图
                    presentationMode.wrappedValue.dismiss()
                }
            
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .topLeading) {
                    Image("login_background")
                        .aspectRatio(contentMode: .fit)
                        .edgesIgnoringSafeArea(.bottom)
                    Text("Login")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.leading, 50)
                        .padding(.top, 10)
                }
                
                Button {
                    
                } label: {
                    Image("login_close")
                }
                .padding(.trailing, 10)
                .padding(.top, -10)
            }
            
            // 内容区域
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                titleArea
                contentArea
                    .padding(.horizontal, 20)
                
                PrimaryButton(title: "Log in") {
                    
                }
                .padding(.horizontal, 60)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 40)
        }
        .ignoresSafeArea()
        
    }
    
    var titleArea: some View {
        VStack(alignment: .trailing, spacing: 10) {
            Text("Hello")
                .font(.system(size: 24, weight: .bold))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
            
            Text("Welcome to Pinjaman Hebat")
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal, 20)
    }
    
    var contentArea: some View {
        VStack(spacing: 20) {
            // 输入框区域
            VStack(spacing: 15) {
                // 手机号输入框
                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone number")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                    HStack {
                        Image("login_yn")
                        Text("+01")
                        Divider().frame(height: 50)
                        TextField("Enter phone number", text: $phoneNumber)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .foregroundColor(.black)
                            .accentColor(.black)
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 10)
                    .background(textFieldBgColor)
                    .cornerRadius(6)
                }
                
                // 密码输入框
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                    HStack {
                        SecureField("Enter password", text: $password)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .accentColor(.black)
                        
                        Button {
                            
                        } label: {
                            Text("Get code")
                                .foregroundColor(linkTextColor)
                        }

                    }
                    .frame(height: 50)
                    .padding(.horizontal, 10)
                    .background(textFieldBgColor)
                    .cornerRadius(6)
                }
                .padding(.top, 10)
                
                voiceButton.padding(.top, 20)
                
                agreement.padding(.top, 20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    var voiceButton: some View {
        Button {
            
        } label: {
            HStack(spacing: 2) {
                Image("voice")
                Text("Voice verification?")
                    .foregroundColor(linkTextColor)
                    .underline()
            }
        }
    }
    
    var agreement: some View {
        HStack {
            Button {
                agree.toggle()
            } label: {
                Image(agree ? "option_select" : "option_unselect")
            }

            Text("I consent to the")
                .foregroundColor(secondaryTextColor)
            Text("<Privacy policy>")
                .underline()
                .onTapGesture {
                    print("privacy click")
                }
        }
    }

    // 登录功能
    private func performLogin() {
        // 这里添加登录逻辑
        print("Phone: \("phoneNumber"), Password: \("password")")
        // 实际项目中这里会调用API进行登录验证
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        // 示例：展示如何在主视图中使用登录视图（Present模式）
        MainPreviewView()
    }
}

// 预览用的主视图
struct MainPreviewView: View {
    @State private var showLoginView = false
    
    var body: some View {
        LoginView()
//        ZStack {
//            Color.blue.ignoresSafeArea()
//            
//            VStack {
//                Text("Main App Content")
//                    .font(.largeTitle)
//                    .foregroundColor(.white)
//                
//                Button("Show Login") {
//                    showLoginView = true
//                }
//                .padding()
//                .background(Color.white)
//                .foregroundColor(.blue)
//                .cornerRadius(10)
//            }
//        }
//        .sheet(isPresented: $showLoginView) {
//            LoginView()
//        }
    }
}
