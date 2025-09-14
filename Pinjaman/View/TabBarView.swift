import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var appSeting: AppSettings
    @State private var selectedTab = 0
    @Binding var showLoginView: Bool
    
    // 1. 建立我們的自定義綁定 (這是關鍵)
    private var tabSelectionBinding: Binding<Int> {
        Binding(
            // `get`：當 TabView 需要讀取當前選中項時調用
            get: {
                return self.selectedTab
            },
            // `set`：當使用者點擊 Tab，TabView 嘗試寫入新值時調用
            set: { tappedTab in
                // 在這裡放入我們的攔截邏輯
                if !appSeting.isLogin() && tappedTab != 0 {
                    self.selectedTab = 0
                    print("攔截成功！使用者未登入，準備彈出登入頁面。")
                    // 執行攔截動作：彈出登入頁
                    showLoginView = true
                } else {
                    // 如果不需要攔截，就正常更新我們的狀態
                    self.selectedTab = tappedTab
                }
            }
        )
    }
    
    var body: some View {
        TabView(selection: tabSelectionBinding) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("首页")
                }
                .tag(0)
            
            // 贷款页面 - 添加登录拦截
            OrderView()
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("贷款")
                }
                .tag(1)
            
            // 个人中心页面 - 添加登录拦截
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("我的")
                }
                .tag(2)
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.black // 背景色
            
            // 普通状态
            appearance.stackedLayoutAppearance.normal.iconColor = .gray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
            
            // 选中状态
            appearance.stackedLayoutAppearance.selected.iconColor = .systemPink
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemPink]
            
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

struct CustomTabBar_Previews_Content: View {
    @State var showLogin: Bool = false
    var body: some View {
        TabBarView(showLoginView: $showLogin)
            .environmentObject(AppSettings.shared)
    }
}

// 预览
struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar_Previews_Content()
    }
}
