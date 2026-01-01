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
    @State var isNetworkDisable: Bool = true
    @Binding var canEnterHomePage: Bool
    @State var domains:[String] = []
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("launch")
                .resizable()
                .ignoresSafeArea()
            
            if showTryAgainButton {
                PrimaryButton(title: "Try again") {
                    process()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            IDFAManager.shared.requestIDFA { idfa, status in
                TrackHelper.share.onUploadGoogleMarket()
                TrackHelper.share.onUploadDeviceInfo()
            }
            process()
        })
    }
    
    func process() {
        if !isNetworkDisable {
            onProcessChecking()
            return
        }
        
        checkInternetAvailability { [self] isConnected in
            if isConnected {
                isNetworkDisable = false
                showTryAgainButton = false
                onProcessChecking()
            } else {
                isNetworkDisable = true
                showTryAgainButton = true
            }
        }
    }
    
    func onProcessChecking() {
        onUploadPosition()
        if UIDevice.isIpad() {
            canEnterHomePage = true
            return
        }
        // ipad will skip checking.
        checkConfig()
    }
    
    func onUploadPosition() {
        Task {
            // 3. 获取地址请求
            appSeting.adressManager.requestWhenInUseAuthorization()
            appSeting.adressManager.onLocationUpdate = { _ in
                TrackHelper.share.onUploadPosition()
            }
        }
    }
     
    func checkConfig() {
        // 2. 检查IDFA
        Task {
            do {
                // 4. 网络可用，调用配置接口
                let response = try await onFetchConfig()
                guard let configResponse = response as? PJResponse<ConfigModel> else {
                    await MainActor.run {
//                        showTryAgainButton = true
                        fetchNewHosts() // check new host
                    }
                    return
                }
                
                await MainActor.run {
                    appSeting.configModal = configResponse.unskepticalness
                    // 3. 配置Facebook SDK
                    configureFacebookSDK(with: configResponse.unskepticalness.overplace)
                    canEnterHomePage = true
                }
            } catch {
                fetchNewHosts()
            }
        }
    }
    
    func fetchNewHosts() {
        if let host = self.domains.first {
            API_HOST = host
            domains.removeFirst()
            self.checkConfig()
            return
        }
        
        Task {
            if let s = try? await fetchHostFromRemote(), s.count > 0 {
                await MainActor.run {
                    self.domains = s
                    fetchNewHosts()
                }
            } else {
                // show network error
                await MainActor.run {
                    self.onHandleResponseError()
                }
            }
        }
    }
    
    func onHandleResponseError() {
        showTryAgainButton = true
        self.oncheckNetWorkPermission() // 检查一下网络权限
    }
    
    func oncheckNetWorkPermission() {
        NetworkPermissionManager().startMonitoring { isConnected in
            if !isConnected {
                NotificationCenter.postAlert(alertType: .network)
            }
        }
    }
      
    func fetchHostFromRemote() async -> [String] {
        guard let url = URL(string: "https://id3-dc.oss-ap-southeast-5.aliyuncs.com/pinjaman-hebat/6945122ad8ad0.json"),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: String]] else {
            return []
        }
        
        return jsonArray.compactMap { $0["ph"] }
    }
    
    func onFetchConfig() async throws -> PJResponse<ConfigModel> {
        showLoading = true
        let language = Locale.current.languageCode == "id" ? "id" : "en"
        let payload = LoginInitializationPayload(bilirubinic: language, chartographical: 0, puboiliac: 0)
        let response: PJResponse<ConfigModel> = try await NetworkManager.shared.request(payload)
        showLoading = false
        return response
    }
    
    // 这个函数更准确，因为它真的尝试访问互联网
    func checkInternetAvailability() async -> Bool {
        // 尝试向一个高可用性的服务器发送一个轻量请求
        guard let url = URL(string: "https://www.apple.com") else { return false }
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD" // HEAD 请求只获取头部，速度快，省流量
        request.timeoutInterval = 5 // 5秒超时

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            return (response as? HTTPURLResponse)?.statusCode == 200
        } catch {
            print("Internet availability check failed: \(error.localizedDescription)")
            return false
        }
    }
    
    func checkInternetAvailability(completion: @escaping (Bool) -> Void) {
        // 步骤 1: 创建 URL 和 URLRequest
        guard let url = URL(string: "https://www.apple.com") else {
            // 如果 URL 无效，立即通过回调返回 false
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD" // 使用 HEAD 请求，只获取头部，速度快
        request.timeoutInterval = 5.0 // 设置 5 秒超时

        // 步骤 2: 使用 URLSession.shared.dataTask 创建网络任务
        // 这是基于回调的经典网络请求 API
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            // 这个闭包会在后台线程上执行
            
            // 步骤 3: 检查错误
            // 如果 error 不为 nil，或 response 不是一个有效的 HTTP 响应，则认为网络不可用
            guard error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("网络检查失败。错误: \(error?.localizedDescription ?? "无效的响应")")
                completion(false)
                return
            }
            
            // 步骤 4: 如果一切正常，认为网络可用
            print("网络检查成功。")
            completion(true)
        }
        
        // 步骤 5: 启动任务！这是非常关键的一步，千万不能忘记。
        task.resume()
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
