import SwiftUI
import Kingfisher

// MARK: - 主视图
struct ProfileView: View {
    @EnvironmentObject var appSeting: AppSettings
    @State private var userCenterModel: PersonCenterModel?
    
    var body: some View {
        VStack(spacing: 16) {
            profileArea
                       
            if userCenterModel?.manlihood != nil && userCenterModel?.manlihood == 0 {
                certifiedArea
            }
            
            optionArea
            
            Spacer()
        }
        .padding(.top, 50)
        .onAppear {
            onFetchProfileList()
        }
        .background(Color.pink.opacity(0.1).ignoresSafeArea())
    }
    
    var profileArea: some View {
        // 顶部用户信息
        HStack {
//            KFImage(URL(string: "https://example.com/your-image.jpg"))
//                .placeholder({
//                })
//                .resizable()
//                .frame(width: 60, height: 60)
//                .foregroundColor(.blue)
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(appSeting.loginModel?.counterretaliation ?? "")
                    .font(.headline)
//                Text(appSeting.loginModel?.counterretaliation ?? "")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
            }
            Spacer()
        }.padding(.horizontal, 16)
    }
    
    var certifiedArea: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("No Certified")
                    .font(.headline)
                Text("Get a loan through certification")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "arrow.right.circle.fill")
                .foregroundColor(.pink)
                .font(.title2)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 1)
        .padding(16)
    }
    
    var optionArea: some View {
        // 服务工具列表
        VStack(alignment: .leading, spacing: 10) {
            Text("Services & Tools")
                .font(.headline)
                .padding(.horizontal)
            
            if userCenterModel?.mercantilism?.count ?? 0 > 0 {
                serviceList
            }
        }
    }
    
    var serviceList: some View {
        ForEach(userCenterModel?.mercantilism ?? []) { item in
            HStack {
//                Image(systemName: item.icon)
//                    .frame(width: 36, height: 36)
//                    .background(Color.pink.opacity(0.2))
//                    .cornerRadius(8)
//                    .foregroundColor(.pink)
                
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
                
                Text(item.daceloninae)
                    .font(.body)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
            .padding(.horizontal)
        }
    }
}

extension ProfileView {
    func onFetchProfileList() {
        Task {
            do {
                let payLoad = AppUserCenterPayload()
                let userCenterResponse: PJResponse<PersonCenterModel> = try await NetworkManager.shared.request(payLoad)
                self.userCenterModel = userCenterResponse.unskepticalness
            } catch {
                
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
