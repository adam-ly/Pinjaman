//
//  Payload.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/31.
//

import Foundation

enum PayloadType {
    case GET
    case POST
    case UPLOAD
}

protocol Payloadprotocol {
    var payloadType: PayloadType { get }
    var param: [String: Any] { get }
    var requestPath: String { get }
}

/// 登录初始化
struct LoginInitializationPayload: Payloadprotocol {
    var payloadType: PayloadType { .GET }
    var requestPath: String { "/Chukchis/bilirubinic" }
    
    // 请求参数
    let bilirubinic: String
    let chartographical: Int
    let puboiliac: Int
    
    var param: [String: Any] {
        return [
            "bilirubinic": bilirubinic,
            "chartographical": String(chartographical),
            "puboiliac": String(puboiliac)
        ]
    }
}

/// 用户登录注册时获取短信验证码
struct GetSMSCodePayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/chartographical" }
    
    // 请求参数
    let sensationally: String
    
    var param: [String: Any] {
        return [
            "sensationally": sensationally
        ]
    }
}

/// 用户登录注册时获取语音验证码
struct GetVoiceCodePayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/puboiliac" }
    
    // 请求参数
    let sensationally: String
    
    var param: [String: Any] {
        return [
            "sensationally": sensationally
        ]
    }
}

/// 用户登陆或者注册
struct CodeLoginOrRegisterPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/goss" }
    
    // 请求参数
    let counterretaliation: String
    let underhangman: String
    
    var param: [String: Any] {
        return [
            "counterretaliation": counterretaliation,
            "underhangman": underhangman
        ]
    }
}

/// 个人信息
struct GetPersonalInformationPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/mercantilism" }
    
    // There are no request parameters, so the dictionary is empty.
    var param: [String: Any] {
        return [:]
    }
}

/// 用户登录退出
struct LogoutPayload: Payloadprotocol {
    var payloadType: PayloadType { .GET }
    var requestPath: String { "/Chukchis/diarmuid" }

    // There are no request parameters, so the dictionary is empty.
    var param: [String: Any] {
        return [:]
    }
}

/// 用户注销账号，以后不可以再登录
struct DeactivateAccountPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/neurocentrum" }

    // There are no request parameters, so the dictionary is empty.
    var param: [String: Any] {
        return [:]
    }
}

/// APP首页 小卡位账号：2312312311
struct AppHomePagePayload: Payloadprotocol {
    var payloadType: PayloadType { .GET }
    var requestPath: String { "/Chukchis/unskepticalness" }

    // There are no request parameters, so the dictionary is empty.
    var param: [String: Any] {
        return [:]
    }
}

/// 个人中心菜单
struct AppUserCenterPayload: Payloadprotocol {
    var payloadType: PayloadType { .GET }
    var requestPath: String { "/Chukchis/proselytist" }
    var param: [String: Any] {
        return [:]
    }
}

/// 城市选择器
struct CityListPayload: Payloadprotocol {
    var payloadType: PayloadType { .GET }
    var requestPath: String { "/Chukchis/southernwood" }

    // There are no request parameters, so the dictionary is empty.
    var param: [String: Any] {
        return [:]
    }
}

/// 点击申请产品
struct ProductAdmissionPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/filesniff" }
    
    // 请求参数
    let christhood: String
    
    var param: [String: Any] {
        return [
            "christhood": christhood
        ]
    }
}

/// 产品详情
struct ProductDetailsPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/undefense" }
    
    // 请求参数
    let christhood: String
    
    var param: [String: Any] {
        return [
            "christhood": christhood
        ]
    }
}

/// 获取用户身份证/活体信息（第一项）
struct GetUserIdentityInfoPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/overplace" }
    
    // 请求参数
    let christhood: String
    
    var param: [String: Any] {
        return [
            "christhood": christhood
        ]
    }
}

/// 接口上传(face,身份证正面,反面)（第一项）
struct UploadIdentityInfoPayload: Payloadprotocol {
    var payloadType: PayloadType { .UPLOAD } // Use .UPLOAD for form data
    var requestPath: String { "/Chukchis/unshakenness" }
    
    // NOTE: This protocol is for URL-encoded or JSON parameters.
    // Since this is a form data upload, you'll need to handle the `tribunitial` (file)
    // and `param` (strings) separately in your networking layer.
    
    // Request parameters
    let oxystome: String
    let redowl: String
    
    var param: [String: Any] {
        return [
            "oxystome": oxystome,
            "redowl": redowl
        ]
    }
}

/// 保存用户身份证信息（第一项）
struct SaveIdentityInfoPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/detach" }

    // 请求参数
//    let geanticlinal: String
//    let bartering: String
//    let contendent: String
//    let christhood: String
    
    var param: [String: Any]
//    var param: [String: Any] {
//        return [
//            "geanticlinal": geanticlinal,
//            "bartering": bartering,
//            "contendent": contendent,
//            "christhood": christhood
//        ]
//    }
}

/// 获取用户信息（第二项）
struct GetUserInfoSecondItemPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/plastique" }
    
    // 请求参数
    let christhood: String
    
    var param: [String: Any] {
        return [
            "christhood": christhood
        ]
    }
}

