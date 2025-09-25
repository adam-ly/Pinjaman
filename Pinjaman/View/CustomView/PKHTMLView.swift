//
//  PKHTMLView.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/13.
//

import SwiftUI
import WebKit
import StoreKit

struct PKWebView: View {
    let htmlLink: String
    let shouldGoBackToHome: Bool
    @State var title: String = ""
    
    var body: some View {
        PKHTMLView(title: $title,
                   htmlLink: htmlLink,
                   shouldGoBackToHome: shouldGoBackToHome)
            .navigationTitle(title)
            .customBackButton(action: .popToRoot)
    }
}

// 一个用于桥接 WKWebView 和 SwiftUI 的视图
struct PKHTMLView: UIViewControllerRepresentable {
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.presentationMode) var presentationMode
    @Binding var title: String
    // 输入参数，用于加载和控制视图行为
    let htmlLink: String
    let shouldGoBackToHome: Bool
    
    // UIViewControllerRepresentable 协议方法：创建并配置视图控制器
    func makeUIViewController(context: Context) -> PKHTMLViewController {
        let viewController = PKHTMLViewController(htmlLink: htmlLink, shouldReturnHome: shouldGoBackToHome, onGetName: { name in
            self.title = name
        })
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
                case "Jariah": // 关闭当前webview
                    self.handleCloseWebView()
                case "Naemorhedus"://带参数页面跳转
                    if let args = message.body as? [String], args.count >= 2, let urlString = args[0] as? String, let params = args[1] as? String {
                        self.handleRedirectWithParams(urlString: urlString, params: params)
                    }
                case "pollute": // 回到首页，并关闭当前页
                    self.handleSwitchTab(index: 0)
                case "blahlaut": // app store评分功能
                    self.handleAppStoreReview()
                case "Ribhus": // 确认申请埋点调用方法
                    self.handleTrackApplicationConfirmation()
                default:
                    print("未处理的 JS 消息: \(message.name)")
                }
            }
        }
        
        // MARK: - JS 消息处理方法
        private func handleCloseWebView() {
            print("关闭当前 Web 视图")
            // 可以在这里实现返回上一页的逻辑，例如使用 parent.dismiss()
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        private func handleRedirectWithParams(urlString: String, params: String) {
            print("带参数页面跳转: URL: \(urlString), 参数: \(params)")
            // 可以在这里实现带参数的跳转逻辑
            
        }
        
        private func handleSwitchTab(index: Int) {
            print("回到主页并关闭当前页，切换到 Tab: \(index)")
//            parent.navigationState.shouldGoToRoot = false
            parent.router.popToRoot()
            NotificationCenter.default.post(name: .onSwitchTab, object: nil, userInfo: ["tab": 0])
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
            TrackHelper.share.onCatchUserTrack(type: .endLoanReview)
            TrackHelper.share.onUploadRiskEvent(type: .endLoanReview, orderId: "")
        }
    }
}

class PKHTMLViewController: UIViewController {
    
    weak var webView: WKWebView!
    var progressView: UIProgressView!
    
    // 用于传递 SwiftUI View 的 delegate
    weak var delegate: (WKNavigationDelegate & WKScriptMessageHandler)?
    
    var htmlLink: String
    var shouldGoBackToHome: Bool
    
    var onGetName: ((String) -> Void)?
    init(htmlLink: String, shouldReturnHome: Bool = false, onGetName: ((String) -> Void)?) {
        self.htmlLink = htmlLink
        self.shouldGoBackToHome = shouldReturnHome
        self.onGetName = onGetName
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
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.hidesBottomBarWhenPushed = true
    }
    
    private func setupWebView() {
        let userContentController = WKUserContentController()
        
        // 添加 JS 消息处理名称，这些名称与你的 JavaScript 端相对应
        userContentController.add(delegate!, name: "Jariah") // 关闭当前webview
        userContentController.add(delegate!, name: "Naemorhedus") //带参数页面跳转
        userContentController.add(delegate!, name: "pollute") // 回到首页，并关闭当前页
        userContentController.add(delegate!, name: "blahlaut") // app store评分功能
        userContentController.add(delegate!, name: "Ribhus") // 确认申请埋点调用方法
        
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
        progressView.tintColor = .systemPink
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
        } else if keyPath == "title" {
            print("title = \(webView.title)")
            onGetName?(webView.title ?? "")
            navigationItem.title = webView.title
        }
    }
    
    deinit {
        // 移除观察者，防止内存泄漏
        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

