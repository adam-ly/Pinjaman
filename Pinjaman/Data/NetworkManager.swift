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
    private init() {}
    
    private let baseURL = "http://149.129.233.8:6175/Velasquez" // 替换成你的基础URL
    
    // MARK: - GET请求
    func get<T: Codable>(_ payload: any Payloadprotocol) async throws -> Response<T> {
        try await request(payload)
    }
    
    // MARK: - POST请求
    func post<T: Codable>(_ payload: any Payloadprotocol) async throws -> Response<T> {
        try await request(payload)
    }
    
    // MARK: - UPLOAD请求
    func upload<T: Codable>(_ payload: any Payloadprotocol, fileData: Data, fileName: String, mimeType: String) async throws -> Response<T> {
        guard let url = URL(string: baseURL + payload.requestPath) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = try createMultipartBody(parameters: payload.param, boundary: boundary, data: fileData, mimeType: mimeType, filename: fileName)
        request.httpBody = body
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(Response<T>.self, from: data)
        return decoded
    }
    
    // MARK: - 通用请求
    private func request<T: Codable>(_ payload: any Payloadprotocol) async throws -> Response<T> {
        guard var components = URLComponents(string: baseURL + payload.requestPath) else {
            throw URLError(.badURL)
        }
        
        var request: URLRequest
        
        switch payload.payloadType {
        case .GET:
            if !payload.param.isEmpty {
                components.queryItems = payload.param.map { URLQueryItem(name: $0.key, value: $0.value as! String) }
            }
            guard let url = components.url else { throw URLError(.badURL) }
            request = URLRequest(url: url)
            request.httpMethod = "GET"
            
        case .POST:
            guard let url = components.url else { throw URLError(.badURL) }
            request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: payload.param, options: [])
            
        default:
            throw NSError(domain: "Unsupported request type", code: -1)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(Response<T>.self, from: data)
        return decoded
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

