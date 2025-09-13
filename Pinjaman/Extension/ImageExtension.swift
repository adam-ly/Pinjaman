//
//  ImageExtension.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/11.
//
import UIKit

extension UIImage {
    /// 将图片压缩到指定大小以内（异步）
    /// - Parameters:
    ///   - maxSize: 目标最大字节数
    ///   - maxWidth: 可选最大宽度（按比例缩放）
    /// - Returns: 压缩后的图片数据，或 nil 表示失败
    func compressTo(
        maxSize: Int,
        maxWidth: CGFloat? = nil
    ) async -> Data? {
        await Task.detached(priority: .userInitiated) {
            // 1. 先尝试降低质量
            var compression: CGFloat = 1.0
            let data = self.jpegData(compressionQuality: compression)
            guard var imageData = data else { return nil }
            
            if imageData.count <= maxSize { return imageData }
            
            // 二分法快速逼近目标大小
            var lower: CGFloat = 0
            var upper: CGFloat = 1
            for _ in 0..<6 {          // 6 次即可收敛到 1.5% 误差
                compression = (lower + upper) / 2
                imageData = self.jpegData(compressionQuality: compression)!
                if imageData.count <= maxSize {
                    lower = compression
                } else {
                    upper = compression
                }
            }
            
            // 2. 若仍超标，开始缩放
            guard let maxWidth = maxWidth else { return imageData }
            
            var scaledImage = self
            var width  = scaledImage.size.width
            var height = scaledImage.size.height
            
            while imageData.count > maxSize, width > 100 {
                width  *= 0.9
                height *= 0.9
                
                let newSize = CGSize(width: width, height: height)
                scaledImage = scaledImage.resize(to: newSize)
                imageData = scaledImage.jpegData(compressionQuality: 0.8)!
            }
            
            return imageData.count <= maxSize ? imageData : nil
        }.value
    }
    
    // MARK: - 缩放（同步，已在线程内调用）
    private func resize(to targetSize: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        return UIGraphicsImageRenderer(size: targetSize, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
