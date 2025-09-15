import SwiftUI
import Kingfisher

// MARK: - 主视图
struct ProfileView: View {
    @EnvironmentObject var appSeting: AppSettings
    @EnvironmentObject var navigationState: NavigationState
    @State private var userCenterModel: PersonCenterModel?
    @State var destination: (String, String) = ("","")
    @State var showLoading: Bool = false
    
    var body: some View {
        ScrollView(content: {
            content
                .padding(.top, 100)
        })
        .background(Color.pink.opacity(0.1).ignoresSafeArea())
        .ignoresSafeArea(edges:.top)
        .onReceive(NotificationCenter.default.publisher(for: .didLogin)) { n in
            self.onFetchProfileList()
        }
        .onReceive(NotificationCenter.default.publisher(for: .onLanding)) { n in
            if let tag = n.userInfo?["tag"] as? Int, tag == 2 {
                self.onFetchProfileList()
            }
        }
        .loading(isLoading: $showLoading)
        .onAppear {
            onFetchProfileList()
        }
    }
    
    var content: some View {
        VStack(alignment:.leading, spacing: 16) {
            profileArea
            certifiedArea
            optionArea
        }
    }
    
    var profileArea: some View {
        // 顶部用户信息
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(appSeting.loginModel?.counterretaliation ?? "")
                    .font(.headline)
            }
            Spacer()
        }.padding(.horizontal, 16)
    }
    
    var certifiedArea: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(userCenterModel?.manlihood == 0 ? "No Certified" : "Certified")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(commonTextColor)
                Text(userCenterModel?.manlihood == 0 ? "Get a loan through certification" : "You have been certified and qualified for the loan")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(secondaryTextColor)
            }
            Spacer()
            Image(userCenterModel?.manlihood == 0 ? "me_uncertified" : "me_certified")            
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 1)
        .padding(16)
    }
    
    var optionArea: some View {
        // 服务工具列表
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Services & Tools")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 18, weight: .black))
                    .padding(.vertical, 16)
                Spacer()
            }
            .padding(.horizontal, 16)
            
            if userCenterModel?.mercantilism?.count ?? 0 > 0 {
                serviceList
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .frame(minHeight: 60)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
    }
    
    var serviceList: some View {
        ForEach(userCenterModel?.mercantilism ?? []) { item in
            Button {
                onTapItem(item: item)
            } label: {
                HStack {
                    KFImage(URL(string: item.poikilitic ?? "")!)
                        .placeholder({
                            Image(systemName: "")
                                .frame(width: 36, height: 36)
                                .background(Color.pink.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(.pink)
                        })
                        .resizable()
                        .frame(width: 36, height: 36)
                        .cornerRadius(8)
                    
                    Text(item.daceloninae ?? "")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(commonTextColor)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.white)
            }
        }
    }
    
    func onTapItem(item: MenuItem) {
        guard let path = item.nectarium,
              let dest = path.getDestination() as? (String?, String?), let link = dest.0 else { return }
        print(path)
        navigationState.destination = dest.0 ?? ""
        navigationState.param = dest.1 ?? ""
        navigationState.shouldGoToRoot = true
    }
}

extension ProfileView {
    func onFetchProfileList() {
        Task {
            do {
                showLoading = true
                let payLoad = AppUserCenterPayload()
                let userCenterResponse: PJResponse<PersonCenterModel> = try await NetworkManager.shared.request(payLoad)
                self.userCenterModel = userCenterResponse.unskepticalness
                appSeting.userCenterModel = userCenterResponse.unskepticalness
                showLoading = false
            } catch {
                showLoading = false
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
