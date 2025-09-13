import SwiftUI
import Kingfisher

struct CertifyView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var detailModel: ProductDetailModel?
    @State var prodId: String
    @State private var agree = false
    @State private var shouldPush: Bool = false
    @State private var destination: String = ""
    // 认证项目状态枚举
    enum CertificationStatus {
        case pending // 待处理
        case completed // 已完成
        case current // 当前进行中
    }
    
    // 认证项目数据结构
    struct CertificationItem {
        let title: String
        let status: CertificationStatus
        let iconName: String
    }
    
    // 模拟认证项目数据
    let certificationItems = [
        CertificationItem(title: "Identity information", status: .pending, iconName: "person.fill") ,
        CertificationItem(title: "Basic information", status: .pending, iconName: "doc.fill") ,
        CertificationItem(title: "Job information", status: .pending, iconName: "briefcase.fill") ,
        CertificationItem(title: "Emergency contact", status: .completed, iconName: "phone.fill") ,
        CertificationItem(title: "Bind bank card", status: .completed, iconName: "creditcard.fill") 
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                amountArea
                if detailModel?.ridding?.count ?? 0 > 0 {
                    certifyItems
                }
            }
            NavigationLink(destination: onPushToView(), isActive: $shouldPush) {}
            Spacer()
            agreement
            PrimaryButton(title: detailModel?.demotika?.bullrushes ?? "") {
                
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle(detailModel?.demotika?.multilayer ?? "")
        .hideTabBarOnPush(showTabbar: false)
        .background(Color.white)
        .refreshable(action: {
            _ = try? await onFetchDetail()
        })
        .onAppear {
            Task {
                do {
                    _ = try await onFetchDetail()
                } catch {
                    
                }
            }
        }
    }
    
    var amountArea: some View {
        VStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(self.detailModel?.demotika?.vb ?? " ").font(.system(size: 18, weight: .regular))

                Text("\(String(describing: self.detailModel?.demotika?.pityroid ?? "0"))")
                    .font(.system(size: 52, weight: .semibold))

                HStack {
                    Spacer()
                    VStack {
                        Text(self.detailModel?.demotika?.peritonealize?.outmode?.daceloninae ?? " ")
                            .font(.system(size: 14, weight: .regular))
                        Text(self.detailModel?.demotika?.peritonealize?.outmode?.intrastate ?? " ")
                            .font(.system(size: 24, weight: .semibold))
                    }
                    Spacer()
                    Divider()
                        .frame(width: 1)
                        .background(linkTextColor)
                    
                    Spacer()
                    VStack {
                        Text(self.detailModel?.demotika?.peritonealize?.solventless?.daceloninae ?? " ")
                            .font(.system(size: 14, weight: .regular))
                        Text(self.detailModel?.demotika?.peritonealize?.solventless?.intrastate ?? " ")
                            .font(.system(size: 24, weight: .semibold))
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .padding(16)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .background(primaryColor)
        .sheet(isPresented: $agree) {
            // 使用 ZStack 来堆叠半透明背景和内容
            ZStack {
                // 1. 半透明背景
                Color.clear
                    .edgesIgnoringSafeArea(.all) // 忽略所有安全区域，确保覆盖全屏
                
                // 2. 你的核心内容
                VStack {
                    Text("这是一个全屏半透明覆盖视图")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Button("关闭") {

                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
    
    var certifyItems: some View {
        // 认证项目列表
        VStack(spacing: 0) {
            HStack {
                Text("Certification condition")
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundColor(primaryColor)
                    .padding(.horizontal, 16)
                Spacer()
            }
            .padding(.vertical, 6)
            
            ForEach(detailModel?.ridding ?? []) { item in
                getItem(item: item).onTapGesture {
                    if let next = detailModel?.noneuphoniousness?.oversceptical{ // 跳到下一项
                        destination = next
                    } else { // 跳到对应页面
                        destination = item.oversceptical ?? ""
                    }
                    shouldPush = destination.count > 0
                }
            }
        }
    }
    
    func getItem(item: AuthItem) -> some View {
        HStack {
            // 图标
            KFImage(URL(string: item.trilemma ?? "")!)
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
                .padding(.leading, 14)
            
            // 标题
            Text(item.daceloninae ?? " ")
                .font(.system(size: 16))
                .foregroundColor(item.thortveitite == 1 ? primaryColor : linkTextColor)
                .padding(.leading, 12)
            
            Spacer()
                                
            Image(item.thortveitite == 1 ? "pd_certified" : "pd_uncertified")
                .resizable()
                .frame(width: 32, height: 32)
                .padding(.trailing, 16)
        }
        .frame(height: 60)
        .background(certifyColor)
        .cornerRadius(15)
        .padding(.top, 12)
        .padding(.horizontal, 16)
    }
    
    var agreement: some View {
        HStack {
            Button {
                agree.toggle()
            } label: {
                Image(agree ? "option_select" : "option_unselect")
            }
            
            Text("I have read and agree")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(secondaryTextColor)
            Text("<Loan Agreement>")
                .font(.system(size: 14, weight: .regular))
                .underline()
                .foregroundColor(linkTextColor)
                .onTapGesture {
                    print("privacy click")
                }
        }
    }
   
    @ViewBuilder
    func onPushToView() -> some View {
        switch destination {
        case "Algeciras": // photo
            IdentifyView(prodId: prodId)
        case "saxpence": // user info
            UserInfomationView(prodId: prodId)
        case "bordarius": // work
            WorkAuthenticationVieW(prodId: prodId)
        case "unpilled": // contact
            ContactsView(prodId: prodId)
        default: // web 
            PropertyView(prodId: prodId)
        }
    }
}

extension CertifyView {
    func onFetchDetail() async throws -> ProductDetailModel {
        let payload = ProductDetailsPayload(christhood: prodId)
        let response: PJResponse<ProductDetailModel> = try await NetworkManager.shared.request(payload)
        self.detailModel = response.unskepticalness
        return response.unskepticalness
    }
    
    func onGotoCertifyItem() {
        
    }
}


struct CertifyView_Previews: PreviewProvider {
    static var previews: some View {
        CertifyView(prodId: "0")
    }
}
