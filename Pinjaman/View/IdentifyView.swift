//
//  IdentifyView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/30.
//

import SwiftUI
import Kingfisher

struct IdentifyView: View {
    @StateObject private var imagePickerManager = ImagePickerManager()
    @EnvironmentObject var appSeting: AppSettings
    @MainActor @State private var showLoading: Bool = false
    @State private var destination: (String, String) = ("","")
    @State private var shouldPush: Bool = false
    @State private var selectedImage: UIImage?
    @State private var isShowingOptions = false
    @State var prodId: String
    @State var identityModel: UserIdentityModel?
    @State var sourceType: UIImagePickerController.SourceType?
    @State var identityType: String = "10"
    @State var onShowConfirmationView: Bool = false
    @State var identityCardModel: IdentityCardResponse?

    var body: some View {
        contentView
    }
    
    var contentView: some View {
        VStack(alignment: .center, spacing: 14) {
            title
                 
            photoArea
            
            NavigationLink(destination: NavigationManager.navigateTo(for: destination.0, prodId: destination.1),
                           isActive: $shouldPush) {}
            
            Spacer()
            
            PrimaryButton(title: "Next") {
                onFetchNext()
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle("Identity information")
        .padding(0)
        .hideTabBarOnPush(showTabbar: false)
        .loading(isLoading: $showLoading)
        .onAppear {
            onFetchUserIdentityInfo()
            onRelocation()
        }
        .confirmationDialog("选择图片来源", isPresented: $isShowingOptions, titleVisibility: .visible) {
            
            Button("Camera") {
                sourceType = .camera
                imagePickerManager.checkCameraPermission()
            }
            
            if identityType == "11" {
                Button("Album") {
                    sourceType = .photoLibrary
                    imagePickerManager.checkPhotoLibraryPermission()
                }
            }
            
            Button("Cancel", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $imagePickerManager.isShowingPicker) {
            if let sourceType = sourceType {
                ImagePickerView(isPresented: $imagePickerManager.isShowingPicker, onSelectedImage: { image in
                    self.onUploadImage(image: image)
                }, sourceType: sourceType)
                .ignoresSafeArea()
            }
        }.overlay {
            if onShowConfirmationView {
                InformationConfirmPopUp(isPresented: $onShowConfirmationView, identityCardModel: $identityCardModel, onConfirm: { param in
                    print("param = \(param)")
                    onSubmitIdentityInfo(param: param)
                })
                .ignoresSafeArea()
            }
        }
    }
    
    var title: some View {
        Text("Please fill in your personal data (don't worry, your information and data are protected)")
            .font(.system(size: 12, weight: .regular))
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(tipsbgColor)
            .foregroundColor(tipsColor)
    }
    
    var photoArea: some View {
        VStack(spacing: 28) {
            VStack(spacing: 14) {
                Text(self.identityModel?.aladfar?.sofars ?? " ")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(commonTextColor)
                Button { // 证件
                    identityType = "11"
                    isShowingOptions = true
                    TrackHelper.share.onCatchUserTrack(type: .front)
                } label: {
                    ZStack {
                        if let iconLink = self.identityModel?.aladfar?.caliology,
                           let url = URL(string: iconLink) {
                            KFImage(url)
                                .resizable()
                                .placeholder({ _ in
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 300, height: 190)
                                        .background(productBgColor)
                                })
                                .frame(width: 300, height: 190)
                                .aspectRatio(contentMode: .fit)
                        } else {
                            Image("good_person_card")
                                .resizable()
                                .frame(width: 300, height: 190)
                                .aspectRatio(contentMode: .fit)
                                .padding(.horizontal, 38)
                        }
                    }
                }.disabled((self.identityModel?.aladfar?.caliology?.count ?? 0) > 0)
            }
    
            VStack(spacing: 14) {
                Text(self.identityModel?.aladfar?.polymyarii ?? " ")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(commonTextColor)
                Button { // 人脸
                    // 如果是英语/印度 那么类型就是pan卡。
                    identityType = (appSeting.configModal.unsafelyUnwrapped.filesniff ?? 0) == 1 ? "13" : "10"
                    isShowingOptions = true
                    TrackHelper.share.onCatchUserTrack(type: .selfie)
                } label: {
                    ZStack {
                        if let iconLink = self.identityModel?.aladfar?.circumvents,
                           let url = URL(string: iconLink) {
                            KFImage(url)
                                .resizable()
                                .placeholder({ _ in
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 170, height: 170)
                                        .background(productBgColor)
                                })
                                .frame(width: 170, height: 170)
                        } else {
                            Image("good_person_face")
                                .resizable()
                                .frame(width: 170, height: 170)
                                .aspectRatio(contentMode: .fit)
                        }
                        
                    }
                }.disabled((self.identityModel?.aladfar?.circumvents?.count ?? 0) > 0)
            }
        }
    }
}

extension IdentifyView {
    func onFetchUserIdentityInfo() {
        Task {
            showLoading = true
            do {
                let payload = GetUserIdentityInfoPayload(christhood: prodId)
                let response: PJResponse<UserIdentityModel> = try await NetworkManager.shared.request(payload)
                self.identityModel = response.unskepticalness
                showLoading = false
            } catch {
                showLoading = false
            }
        }
    }
    
