import SwiftUI
class NavigationState: ObservableObject {
    @Published var shouldGoToRoot: Bool = false
    @Published var destination: String = ""
    @Published var param: String = ""
}

struct TabBarView: View {
    @StateObject private var navigationState = NavigationState()
    @EnvironmentObject var appSeting: AppSettings
    @State private var selectedTag = 0
    @Binding var showLoginView: Bool
    
    var body: some View {                        
        NavigationView {
            VStack{
                ZStack {
                    HomeView()
                        .opacity(selectedTag == 0 ? 1 : 0)
                    OrderView()
                        .opacity(selectedTag == 1 ? 1 : 0)
                    ProfileView()
                        .opacity(selectedTag == 2 ? 1 : 0)
                    NavigationLink(destination: NavigationManager.navigateTo(for: navigationState.destination, prodId: navigationState.param), isActive: $navigationState.shouldGoToRoot) {
                        EmptyView() // 隐藏的 NavigationLink 标签
                    }
                }
                tabArea
            }
        }
        .tint(.white)
        .environmentObject(navigationState)
        .onReceive(NotificationCenter.default.publisher(for: .didLogout)) { n in
            selectedTag = 0
        }
        .onReceive(NotificationCenter.default.publisher(for: .onSwitchTab)) { n in
            guard let userInfo = n.userInfo as? [String: Any],
                  let tab = userInfo["tab"] as? Int else {
                return
            }
            selectedTag = tab
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
    
    var tabArea: some View {
        HStack(alignment: .center) {
            Spacer()
            Button {
                selectedTag = 0
                NotificationCenter.default.post(name: .onLanding, object: nil, userInfo: ["tag" : selectedTag])
            } label: {
                TabButton(selectedTag: $selectedTag, tag: 0, image: "home_unselected", selectedImage: "home_selected")
            }
            Spacer()
            Button {
                if !appSeting.isLogin() {
                    showLoginView = true
                } else {
                    selectedTag = 1
                    NotificationCenter.default.post(name: .onLanding, object: nil, userInfo: ["tag" : selectedTag])
                }
            } label: {
                TabButton(selectedTag: $selectedTag, tag: 1, image: "order_unselected", selectedImage: "order_selected")
            }
            Spacer()
            Button {
                if !appSeting.isLogin() {
                    showLoginView = true
                } else {
                    selectedTag = 2
                    NotificationCenter.default.post(name: .onLanding, object: nil, userInfo: ["tag" : selectedTag])
                }
            } label: {
                TabButton(selectedTag: $selectedTag, tag: 2, image: "me_unselected", selectedImage: "me_selected")
            }
            Spacer()
        }
        .frame(height: 50)
        .background(commonTextColor)
        .cornerRadius(25)
        .padding(.horizontal, 16)
    }
}

struct TabButton: View {
    @Binding var selectedTag: Int
    var tag: Int
    var image: String
    var selectedImage: String
    var body: some View {
        Image(selectedTag == tag ? selectedImage : image)
            .frame(minWidth: 38, minHeight: 38)
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
