import SwiftUI

// MARK: - API 数据模型
struct ServiceItem: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let icon: String
}

// MARK: - 主视图
struct ProfileView: View {
    @State private var serviceItems: [ServiceItem] = []
    
    var body: some View {
        VStack(spacing: 16) {
            profileArea
                       
            certifiedArea
            
            optionArea
            
            Spacer()
        }
        .padding(.top, 50)
        .onAppear {
            loadData()
        }
        .background(Color.pink.opacity(0.1).ignoresSafeArea())
    }
    
    var profileArea: some View {
        // 顶部用户信息
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("91****8888")
                    .font(.headline)
                Text("Welcome to Pinjaman Hebat")
                    .font(.subheadline)
                    .foregroundColor(.gray)
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
            
            ForEach(serviceItems) { item in
                HStack {
                    Image(systemName: item.icon)
                        .frame(width: 36, height: 36)
                        .background(Color.pink.opacity(0.2))
                        .cornerRadius(8)
                        .foregroundColor(.pink)
                    
                    Text(item.title)
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
    
    // MARK: - 模拟 API 请求
    func loadData() {
        // 模拟从 API 获取结果
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.serviceItems = [
                ServiceItem(title: "Loan conditions", icon: "doc.text"),
                ServiceItem(title: "Privacy agreement", icon: "lock.shield"),
                ServiceItem(title: "Online service", icon: "message"),
                ServiceItem(title: "About Us", icon: "person.2"),
                ServiceItem(title: "Set up", icon: "gearshape")
            ]
        }
    }
}
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
