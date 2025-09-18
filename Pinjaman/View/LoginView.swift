//
//  LoginView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var navigationState: NavigationState
    @EnvironmentObject var appSeting: AppSettings
    @MainActor @State private var showLoading: Bool = false
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var agree = true
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @Binding var isPresented: Bool
    @FocusState private var isPhoneNumberFocused: Bool
    @FocusState private var isCodeNumberFocused: Bool
    // 追蹤倒計時是否正在進行
    @State private var isCountingDown = false
    // 倒計時的總時間（秒）
    @State private var countdownTime = 60
    // 定義計時器，每秒觸發一次
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var url: URL?
    
    var body: some View {
        ZStack(alignment: .center) {
            // 半透明背景
            Color.black.opacity(isPresented ? 0.4 : 0) // 随着动画改变透明度
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .onTapGesture {
                    closePage()
                }
            contentView
                .offset(y: isPresented ? 0 : UIScreen.main.bounds.size.height)
        }
        .loading(isLoading: $showLoading)
        .onAppear {
            isPhoneNumberFocused = true
        }
    }
    
    var contentView: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .topLeading) {
                    Image("login_background")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .edgesIgnoringSafeArea(.bottom)
                        .background(Color.clear)
                        .frame(maxWidth: .infinity)
                    Text(LocalizeContent.loginTitle.text())
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.leading, 50)
                        .padding(.top, 10)
                }
                
                Button {
                    closePage()
                } label: {
                    Image("login_close")
                }
                .padding(.trailing, 10)
                .padding(.top, -10)
            }
            .onTapGesture {
                isPhoneNumberFocused = false
                isCodeNumberFocused = false
            }
            
            // 内容区域
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                titleArea
                contentArea
                    .padding(.horizontal, 20)
                
                PrimaryButton(title: LocalizeContent.loginButton.text()) {
                    onPrecheckLogin()
                }
                .padding(.horizontal, 60)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 40)
            .ignoresSafeArea(.keyboard, edges: .bottom) // 讓視圖忽略鍵盤安全區
        }
        .ignoresSafeArea()
    }
    
    var titleArea: some View {
        VStack(alignment: .trailing, spacing: 10) {
            Text(LocalizeContent.loginSubTitle.text())
                .font(.system(size: 24, weight: .bold))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
            
            Text(LocalizeContent.loginDesc.text())
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
                    Text(LocalizeContent.phonenumber.text())
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                    HStack {
                        Text(LocalizeContent.originCode.text())
                        Divider().frame(height: 50)
                        TextField(LocalizeContent.originCode.text(), text: $phoneNumber)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .foregroundColor(.black)
                            .accentColor(.black)
                            .keyboardType(.numberPad)
                            .focused($isPhoneNumberFocused)
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 10)
                    .background(textFieldBgColor)
                    .cornerRadius(6)
                }
                
                // 密码输入框
                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizeContent.verifyCode.text())
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                    HStack {
                        TextField(LocalizeContent.verifyCode.text(), text: $password)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .accentColor(.black)
                            .keyboardType(.numberPad)
                            .focused($isCodeNumberFocused)
                                               
                        countDownButton
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
    
    var countDownButton: some View {
        Button {
            // 點擊後檢查是否正在倒計時
            if !isCountingDown && phoneNumber.count > 0 {
                // 如果沒有，開始倒計時
                startCountdown()
                onGetCode()
            } else {
                ToastManager.shared.show(LocalizeContent.phoneNumberEmpty.text())
            }
        } label: {
            Text(buttonText)
                .foregroundColor(linkTextColor)
        }
        .onReceive(timer) { _ in
            // 當計時器觸發時
            if isCountingDown {
                if countdownTime > 0 {
                    // 如果時間大於0，減少時間
                    countdownTime -= 1
                } else {
                    // 如果時間歸零，停止倒計時
                    stopCountdown()
                }
            }
        }
    }
    
    var voiceButton: some View {
        Button {
            if phoneNumber.count > 0 {
                onGetVoiceCode()
            } else {
                ToastManager.shared.show(LocalizeContent.phoneNumberEmpty.text())
            }
        } label: {
            HStack(spacing: 2) {
                Image("voice")
                Text(LocalizeContent.voiceVerification.text())
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
            
            HStack (spacing: 0) {
                Text(LocalizeContent.loginPrivacy.text())
                    .foregroundColor(secondaryTextColor)
                Text(LocalizeContent.loginPrivacyContent.text())
                    .underline()
                    .foregroundColor(linkTextColor)
                    .onTapGesture {
                        onOpenPrivacyLink()
                    }
            }
        }
    }
    
    // 根據狀態返回按鈕文本
    var buttonText: String {
        if isCountingDown {
            return "\(countdownTime)s"
        } else {
            return LocalizeContent.getCode.text()
        }
    }
    
    // 開始倒計時
    private func startCountdown() {
        isCountingDown = true
        countdownTime = 60 // 重設倒計時時間
        
    }
    
    // 停止倒計時
    private func stopCountdown() {
        isCountingDown = false
        // 為了避免額外消耗，停止接收計時器事件
        timer.upstream.connect().cancel()
        // 重新連接計時器，以便下次使用
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    // 登录功能
    private func performLogin() {
        // 这里添加登录逻辑
        print("Phone: \("phoneNumber"), Password: \("password")")
        // 实际项目中这里会调用API进行登录验证
    }
    
    private func closePage(callBack: (()->Void)? = nil) {
        isCodeNumberFocused = false
        isPhoneNumberFocused = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            withAnimation { isPresented = false }
            callBack?()
        })
    }
    
    private func onOpenPrivacyLink() {
        guard let link = appSeting.configModal?.undefense,
              let url = URL(string: link) else {
            return
        }
        navigationState.destination = link
        navigationState.param = ""
        navigationState.shouldGoToRoot = true
    }
}

