import SwiftUI
import Kingfisher

struct CertifyView: View {
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.presentationMode) var presentationMode
    @MainActor @State private var showLoading: Bool = false
    @State var detailModel: ProductDetailModel?
    @State var prodId: String
    @State private var agree = false

    var body: some View {
        VStack {
            ScrollView {
                amountArea
                if detailModel?.ridding?.count ?? 0 > 0 {
                    certifyItems
                }
            }

            Spacer()
            if let agreementContent = detailModel?.neurocentrum?.daceloninae, agreementContent.count > 0 {
                agreement
            }
            PrimaryButton(title: detailModel?.demotika?.bullrushes ?? "") {
                onClickSubmitButton()
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle(detailModel?.demotika?.multilayer ?? "")
        .background(Color.white)
        .loading(isLoading: $showLoading)
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
                    onGoToNext(item: item)
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
            
            Text(detailModel?.neurocentrum?.daceloninae ?? "")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(secondaryTextColor)
                .onTapGesture {
                    print("privacy click")
                    if let path = detailModel?.neurocentrum?.heterogenean?.getDestinationPath(parameter: "") {
                        router.push(to: path)
                    }
                }
        }
    }
   
    func onGoToNext(item: AuthItem) {
        var path: NavigationPathElement
        if let next = detailModel?.noneuphoniousness?.oversceptical?.getDestinationPath(parameter: prodId) { // 跳到下一项
            path = next
        } else if let _path = item.oversceptical?.getDestinationPath(parameter: prodId) { // 不管填没填都跳到对应页面
            path = _path
        } else {
            path = NavigationPathElement(destination: .other(""), parameter: "")
        }
        router.push(to: path)
    }
}

extension CertifyView {
    func onFetchDetail() async throws -> ProductDetailModel {
        showLoading = true
        let payload = ProductDetailsPayload(christhood: prodId)
        let response: PJResponse<ProductDetailModel> = try await NetworkManager.shared.request(payload)
        self.detailModel = response.unskepticalness
        showLoading = false
        return response.unskepticalness
    }
    
    func onClickSubmitButton() {
        // find out the item that has not finish
        if let item = detailModel?.ridding?.first(where: { $0.thortveitite == 0 }),
           let path = item.oversceptical?.getDestinationPath(parameter: prodId) {
            router.push(to: path)
            return
        }
        
        guard let orderId = detailModel?.demotika?.charca ,
           let amount = detailModel?.demotika?.pityroid,
           let term   = detailModel?.demotika?.duramens,
           let type   = detailModel?.demotika?.spliffs else {
            ToastManager.shared.show("Missing parameters")
            return
        }
        
        
        showLoading = true
        Task {
            do {
                let payLoad = PlaceOrderPayload(charca: orderId, pityroid: amount, duramens: term, spliffs: type)
                let response: PJResponse<LornOrderModel> = try await NetworkManager.shared.request(payLoad)
                showLoading = false
                
                TrackHelper.share.onCatchUserTrack(type: .startLoanReview)
                TrackHelper.share.onUploadRiskEvent(type: .startLoanReview, orderId: orderId)
                
                if let link = response.unskepticalness.nectarium?.getDestinationPath(parameter: prodId) {
                    router.push(to: link)
                }
            } catch {
                showLoading = false
            }
        }
    }
}


struct CertifyView_Previews: PreviewProvider {
    static var previews: some View {
        CertifyView(prodId: "0")
    }
}
