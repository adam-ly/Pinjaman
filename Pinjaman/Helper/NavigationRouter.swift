//
//  NavigationRouter.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/20.
//

import SwiftUI
import Combine

// 步骤 1: 定义所有可能的导航目标页面
// 让它 Hashable 以便在需要时可以在 ForEach 中使用
/// 定义应用程序内部所有页面的枚举
/// 使用字符串作为原始值，以匹配后端的路由名称
enum Destination: Hashable {
    case photo
    case userInfo
    case work
    case contact
    case bank
    case order
    case certify
    case login
    case homePage
    case setting
    case cancellation
    
    /// A general-purpose case to receive any other string value.
    case other(String)

    /// Custom initializer to create an enum instance from a string.
    /// It mimics the behavior of a failable initializer from `RawRepresentable`.
    init(rawValue: String) {
        switch rawValue {
        case "Algeciras":
            self = .photo
        case "saxpence":
            self = .userInfo
        case "bordarius":
            self = .work
        case "unpilled":
            self = .contact
        case "synastry":
            self = .bank
        case "pa://ks.mo.ent/contrude":
            self = .order
        case "pa://ks.mo.ent/aloetic":
            self = .certify
        case "pa://ks.mo.ent/Frametown":
            self = .login
        case "pa://ks.mo.ent/Italophile":
            self = .homePage
        case "pa://ks.mo.ent/Berkly":
            self = .setting
        case "pa://ks.mo.ent/cancellation":
            self = .cancellation
        default:
            // If the string does not match any known case,
            // initialize it as the .other case, storing the original string.
            self = .other(rawValue)
        }
    }

    /// A computed property to get the string value, mimicking a rawValue.
    var rawValue: String {
        switch self {
        case .photo:
            return "Algeciras"
        case .userInfo:
            return "saxpence"
        case .work:
            return "bordarius"
        case .contact:
            return "unpilled"
        case .bank:
            return "synastry"
        case .order:
            return "pa://ks.mo.ent/contrude"
        case .certify:
            return "pa://ks.mo.ent/aloetic"
        case .login:
            return "pa://ks.mo.ent/Frametown"
        case .homePage:
            return "pa://ks.mo.ent/Italophile"
        case .setting:
            return "pa://ks.mo.ent/Berkly"
        case .cancellation:
            return "pa://ks.mo.ent/cancellation"
        // For the .other case, return the associated string value.
        case .other(let value):
            return value
        }
    }
    
    // ADD THIS: Provide a hashing function based on the rawValue
       func hash(into hasher: inout Hasher) {
           hasher.combine(rawValue)
       }

       // ADD THIS: Define equality based on the rawValue
       static func == (lhs: Destination, rhs: Destination) -> Bool {
           lhs.rawValue == rhs.rawValue
       }
}

// 1. 创建一个结构体来组合目标和参数
struct NavigationPathElement: Hashable {
    static func == (lhs: NavigationPathElement, rhs: NavigationPathElement) -> Bool {
        return lhs.destination.rawValue == rhs.destination.rawValue && lhs.parameter == rhs.parameter
    }
    
    let destination: Destination
    let parameter: String
}

// 步骤 2: 定义你的 Tab
enum Tab {
    case home
    case order
    case profile
}

// 1. 创建一个协议，用来识别持有 Destination 的控制器
protocol DestinationHolder {
    var destination: Destination { get }
}

// 2. 创建 UIHostingController 的子类，并遵循上面的协议
// 我们用它来包裹所有被推入的 SwiftUI 页面
class DestinationHostingController<Content: View>: UIHostingController<Content>, DestinationHolder {
    
    // 这个属性就是我们的“标签”
    let destination: Destination

    init(destination: Destination, rootView: Content) {
        self.destination = destination
        super.init(rootView: rootView)
    }
    
    // 这是 UIHostingController 的一个必要实现，我们直接让它报错即可
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


final class NavigationRouter: ObservableObject {
    
    // 我们不再需要 @Published path 数组了
    @Published var currentTab: Tab = .home
    
    // 持有一个对 UIKit 导航控制器的弱引用
    weak var navigationController: UINavigationController?
    
