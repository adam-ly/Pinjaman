import SwiftUI

struct CertifyView: View {
    @Environment(\.presentationMode) var presentationMode
    
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
            // 认证项目列表
            VStack(spacing: 0) {
                ForEach(certificationItems.indices, id: \.self) {
                    index in
                    
                    HStack {
                        // 图标
                        Image(systemName: certificationItems[index].iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(certificationItems[index].status == .completed ? .green : .gray)
                            .padding(.leading, 16)
                        
                        // 标题
                        Text(certificationItems[index].title)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .padding(.leading, 12)
                        
                        Spacer()
                        
                        // 状态指示器
                        if certificationItems[index].status == .completed {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                                .foregroundColor(.green)
                                .padding(.trailing, 16)
                        } else {
                            Image(systemName: "chevron.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 14, height: 20)
                                .foregroundColor(.gray)
                                .padding(.trailing, 16)
                        }
                    }
                    .frame(height: 64)
                    .background(Color.white)
                    
                    // 分割线，除了最后一个
                    if index < certificationItems.count - 1 {
                        Divider()
                            .padding(.leading, 56)
                    }
                }
            }
            .cornerRadius(10)
            .padding(.top, 16)
            .padding(.horizontal, 16)
            
            Spacer()
            
            // 底部协议
            HStack {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .foregroundColor(.green)
                    .padding(.leading, 16)
                
                Text("I have read and agree ")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text("Loan Agreement")
                    .font(.system(size: 14))
                    .foregroundColor(Color("AccentColor"))
                
                Spacer()
            }
            .padding(.bottom, 30)
        }
        .background(Color(UIColor.systemGray5))
        .edgesIgnoringSafeArea(.all)
    }
}

struct CertifyView_Previews: PreviewProvider {
    static var previews: some View {
        CertifyView()
    }
}