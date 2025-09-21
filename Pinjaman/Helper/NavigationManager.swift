//
//  NavigationManager.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/14.
//

import Foundation
import SwiftUI

///// 定义应用程序内部所有页面的枚举
///// 使用字符串作为原始值，以匹配后端的路由名称
//enum Destination: String {
//    case photo = "Algeciras"
//    case userInfo = "saxpence"
//    case work = "bordarius"
//    case contact = "unpilled"
//    case bank = "synastry"
//    case order = "pa://ks.mo.ent/contrude"
//    case certify = "pa://ks.mo.ent/aloetic"
//    case login = "pa://ks.mo.ent/Frametown"
//    case homePage = "pa://ks.mo.ent/Italophile"
//    case setting = "pa://ks.mo.ent/Berkly"
//    case cancellation = "pa://ks.mo.ent/cancellation"
//}
//
///// 一个用于封装页面跳转逻辑的管理器
//class NavigationManager {
//
//    /// 根据给定的目标字符串和产品 ID 返回相应的 SwiftUI 视图。
//    /// 此方法将复杂的页面跳转逻辑集中管理，确保类型安全。
//    ///
//    /// - Parameters:
//    ///   - destination: 目标视图的标识符字符串，可以是内部路由或外部 URL。
//    ///   - prodId: 与视图关联的产品 ID。
//    /// - Returns: 一个 `some View` 类型的视图，代表要导航到的目的地。
//    @ViewBuilder
//    static func navigateTo(for destination: String, prodId: String) -> some View {
//        switch destination {
//        case Destination.photo.rawValue:
//            IdentifyView(prodId: prodId)
//            
//        case Destination.userInfo.rawValue:
//            UserInfomationView(prodId: prodId)
//            
//        case Destination.work.rawValue:
//            WorkAuthenticationVieW(prodId: prodId)
//            
//        case Destination.contact.rawValue:
//            ContactsView(prodId: prodId)
//            
//        case Destination.bank.rawValue:
//            PropertyView(prodId: prodId)
//        
//        case Destination.certify.rawValue:
//            CertifyView(prodId: prodId)
//        
//        case Destination.setting.rawValue:
//            SetUpView()
//        
//        case Destination.cancellation.rawValue:
//            CancellationView()
//            
//        default:
//            // 处理所有未列举的字符串，包括外部 URL
//            if destination.contains("http") {
//                PKWebView(htmlLink: destination, shouldGoBackToHome: false)
//            } else {
//                Text("未知路由：\(destination)")
//            }
//        }
//    }
//}
