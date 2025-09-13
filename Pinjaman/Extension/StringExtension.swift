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
        params["trophospongial"] = "idfa"
        
        if let filesniff = String(AppSettings.shared.configModal?.filesniff ?? 1) as? String {
            params["filesniff"] = filesniff
        }
        return params
    }       
    
}
