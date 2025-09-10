//
//  NetworkManager.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/2.
//

import Foundation
import UIKit

// MARK: - 网络框架
class NetworkManager {
    static let shared = NetworkManager()
    var isLoading: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .showLoading, object: [Notification.Name.showLoading.rawValue : isLoading])
        }
    }
    
    private init() {}
    
    private let baseURL = "http://149.129.233.8:6175/Velasquez" // 替换成你的基础URL
    
    // MARK: - UPLOAD请求
    func upload<T: Codable>(_ payload: any Payloadprotocol, fileData: Data, fileName: String, mimeType: String) async throws -> PJResponse<T> {
        isLoading = true
        guard let url = URL(string: baseURL + payload.requestPath) else {
            isLoading = false
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = try createMultipartBody(parameters: payload.param, boundary: boundary, data: fileData, mimeType: mimeType, filename: fileName)
        request.httpBody = body
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(PJResponse<T>.self, from: data)
        isLoading = false
        return decoded
    }
    
    // MARK: - 通用请求
    // MARK: - 通用请求
    func request<T: Codable>(_ payload: any Payloadprotocol) async throws -> PJResponse<T> {
        isLoading = true
        guard let url = URL(string: baseURL + payload.requestPath) else {
            isLoading = false
            ToastManager.shared.show("Invalid URL")
            throw URLError(.badURL)
        }

        var request: URLRequest

        switch payload.payloadType {
        case .GET:
            // Re-construct the URL with query items for GET requests
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            if !payload.param.isEmpty {
                components?.queryItems = payload.param.map {
                    URLQueryItem(name: $0.key, value: String(describing: $0.value))
                }
            }
            guard let finalURL = components?.url else { throw URLError(.badURL) }
            request = URLRequest(url: finalURL)
            request.httpMethod = "GET"

        case .POST:
            print("URL == \(url)")
            request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            // Build the URL-encoded string for the POST body, similar to the provided post method
            let parameters = payload.param
            let oamString = parameters.map { key, value in
                let uriKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                let lifetimeValue = String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                return "\(uriKey)=\(lifetimeValue)"
            }.joined(separator: "&")
            request.httpBody = oamString.data(using: .utf8)
            print("Param == \(oamString)")
        default:
            isLoading = false
            ToastManager.shared.show("Unsupported request type")
            throw NSError(domain: "Unsupported request type", code: -1)
        }

        do {
            // Use URLSession.shared.data(for: request) to handle all request types
            let (data, response) = try await URLSession.shared.data(for: request)
            
            print("Result = \(try JSONSerialization.jsonObject(with: data, options: []))")
            // Validate the HTTP response status code, similar to the provided get/post methods
            guard let httpResponse = response as? HTTPURLResponse,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  statusCode == 200
            else {
                isLoading = false
                let error = NSError(domain: "Request failed", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: nil)
                ToastManager.shared.show(error.localizedDescription)
                throw error
            }
            isLoading = false
            // Decode the data
            let decoded = try JSONDecoder().decode(PJResponse<T>.self, from: data)
            
            // Handle specific PJResponse status
            print("request success: \(decoded.diarmuid)")
            switch decoded.goss {
            case .success:
                return decoded
            case .unlogin: // 回到首页 并退出所有页面
                ToastManager.shared.show(decoded.diarmuid)
                throw NSError(domain: "logout", code: -1)
            case .none:
                ToastManager.shared.show(decoded.diarmuid)
                throw NSError(domain: "Unsupported response type", code: -1)
            }
        } catch {
            isLoading = false
            ToastManager.shared.show(error.localizedDescription)
            throw error
        }
    }
    
    // MARK: - 辅助方法：生成multipart body
    private func createMultipartBody(parameters: [String: Any],
                                     boundary: String,
                                     data: Data,
                                     mimeType: String,
                                     filename: String) throws -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    /// 返回拼接好的 URL（GET 使用）
    private func buildURL(for payload: Payloadprotocol) -> URL? {
        guard var components = URLComponents(string: baseURL + payload.requestPath) else {
            return nil
        }
        
        // 合并公共参数和业务参数
        let allParams = payload.param.merging(commonParams()) { current, _ in current }
        
        if payload.payloadType == .GET && !allParams.isEmpty {
            components.queryItems = allParams.map { URLQueryItem(name: $0.key, value: $0.value as! String) }
        }
        
        return components.url
    }
}

extension NetworkManager {
    /// 返回公共参数
    func commonParams() -> [String: String] {
        var params: [String: String] = [
            "ungloriousness": appVersion(),
            "subhatchery": deviceModel(),
            "defacing": deviceId(),
            "spondylopathy": osVersion()
        ]
//        if let sessionId = sessionId { params["moyle"] = sessionId }
//        if let idfa = idfa { params["trophospongial"] = idfa }
//        if let filesniff = filesniff { params["filesniff"] = filesniff }
        return params
    }
    
    // MARK: - 私有方法
    private func appVersion() -> String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    private func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        let identifier = mirror.children.reduce("") { id, element in
            guard let value = element.value as? Int8, value != 0 else { return id }
            return id + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    private func deviceId() -> String {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    private func osVersion() -> String {
        UIDevice.current.systemVersion
    }
}

// MARK: - Data 扩展方便append字符串
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