    func onRelocation() {
        appSeting.adressManager.startUpdatingLocation()
    }
    
    func onUploadImage(image: UIImage) {
        Task {
            showLoading = true
            do {
                let data = await image.compressTo(maxSize: 1024 * 1024)
                let payload = UploadIdentityInfoPayload(oxystome: identityType, redowl: sourceType == .camera ? "1" : "2")
                
                let response: PJResponse<IdentityCardResponse> = try await NetworkManager.shared.upload(payload, fileData: data ?? Data(), fileName: "Image_ph.png", mimeType: "image/png")
                self.identityCardModel = response.unskepticalness
                if identityType == "11" { // card
                    onShowConfirmationView = true
                    TrackHelper.share.onUploadRiskEvent(type: .front, orderId: "")
                } else { // face
                    onFetchUserIdentityInfo()
                    TrackHelper.share.onUploadRiskEvent(type: .selfie, orderId: "")
                }
            } catch {
                print(error)
                showLoading = false
            }
        }
    }
    
    func onSubmitIdentityInfo(param: [String: String]) {
        Task {
            do {
                showLoading = true
                var parameter = param
                parameter["christhood"] = prodId
                let payload = SaveIdentityInfoPayload(param: parameter)
                let response: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payload)
                // refresh data
                onFetchUserIdentityInfo()
            } catch {
                showLoading = false
            }
        }
    }
    
    func onFetchNext() {
        guard let model = self.identityModel else {
            return
        }
        
        // card empty -> show card
        if let caliology = model.aladfar?.caliology as? String, caliology.isEmpty {
            identityType = "11"
            isShowingOptions = true
            return
        }
        
        // face empty -> show face
        if let circumvents = model.aladfar?.circumvents, circumvents.isEmpty {
            identityType = (appSeting.configModal.unsafelyUnwrapped.filesniff ?? 0) == 1 ? "13" : "10"
            isShowingOptions = true
            return
        }
        
        // else submit infomation
        Task {
            do {
                let payload = ProductDetailsPayload(christhood: prodId)
                let response: PJResponse<ProductDetailModel> = try await NetworkManager.shared.request(payload)
                showLoading = false
                onGoToNext(detailModel: response.unskepticalness)
            } catch {
                showLoading = false
            }
        }
    }
    
    func onGoToNext(detailModel: ProductDetailModel) {
        if let next = detailModel.noneuphoniousness?.oversceptical { // 跳到下一项
            destination = (next, prodId)
            shouldPush = next.count > 0
        }
    }
    
}

#Preview {
    IdentifyView(prodId: "")
}