/// 保存用户信息（第二项）
struct SaveUserInfoSecondItemPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/noncodified" }

    var param: [String: Any]
}

/// 获取工作信息（第三项）
struct GetWorkInfoPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/sensationally" }

    // 请求参数
    let christhood: String

    var param: [String: Any] {
        return [
            "christhood": christhood
        ]
    }
}

/// 保存工作信息（第三项）
struct SaveWorkInfoPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/counterretaliation" }

    var param: [String: Any]
}

/// 获取联系人信息（第四项）
struct GetContactInfoPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/underhangman" }

    // 请求参数
    let christhood: String

    var param: [String: Any] {
        return [
            "christhood": christhood
        ]
    }
}

/// 保存联系人信息（第四项）
struct SaveContactInfoPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/gratulated" }

    // 请求参数
    let christhood: String
    let unskepticalness: String
    
    var param: [String: Any] {
        return [
            "christhood": christhood,
            // 将字符串数组转换为一个用逗号分隔的字符串，以适应 [String: String] 格式
            "unskepticalness": unskepticalness
        ]
    }
}

/// 获取绑卡信息（第五项）
struct GetBankInfoPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/overbrow" }

    // 请求参数
    let christhood: String
    
    var param: [String: Any] {
        return [
            "christhood": christhood,            
        ]
    }
}

/// 提交绑卡（第五项）
struct SubmitBankInfoPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/thortveitite" }
    
    var param: [String: Any]
}


/// 下单接口 （所有认证项已完成 点击产品详情页底部申请按钮调用）
/// 获取跳转位置
struct PlaceOrderPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/contendent" }
    
    // 请求参数
    /// 订单号
    let charca: String
    /// 金额
    let pityroid: String
    /// 借款期限
    let duramens: String
    /// 期限类型
    let spliffs: Int
    
    var param: [String: Any] {
        return [
            "charca": charca,
            "pityroid": pityroid,
            "duramens": duramens,
            "spliffs": spliffs
        ]
    }
}

/// 订单列表
struct OrderListPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/papyrologist" }
    
    // 请求参数
    /// 状态 4全部 7进行中 6待还款 5已结清
    let polianite: String
    
    var param: [String: Any] {
        return [
            "polianite": polianite
        ]
    }
}

/// 上报位置信息 每一次启动和每一次进入首页上报
struct ReportLocationPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/sordidnesses" }
    
    var param: [String: Any]
}

/// Google Market 上报
struct GoogleMarketReportPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/manglers" }
    
    // 请求参数
    /// idfv，需要存在钥匙串里，保证每次重装APP该值不会产生变化
    let metroptosis: String
    /// idfa
    let alemannish: String
    
    var param: [String: Any] {
        return [
            "metroptosis": metroptosis,  //idfv 需要存在钥匙串里，保存每次重装APP该值不会产生变化
            "alemannish": alemannish  //idfa
        ]
    }
}

/// 上报风控埋点
struct ReportRiskControlEventPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/opaquest" }
    
//    // 请求参数
//    /// 埋点类型：
//    /// 1=注册
//    /// 2=正面
//    /// 3=自拍
//    /// 4=个人信息
//    /// 5=工作信息
//    /// 6=联系人
//    /// 7=绑卡
//    /// 8=开始审贷
//    /// 9=结束审贷
//    let fantastry: String
//    
//    /// 安卓传1，iOS传2
//    let dodded: String
//    
//    /// 安卓传and_id，iOS传idfv
//    let copperbottom: String
//    
//    /// 安卓传gaid，iOS传idfa
//    let forecomingness: String
//    
//    /// 经度(保留6位小数，向下取整)
//    let hundredth: String
//    
//    /// 维度(保留6位小数，向下取整)
//    let spotsman: String
//    
//    /// 开始时间（秒级时间戳）
//    let ectocinerea: String
//    
//    /// 结束时间（秒级时间戳）
//    let upstirred: String
//    
//    /// 订单号（第8步必传）
//    let dyotheletical: String?
    
    var param: [String: Any]
//    {
//        var params: [String: String] = [
//            "fantastry": fantastry,
//            "dodded": dodded,
//            "copperbottom": copperbottom,
//            "forecomingness": forecomingness,
//            "hundredth": hundredth,
//            "spotsman": spotsman,
//            "ectocinerea": ectocinerea,
//            "upstirred": upstirred
//        ]
//        
//        // Only include the order number if it exists
//        if let dyotheletical = dyotheletical {
//            params["dyotheletical"] = dyotheletical
//        }
//        
//        return params
//    }
}

/// 设备信息上报详细信息
struct ReportDeviceInfoPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/emeers" }
    
    let unskepticalness: String
    
    var param: [String: Any] {
        return [
            "unskepticalness": unskepticalness
        ]
    }
}

/// 上报通讯录
struct UploadContactsPayload: Payloadprotocol {
    var payloadType: PayloadType { .POST }
    var requestPath: String { "/Chukchis/heterogenean" }

    // This property holds your structured contact data.
    let unskepticalness: String
    
    var param: [String: Any] {
        return [
            "unskepticalness": unskepticalness
        ]
    }
}