extension LoginView {
    func onPrecheckLogin() {
        if phoneNumber.isEmpty {
            isPhoneNumberFocused = true
            ToastManager.shared.show(LocalizeContent.phoneNumberEmpty.text())
            return
        }
        
        if password.isEmpty {
            isCodeNumberFocused = true
            ToastManager.shared.show(LocalizeContent.phoneCodeEmpty.text())
            return
        }
        
        if !agree {
            ToastManager.shared.show(LocalizeContent.agreement.text())
            showToast = true
            return
        }
        
        onLogin()
    }
    
    func onGetCode() {
        TrackHelper.share.onCatchUserTrack(type: .register)
        showLoading = true
        Task {
            do {
                let payLoad = GetSMSCodePayload.init(sensationally: phoneNumber)
                let getCode: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payLoad)
                showLoading = false
                ToastManager.shared.show(getCode.diarmuid)
            } catch {
                showLoading = false
            }
        }
    }
    
    func onGetVoiceCode() {
        TrackHelper.share.onCatchUserTrack(type: .register)
        showLoading = true
        Task {
            do {
                let payLoad = GetVoiceCodePayload.init(sensationally: phoneNumber)
                let getCode: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payLoad)
                showLoading = false
                ToastManager.shared.show(getCode.diarmuid)
            } catch {
                showLoading = false
            }
        }
    }
    
    func onLogin() {
        Task {
            do {
                showLoading = true
                let payLoad = CodeLoginOrRegisterPayload.init(counterretaliation: phoneNumber, underhangman: password)
                let loginResponse: PJResponse<LoginModel> = try await NetworkManager.shared.request(payLoad)
                appSeting.loginModel = loginResponse.unskepticalness
                showLoading = false
                TrackHelper.share.onUploadRiskEvent(type: .register, orderId: "")
                closePage {
                    NotificationCenter.default.post(name: .didLogin, object: nil)
                }
            } catch {
                showLoading = false
            }
        }
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
        ZStack {
            Color.green.edgesIgnoringSafeArea(.all)
            Button {
                withAnimation(.spring(duration: 0.3)) {
                    showLoginView = true
                }
            } label: {
                Text("Login Button")
            }
        }.overlay {
            LoginView(isPresented: $showLoginView)
        }
    }
}
