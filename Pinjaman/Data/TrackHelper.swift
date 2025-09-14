//
//  TrackHelper.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/14.
//

import Foundation
import UIKit
import Network
import SystemConfiguration
import CoreTelephony
import AdSupport
import AppTrackingTransparency
import SystemConfiguration.CaptiveNetwork
import CoreLocation

enum TrackType: String {
    /// 注册
    case register = "1"
    /// 正面
    case front = "2"
    /// 自拍
    case selfie = "3"
    /// 个人信息
    case personalInfo = "4"
    /// 工作信息
    case jobInfo = "5"
    /// 联系人
    case contact = "6"
    /// 绑卡
    case bindCard = "7"
    /// 开始审贷
    case startLoanReview = "8"
    /// 结束审贷
    case endLoanReview = "9"
}

class TrackHelper {
    static let share = TrackHelper()
    private init(){}
    // TrackType.Rawvalud: timeStamp
    var beginTimeStamg: [String: String] = [:]
    
    func onCatchUserTrack(type: TrackType) {
        beginTimeStamg[type.rawValue] = Date().timeIntervalSince1970.description
    }
    
    func onUploadPosition() {
        guard let locationData = AddressManager.shared.locationData as? [String: String], locationData.keys.count > 0 else {
            return
        }
        Task {
            do {
                let payload = ReportLocationPayload(param: locationData)
                let result: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payload)
            }
        }
    }
    
    func onUploadGoogleMarket() {
        Task {
            do {
                let payload = GoogleMarketReportPayload(metroptosis: IDFAManager.shared.fetchIDFV() ?? "", alemannish: IDFAManager.shared.fetchIDFA() ?? "")
                let result: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payload)
            }
        }
    }
    
    func onUploadRiskEvent(type: TrackType, orderId: String) {
        let param =
        ["fantastry": type.rawValue,
         "dodded": "ios",
         "copperbottom": IDFAManager.shared.fetchIDFV() ?? "",
         "forecomingness": IDFAManager.shared.fetchIDFV() ?? "",
         "hundredth": AddressManager.shared.currentLocation?.coordinate.longitude ?? "",
         "spotsman":  AddressManager.shared.currentLocation?.coordinate.latitude ?? "" ,
         "ectocinerea": beginTimeStamg[type.rawValue] ?? "",
         "upstirred": "\(Date().timeIntervalSince1970)",
         "dyotheletical":  orderId] as [String : Any]                 
        Task {
            do {
                let payload = ReportRiskControlEventPayload(param: param)
                let result: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payload)
            }
        }
    }
    
    func onUploadContact(jsonString: String) {
        Task {
            do {
                let payload = UploadContactsPayload(unskepticalness: jsonString)
                let result: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payload)
            }
        }
    }
    
    func onUploadDeviceInfo() {
        Task {
            do {
                let param = await UIDevice.getDeviceInfo()
                let payload = ReportDeviceInfoPayload(unskepticalness: param)
                let result: PJResponse<EmptyModel> = try await NetworkManager.shared.request(payload)
            }
        }
    }
}