    func push(to element: NavigationPathElement) {
        guard let navigationController = navigationController else {
            print("Error: NavigationController not set on Router.")
            return
        }
        
        // 1. 使用 viewForDestination 创建你的 SwiftUI 视图
        let destinationView = viewForDestination(element)
        
        // 2. 将你的 SwiftUI 视图包裹在一个 UIHostingController 中
        // 使用我们新的 DestinationHostingController，并传入 destination 作为标签
        let hostingController = DestinationHostingController(
            destination: element.destination,
            rootView: destinationView.environmentObject(self)
        )
        hostingController.title = " " // 你可以在这里设置标题，或在 SwiftUI 视图内部用 .navigationTitle
        
        // 3. 使用 UINavigationController 可靠的 push 方法
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // --- ！！！新增的方法！！！ ---
    /// 返回到导航堆栈中最近的一个指定类型的页面
    func pop(to destination: Destination) {
        guard let viewControllers = navigationController?.viewControllers else {
            print("Error: Could not get view controllers from navigation controller.")
            return
        }
        
        // 从后往前遍历视图堆栈，找到第一个匹配目标 destination 的控制器
        if let targetViewController = viewControllers.last(where: { viewController in
            // 检查这个 viewController 是否遵循了我们的协议
            if let holder = viewController as? DestinationHolder {
                // 如果是，再检查它的 destination 是否是我们想要的
                return holder.destination == destination
            }
            return false
        }) {
            // 如果找到了，就调用 UIKit 的原生方法返回到它
            navigationController?.popToViewController(targetViewController, animated: true)
        } else {
            // 如果在当前堆栈中找不到该类型的页面，打印一个警告
            print("Warning: Destination '\(destination.rawValue)' not found in navigation stack. Cannot pop.")
        }
    }
}

struct NavigationHost: UIViewControllerRepresentable {
    @EnvironmentObject var router: NavigationRouter
    
    // 你 App 的主视图，也就是那个 TabView
    let rootView: AnyView
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        // 1. 创建 TabView 的宿主控制器
        let tabViewHostingController = UIHostingController(rootView: rootView)
        
        // 2. 创建一个 UINavigationController，并将 TabView 作为它的根视图
        let navController = UINavigationController(rootViewController: tabViewHostingController)
        navController.delegate = context.coordinator
        // 3. 隐藏 NavigationView 默认的导航栏，让 SwiftUI 视图自己管理
        navController.navigationBar.isHidden = true
        
        // 4. 将创建好的 navController 实例交给我们的 Router
        // 这是连接 SwiftUI 世界和 UIKit 世界的关键一步
        DispatchQueue.main.async {
            self.router.navigationController = navController
        }
        
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        if let hostingController = uiViewController.viewControllers.first as? UIHostingController<AnyView> {
            hostingController.rootView = self.rootView
        } else {            
            print("Error: Could not find the root UIHostingController to update.")
        }
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate {
        var parent: NavigationHost

        init(_ parent: NavigationHost) {
            self.parent = parent
        }
        
        func navigationController(_ navigationController: UINavigationController,
                                  willShow viewController: UIViewController,
                                  animated: Bool) {
            let isRootView = (viewController == navigationController.viewControllers.first)
            navigationController.setNavigationBarHidden(isRootView, animated: animated)
        }
    }
}

@ViewBuilder
func viewForDestination(_ destination: NavigationPathElement) -> some View {
    let prodId = destination.parameter
    switch destination.destination {
    case .photo:
        IdentifyView(prodId: prodId)
        
    case .userInfo:
        UserInfomationView(prodId: prodId)
        
    case .work:
        WorkAuthenticationVieW(prodId: prodId)
        
    case .contact:
        ContactsView(prodId: prodId)
        
    case .bank:
        PropertyView(prodId: prodId)
        
    case .certify:
        CertifyView(prodId: prodId)
        
    case .setting:
        SetUpView()
        
    case .cancellation:
        CancellationView()
        
    default:
        // 处理所有未列举的字符串，包括外部 URL
        if destination.destination.rawValue.contains("http") {
            PKWebView(htmlLink: destination.destination.rawValue, shouldGoBackToHome: false)
        } else {
            Text("未知路由：\(destination)")
        }
    }
}
