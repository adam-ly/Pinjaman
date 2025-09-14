//
//  PKHTMLView.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/13.
//

import SwiftUI
import WebKit
import StoreKit

// 一个用于桥接 WKWebView 和 SwiftUI 的视图
struct PKHTMLView: UIViewControllerRepresentable {
    
    // 输入参数，用于加载和控制视图行为
    let htmlLink: String
    let shouldGoBackToHome: Bool
    
    // UIViewControllerRepresentable 协议方法：创建并配置视图控制器
    func makeUIViewController(context: Context) -> PKHTMLViewController {
        let viewController = PKHTMLViewController(htmlLink: htmlLink, shouldReturnHome: shouldGoBackToHome)
        viewController.delegate = context.coordinator
        return viewController
    }

    // UIViewControllerRepresentable 协议方法：当视图状态更新时调用
    func updateUIViewController(_ uiViewController: PKHTMLViewController, context: Context) {
        // 可以在这里处理视图更新逻辑，例如 URL 改变
    }
    
    // 创建一个 Coordinator，用于处理 WKWebView 的代理和消息
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Coordinator 类：处理 WKWebView 的 WKNavigationDelegate 和 WKScriptMessageHandler 协议
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        
        var parent: PKHTMLView
        
        init(_ parent: PKHTMLView) {
            self.parent = parent
        }
        
        // MARK: - WKNavigationDelegate
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            // 可以在这里处理加载开始时的逻辑
            print("Web view started loading.")
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // 可以在这里处理加载完成时的逻辑
            print("Web view finished loading.")
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Web view failed to load: \(error.localizedDescription)")
        }
        
        // MARK: - WKScriptMessageHandler
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            
            // 使用 main 队列确保 UI 操作在主线程上执行
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                // 根据消息名称分发处理逻辑
                switch message.name {
                case "WikipediaBishop":
                    if let urlString = message.body as? String {
                        self.handleRedirect(routeStr: urlString)
                    }
                case "JungThe":
                    self.handleCloseWebView()
                case "LessentielProgramme":
                    if let args = message.body as? [String], args.count >= 2, let urlString = args[0] as? String, let params = args[1] as? String {
                        self.handleRedirectWithParams(urlString: urlString, params: params)
                    }
                case "FlagPsychiatrist":
                    self.handleSwitchTab(index: 0)
                case "AtHad":
                    self.handleSwitchTab(index: 2)
                case "OlympicAt":
                    self.handleRedirectToLogin()
                case "RedIn":
                    if let phoneNumber = message.body as? String {
                        self.handleCall(phoneNumber: phoneNumber)
                    }
                case "DistinctUsfsa":
                    self.handleAppStoreReview()
                case "ArticleFlame":
                    self.handleTrackApplicationConfirmation()
                case "ReliableSaid":
                    self.handleStartCardBinding()
                case "UntilAlexandria":
                    self.handleEndCardBinding()
                default:
                    print("未处理的 JS 消息: \(message.name)")
                }
            }
        }
        
        // MARK: - JS 消息处理方法
        
        private func handleRedirect(routeStr: String) {
            print("页面跳转: \(routeStr)")
            // 可以在这里实现真实的路由逻辑
        }
        
        private func handleCloseWebView() {
            print("关闭当前 Web 视图")
            // 可以在这里实现返回上一页的逻辑，例如使用 parent.dismiss()
        }
        
        private func handleRedirectWithParams(urlString: String, params: String) {
            print("带参数页面跳转: URL: \(urlString), 参数: \(params)")
            // 可以在这里实现带参数的跳转逻辑
        }
        
        private func handleSwitchTab(index: Int) {
            print("回到主页并关闭当前页，切换到 Tab: \(index)")
            // 可以在这里实现切换 Tab 的逻辑
        }
        
        private func handleRedirectToLogin() {
            print("跳转到登录页并清空页面栈")
            // 可以在这里实现跳转到登录页的逻辑
        }
        
        private func handleCall(phoneNumber: String) {
            let telURL = "tel://\(phoneNumber)"
            if let url = URL(string: telURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
        private func handleAppStoreReview() {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                // 低版本跳转 App Store 页面
                guard let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/idYOUR_APP_ID?action=write-review") else { return }
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
        
        private func handleTrackApplicationConfirmation() {
            print("记录确认申请埋点")
            // 可以在这里调用埋点统计 SDK
        }
        
        private func handleStartCardBinding() {
            print("开始绑卡时间记录")
            // 可以在这里记录事件
        }
        
        private func handleEndCardBinding() {
            print("结束绑卡时间记录")
            // 可以在这里记录事件
        }
    }
}


// -----------------------------------------------------------------------------------------------------------------------------------
// 这个类是原始 UIKit 代码的简化和封装，用于在 SwiftUI 中使用
// -----------------------------------------------------------------------------------------------------------------------------------
class PKHTMLViewController: UIViewController {
    
    weak var webView: WKWebView!
    var progressView: UIProgressView!
    
    // 用于传递 SwiftUI View 的 delegate
    weak var delegate: (WKNavigationDelegate & WKScriptMessageHandler)?
    
    var htmlLink: String
    var shouldGoBackToHome: Bool
    
    init(htmlLink: String, shouldReturnHome: Bool = false) {
        self.htmlLink = htmlLink
        self.shouldGoBackToHome = shouldReturnHome
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupProgressView()
        
        if let url = URL(string: self.htmlLink) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.hidesBottomBarWhenPushed = true
    }
    
    private func setupWebView() {
        let userContentController = WKUserContentController()
        
        // 添加 JS 消息处理名称，这些名称与你的 JavaScript 端相对应
        userContentController.add(delegate!, name: "WikipediaBishop")
        userContentController.add(delegate!, name: "JungThe")
        userContentController.add(delegate!, name: "LessentielProgramme")
        userContentController.add(delegate!, name: "FlagPsychiatrist")
        userContentController.add(delegate!, name: "AtHad")
        userContentController.add(delegate!, name: "OlympicAt")
        userContentController.add(delegate!, name: "RedIn")
        userContentController.add(delegate!, name: "DistinctUsfsa")
        userContentController.add(delegate!, name: "ArticleFlame")
        userContentController.add(delegate!, name: "ReliableSaid")
        userContentController.add(delegate!, name: "UntilAlexandria")
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = userContentController
        
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = delegate
        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        self.webView = webView
    }
    
    private func setupProgressView() {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.tintColor = .systemBlue
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leftAnchor.constraint(equalTo: view.leftAnchor),
            progressView.rightAnchor.constraint(equalTo: view.rightAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        // 监听加载进度
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.progressView = progressView
    }
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress", let webView = object as? WKWebView {
            progressView.progress = Float(webView.estimatedProgress)
            progressView.isHidden = webView.estimatedProgress == 1.0
        }
    }
    
    deinit {
        // 移除观察者，防止内存泄漏
        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    // 1. makeUIView: 创建和配置 WKWebView
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    // 2. updateUIView: 当 SwiftUI 视图状态更新时调用
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
    
    // 可选：添加 Coordinator 来处理 WKWebView 的代理方法
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // 示例: 可以在这里添加导航代理方法，如加载完成等
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Web view finished loading.")
        }
    }
}

struct WebViewExample: View {
    let url = URL(string: "https://www.google.com")!
    
    var body: some View {
        NavigationView {
            VStack {
                // 使用你创建的 WebView 结构体
                WebView(url: url)
            }
            .navigationTitle("Web View")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// 预览
struct WebViewExample_Previews: PreviewProvider {
    static var previews: some View {
        WebViewExample()
    }
}
