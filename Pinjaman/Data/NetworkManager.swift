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
    
    // MARK: - UPLOAD请求
    func upload<T: Codable>(_ payload: any Payloadprotocol, fileData: Data, fileName: String, mimeType: String) async throws -> PJResponse<T> {
        guard let url = buildURL(for: payload) else {
            throw URLError(.badURL)
        }
        print("upload url = \(url)")
        print("upload param = \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let body = try createMultipartBody(parameters: payload.param, boundary: boundary, data: fileData, mimeType: mimeType, filename: fileName)
        request.httpBody = body
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print("Result = \(try JSONSerialization.jsonObject(with: data, options: []))")
            let decoded = try JSONDecoder().decode(PJResponse<T>.self, from: data)
            return decoded
        } catch {
            print(error)
            ToastManager.shared.show(error.localizedDescription)
            throw error
        }
    }

    // MARK: - 通用请求
    func request<T: Codable>(_ payload: any Payloadprotocol) async throws -> PJResponse<T> {
        guard let url = buildURL(for: payload) else {
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
            print("URL == \(finalURL.absoluteString)")

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
            ToastManager.shared.show("Unsupported request type")
            throw NSError(domain: "Unsupported request type", code: -1)
        }

        do {
            // Use URLSession.shared.data(for: request) to handle all request types
            let (data, response) = try await URLSession.shared.data(for: request)
            print(try JSONSerialization.jsonObject(with: data, options: []))
            
            // Validate the HTTP response status code, similar to the provided get/post methods
            guard let httpResponse = response as? HTTPURLResponse,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  statusCode == 200
            else {
                let error = NSError(domain: "Request failed", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: nil)
                ToastManager.shared.show(error.localizedDescription)
                throw error
            }
            
            if let param = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let goss = param["goss"] as? Int, goss != 0,
                let diarmuid = param["diarmuid"] as? String {
                switch goss {
                case -2: // logout
                    ToastManager.shared.show(diarmuid)
                    throw NSError(domain: "logout", code: goss)
                default:
                    ToastManager.shared.show(diarmuid)
                    throw NSError(domain: "logout", code: goss)
                }
            }
            
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
            print("====================================================")
            print(request.url?.absoluteString)
            print(error.localizedDescription)
            ToastManager.shared.show(error.localizedDescription)
            print("====================================================")
            throw error
        }
    }
    
    // MARK: - 辅助方法：生成multipart body
    private func createMultipartBody(parameters: [String: Any],
                                     boundary: String,
                                     data: Data,
                                     mimeType: String,
                                     filename: String) throws -> Data {
        let body = NSMutableData()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
            
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"tribunitial\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body as Data
    }
    
    /// 返回拼接好的 URL（GET 使用）
     func buildURL(for payload: Payloadprotocol) -> URL? {
        let url = (baseURL + payload.requestPath).addMadatoryParameters()
        return URL(string: url)
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

