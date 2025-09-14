//
//  LaunchView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/24.
//

import SwiftUI
import Network
import FBSDKCoreKit

struct LaunchView: View {
    @EnvironmentObject var appSeting: AppSettings
    @MainActor @State private var showLoading: Bool = false
    @State var showTryAgainButton: Bool = false
    @State var isNetworkDisable: Bool = false
    @Binding var canEnterHomePage: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("launch")
                .resizable()
                .ignoresSafeArea()
            
            if showTryAgainButton {
                PrimaryButton(title: "Try again") {
                    precheck()
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
        }
        .loading(isLoading: $showLoading)
        .onAppear {
            precheck()
        }
    }
    
    func precheck() {
        Task {
            do {
                // 1. 先检查网络是否可用
                let connectStatus = await NetworkPermissionManager.shared.checkConnectionStatus()
                if !connectStatus.isConnected {
                    await MainActor.run {
                        isNetworkDisable = true
                        showTryAgainButton = true
                        NotificationCenter.postAlert(alertType: .network)
                    }
                    return
                }
                
                // 2. 检查IDFA
                let (idfa, status) = await IDFAManager.shared.requestIDFA()
                // google_market上报
                TrackHelper.share.onUploadGoogleMarket()
                TrackHelper.share.onUploadDeviceInfo()
                
                // 3. 获取地址请求
                appSeting.adressManager.requestWhenInUseAuthorization()
                appSeting.adressManager.onLocationUpdate = { _ in
                    TrackHelper.share.onUploadPosition()
                }
                
                
                // 4. 网络可用，调用配置接口
                let response = await onFetchConfig()
                guard let configResponse = response else {
                    await MainActor.run {
                        showTryAgainButton = true
                    }
                    return
                }
                
                await MainActor.run {
                    appSeting.configModal = configResponse.unskepticalness
                }
                
                
                // 3. 配置Facebook SDK
                await configureFacebookSDK(with: configResponse.unskepticalness.overplace)
                
                // 4. 保存配置并允许进入主页
                await MainActor.run {
                    canEnterHomePage = true
                }
                
            } catch {
                await MainActor.run {
                    showTryAgainButton = true
                }
            }
        }
    }
    
    func checkNetwork() async -> Bool {
        let isConnected = await isNetworkConnected()
        return isConnected
    }
    
    func onFetchConfig() async -> PJResponse<ConfigModel>? {
        showLoading = true
        let payload = LoginInitializationPayload(bilirubinic: "en", chartographical: 0, puboiliac: 0)
        let response: PJResponse<ConfigModel>? = try? await NetworkManager.shared.request(payload)
        response?.unskepticalness.filesniff = 2
        print("response.unskepticalness.overplace?.detach = \(response?.unskepticalness.overplace?.detach)")
        showLoading = false
        return response
    }
        
    
    func isNetworkConnected() async -> Bool {
        return await withCheckedContinuation { continuation in
            let monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    continuation.resume(returning: true)
                } else {
                    continuation.resume(returning: false)
                }
                monitor.cancel()
            }
            let queue = DispatchQueue(label: "NetworkMonitor")
            monitor.start(queue: queue)
        }
    }
}


/// Facebook
extension LaunchView {
    func configureFacebookSDK(with overplace: Overplace?) {
        guard let overplace = overplace else {
            print("Facebook configuration not available")
            return
        }
        
        // 配置Facebook SDK
        if let appID = overplace.detach {
            Settings.shared.appID = appID
            print("Facebook App ID configured: \(appID)")
        }
        
        if let displayName = overplace.plastique {
            Settings.shared.displayName = displayName
            print("Facebook Display Name configured: \(displayName)")
        }
        
        if let clientToken = overplace.noncodified {
            Settings.shared.clientToken = clientToken
            print("Facebook Client Token configured: \(clientToken)")
        }
        
        if let urlScheme = overplace.unshakenness {
            Settings.shared.appURLSchemeSuffix = urlScheme
            print("Facebook URL Scheme configured: \(urlScheme)")
        }
        
        // 初始化Facebook SDK
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            didFinishLaunchingWithOptions: nil
        )
        
        print("Facebook SDK configured successfully")
    }
}
