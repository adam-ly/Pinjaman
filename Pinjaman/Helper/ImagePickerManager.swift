//
//  ImagePickerManager.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/11.
//
import SwiftUI
import Photos
import AVFoundation

/// 管理图片选择和拍照的类
class ImagePickerManager: ObservableObject {
    // @Published 属性，用于控制 picker 的显示状态
    @Published var isShowingPicker = false
    
    // 内部变量，用于决定是打开相机还是相册
    private var sourceType: UIImagePickerController.SourceType?
    
    /// 打开相机或相册
    func openPicker(sourceType: UIImagePickerController.SourceType) {
        self.sourceType = sourceType
        self.isShowingPicker = true
    }
    
    // MARK: - 权限检查
    
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.openPicker(sourceType: .camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.openPicker(sourceType: .camera)
                    } else {
                        NotificationCenter.postAlert(alertType: .camera)
                    }
                }
            }
        case .denied, .restricted:
            NotificationCenter.postAlert(alertType: .camera)
        @unknown default:
            return
        }
    }
    
//    func checkPhotoLibraryPermission() {
//        let status = PHPhotoLibrary.authorizationStatus()
//        switch status {
//        case .authorized:
//            self.openPicker(sourceType: .photoLibrary)
//        case .limited: // iOS 14+
//            self.openPicker(sourceType: .photoLibrary)
//        case .notDetermined:
//            PHPhotoLibrary.requestAuthorization { newStatus in
//                DispatchQueue.main.async {
//                    if newStatus == .authorized || newStatus == .limited {
//                        self.openPicker(sourceType: .photoLibrary)
//                    } else {
////                        NotificationCenter.postAlert(alertType: .album)
//                    }
//                }
//            }
//        case .denied, .restricted:
////            NotificationCenter.postAlert(alertType: .album)
//        @unknown default:
//            return
//        }
//    }    
}

/// 封装 UIImagePickerController 的视图
struct ImagePickerView: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    var onSelectedImage: ((UIImage) -> Void)?
    let sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePickerView
        
        init(parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.onSelectedImage?(uiImage)
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}
