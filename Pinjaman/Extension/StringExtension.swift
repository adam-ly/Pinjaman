//
//  StringExtension.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/10.
//

import Foundation
import UIKit

extension String {
    
    func addMadatoryParameters(_ parameters: [String: Any] = additionalParameters()) -> String {
        guard !parameters.isEmpty else {
            return self
        }
        
        let separator = contains("?") ? "&" : "?"
        let parameterStrings = parameters.map { key, value in
            return "\(key)=\((value as AnyObject).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value)"
        }
        let parameterString = parameterStrings.joined(separator: "&")
        return self + separator + parameterString
    }
    
    /// 返回公共参数
    static func additionalParameters() -> [String: String] {
        var params: [String: String] = [
            "ungloriousness": UIDevice.appVersion(),
            "subhatchery": UIDevice.deviceModel(),
            "defacing": UIDevice.deviceId(),
            "spondylopathy": UIDevice.osVersion()
        ]
                    
        if let sessionId = AppSettings.shared.loginModel?.moyle {
            params["moyle"] = sessionId
        }

//TODO: - handle idfa
        params["trophospongial"] = IDFAManager.shared.fetchIDFA()
        
        if let filesniff = String(AppSettings.shared.configModal?.filesniff ?? 1) as? String {
            params["filesniff"] = filesniff
        }
        return params
    }       
    
}

extension String {
    /// 从 URL 字符串中提取最后的路径组件。
    /// 此方法能够处理不标准的 URL 方案（如 `pa://`）并忽略查询参数。
    /// - Returns: 最后一个路径组件的字符串，如果无法解析则返回 `nil`。
    /// link + param
    func getDestination() -> (String?,String?) {
        if self.contains("http") { // is url
            return (self.addMadatoryParameters(),nil)
        } else { // is pages.
            let arr = ["pa://ks.mo.ent/Berkly",
                       "pa://ks.mo.ent/Italophile",
                       "pa://ks.mo.ent/Frametown",
                       "pa://ks.mo.ent/contrude",
                       "pa://ks.mo.ent/aloetic"]
            if let find = arr.first(where: { self.contains($0) }) {
                return (find, self.components(separatedBy: "=").last)
            }
            return (self, nil)
        }
    }
    
    func getDestinationPath(parameter: String) -> NavigationPathElement {
        var destination: Destination
        let arr = ["pa://ks.mo.ent/Berkly",
                   "pa://ks.mo.ent/Italophile",
                   "pa://ks.mo.ent/Frametown",
                   "pa://ks.mo.ent/contrude",
                   "pa://ks.mo.ent/aloetic"]
        var param = parameter
        if self.contains("http") {
            destination = .other(self.addMadatoryParameters())
        } else if let find = arr.first(where: { self.contains($0) }) {
            destination = Destination(rawValue: find)
            param = self.components(separatedBy: "=").last ?? ""
        } else {
            destination = Destination(rawValue: self)
        }
                                
        // 2. Create and return the NavigationPathElement.
        return NavigationPathElement(destination: destination, parameter: param)
    }
}

extension String  {
    var masked3to7: String {
        guard count >= 3 else { return self }
        let start = index(self.startIndex, offsetBy: 2)
        let end   = index(self.startIndex, offsetBy: min(7, count))
        let mask  = String(repeating: "*", count: distance(from: start, to: end))
        return replacingCharacters(in: start..<end, with: mask)
    }
}
