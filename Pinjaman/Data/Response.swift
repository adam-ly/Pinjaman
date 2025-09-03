//
//  Response.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/31.
//

import Foundation

enum ResponseCode: Int, Codable {
    case success = 0
    case unlogin = -2
    case none
    
    init(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .success
        case -2:
            self = .unlogin
        default:
            self = .none
        }
    }
}

struct Response<T: Codable>: Codable {
    var goss: ResponseCode
    var diarmuid: String
    var unskepticalness: T
}

//MARK: - 空返回
struct EmptyModel: Codable {
    
}

//MARK: - 登录初始化 (每一次启动调用)
struct ConfigModel: Codable {
    var filesniff: Bool?
    var undefense: Bool?
    var overplace: FBConfigModel?
}

// FB 配置
struct FBConfigModel: Codable {
    var id: String?
    var name: String?
    var value: String?
    // 可以根据实际需要添加更多字段
}

//MARK: - 验证码登陆/注册
struct LoginModel: Codable {
    var counterretaliation: String? // 登录手机号，用于个人中心展示
    var gratulated: String?         // 真实姓名，UI图上没有可忽略
    var moyle: String?              // 标识符
}

//MARK: - 个人信息
struct PersonModel: Codable {
    // 用户状态
    let thortveitite: String?
    // 真实姓名
    let contendent: String?
    // 身份证号码
    let papyrologist: String?
    // 出生年月
    let sneds: String?
    // 账号
    let proselytist: String?
    // 银行卡号
    let opaquest: String?
    // 身份证正面照片
    let constructorship: String?
    // 人脸照片
    let southernwood: String?
}

// MARK: - 首页数据模型
struct HomeModel: Codable {
    let poikilitic: Poikilitic? // 所有H5相关链接
    let neurocentrum: Neurocentrum? // 借款协议
    let toothbrush: [String]? // 跑马灯
    let undulant: Int? // 是否完成认证
    let hoised: Int? // 是否展示还款提醒  1-是 0-否
    let chamos: String? // 还款提醒弹窗信息
    let mercantilism: [Mercantilism]? // 首页元素
}

// H5相关链接
struct Poikilitic: Codable {
    let bartholomite: String? // 客服小手机logo
    let sordidnesses: String? // 客服页面H5链接
    let emeers: String? // 关于我们页面H5链接
    let manglers: String? // 反馈页面H5链接
}

//协议
struct Neurocentrum: Codable {
    let daceloninae: String? // 协议展示文案
    let heterogenean: String? // 协议H5链接
}

// 首页元素
struct Mercantilism: Codable {
    let oxystome: String? // 广告图 / LARGE_CARD / SMALL_CARD / PRODUCT_LIST
    let aladfar: [Aladfar]? // 合并后的统一结构
}

// aladfar
struct Aladfar: Codable {
    // --- 通用字段 ---
    let nectarium: String? // 跳转url
    let towaoc: String? // 图片url
    let flippers: String? // 不确定用途
    let christhood: Int? // 产品id
    let daceloninae: String? // 协议展示文案 / 其他文案
    
    // --- 产品相关 ---
    let serphoid: Int? // 产品id
    let multilayer: String? // 产品名称
    let underspore: String? // 产品logo
    let bullrushes: String? // 申请按钮文案
    let plumbog: String? // 额度文案
    let pithecanthropoid: String? // 产品额度
    let rhadamanthine: String? // 产品期限文案
    let dirdums: String? // 产品期限
    let marocain: String? // 产品利率文案
    let cyclecar: String? // 产品利率
    let infantries: String? // 产品利率（另一种key）
    let ergothioneine: String? // 期限logo
    let atoners: String? // 利率logo
    let germann: String? // 产品描述
    let reconsolidate: [String]? // 产品卖点数组
    let acromiodeltoid: String? // 产品标签颜色
    let declares: Int? // 不确定用途
    let mygale: String? // 不确定用途
    let orthotolidin: String? // 不确定用途
    let subband: Int? // 产品类型 1 API 2 H5
    let urethroscopy: String? // 不确定用途
    let morphonomy: Int? // 今天是否点击 0否 1是
    let setover: [String]? // 不确定用途
    let peerages: String? // 不确定用途
    let recompiled: [String]? // 不确定用途
    let lagunas: Int? // 不确定用途
    let nonadmission: String? // 最大额度
}

// MARK: - 个人中心数据模型
struct PersonCenterModel: Codable {
    let mercantilism: [MenuItem]?   // 菜单数据
    let phytocoenoses: OrderCount?  // 订单数量统计
    let manlihood: Int?             // 是否完成认证 1是 0否
    let roshelle: Roshelle?         // 注销文案
}

// 菜单项
struct MenuItem: Codable {
    let daceloninae: String? // 标题
    let nectarium: String?   // 跳转地址 http 开头时拼接公参 h5
    let poikilitic: String?  // 图标地址
}

//订单数量统计
struct OrderCount: Codable {
    let fairyfolk: Int?     // 未完成
    let contractors: Int?   // 已完成
    let abseil: Int?        // 已取消
}

//注销文案
struct Roshelle: Codable {
    let daceloninae: String?       // 标题
    let anticreationist: String?   // 注销说明文案
    let expatriated: String?       // 确认提示
}


// MARK: - 准入接口
struct ProductRequestModel: Codable {
    let overprize: Int?       // 成功
    let nectarium: String?    // 跳转地址 http 开头时拼接公参 h5
    let filesniff: Int?       // 状态码（示例：2）
    let oxystome: Int?        // 标志位（示例：1）
    let peculated: String?    // 返回消息（示例："成功"）
}

import Foundation

// MARK: - 产品详情模型
struct ProductDetailModel: Codable {
    let overprize: Int?                  // 状态码 (示例：200)
    let demotika: ProductInfo?           // 产品信息
    let chummies: Int?                   // 状态位 (示例：1)
    let popular: String?                 // 温馨提示文案
    let lucubrator: UserInfo?            // 用户信息
    let ridding: [AuthItem]?             // 认证项
    let noneuphoniousness: NextStep?     // 下一步认证项
    let neurocentrum: Neurocentrum?         // 借款协议
}

// 产品信息
struct ProductInfo: Codable {
    let serphoid: String?        // 产品id
    let multilayer: String?      // 产品名称
    let underspore: String?      // 产品LOGO
    let vb: String?              // 额度描述
    let pityroid: String?        // 额度 (下单必传)
    let intercivilization: String? // 期限描述
    let duramens: String?        // 借款期限 (下单必传)
    let spliffs: Int?            // 借款期限类型 (下单必传)
    let bullrushes: String?      // 底部按钮文案
    let charca: String?          // 订单号 (下单/埋点必传)
    let toxosozin: String?       // 订单号 (同上)
    let peritonealize: FeeInfo?  // 额度和费用信息
    let cones: [String]?         // 额度范围
    let mindedness: [Int]?       // 借款期限范围
    let shulem: Int?             // 订单id
    let expatriated: String?     // html 描述
    let barnlike: Int?
    let nectarium: String?       // 跳转地址
    let radiobroadcasted: ContactInfo? // 联系方式
    let habituation: String?     // 投诉页面链接
}

// 费用信息
struct FeeInfo: Codable {
    let outmode: FeeDetail?      // 期限信息
    let solventless: FeeDetail?  // 利率信息
}

struct FeeDetail: Codable {
    let daceloninae: String?   // 描述
    let intrastate: String?    // 值 (期限/利率)
}

// 联系方式
struct ContactInfo: Codable {
    let dynastes: String?       // 联系电话
}

// 用户信息
struct UserInfo: Codable {
    let sensationally: String?  // 手机号
    let papyrologist: String?   // 身份证号
    let contendent: String?     // 姓名
}

// 认证项
struct AuthItem: Codable {
    let daceloninae: String?    // 标题
    let trilemma: String?       // logo
    let thortveitite: Int?      // 是否已完成
    let unreproachable: String? // 未完成时描述
    let oversceptical: String?  // 认证类型
    let oxystome: Int?
    let nectarium: String?
    let uncurtailed: String?
    let spitpoison: Int?
    let prateful: Int?
    let festoonery: Int?
    let gastroenteritic: String?
}

// 下一步认证
struct NextStep: Codable {
    let oversceptical: String?  // 认证类型
    let nectarium: String?
    let oxystome: Int?
    let daceloninae: String?    // 标题
}

// MARK: - 获取用户身份信息（第一项）
struct UserIdentityModel: Codable {
    let aladfar: IdentityInfo?   // 身份证 & 人脸自拍信息
    let diarmuid: String?        // 其他扩展字段
}

// 身份信息详情
struct IdentityInfo: Codable {
    let perpetuating: Int?       // 状态位（1 表示需要上传 / 已认证状态）
    let sofars: String?          // 证件文案（如 "KTP bagian depan"）
    let caliology: String?       // 证件地址（有值代表证件已上传完成）
    let polymyarii: String?      // 人脸自拍文案（如 "Pengenalan Wajah"）
    let circumvents: String?     // 人脸照片地址（有值代表自拍已上传完成）
}

// MARK: - 用户个人信息模型
struct UserIndivisualModel: Codable {
    let spot: [SpotItem]?   // 个人信息项数组
}

// 单个信息项
struct SpotItem: Codable {
    let serphoid: String?       // 字段顺序 ID
    let daceloninae: String?    // 标题（如 "婚姻状况"）
    let unreproachable: String? // 占位提示文案
    let goss: String?           // 提交时的参数 key
    let machiavellian: String?  // 字段类型（如 "want"）
    let vermeer: [VermeerItem]? // 可选值数组
    let prateful: Int?          // 默认值
    let thortveitite: Int?      // 是否必填（1=必填，0=非必填）
    let uncurtailed: String?    // 认证状态文案（如 "已认证"）
    let outfieldsman: Bool?     // 是否已认证
    let dynastes: String?       // 当前选择值（如 "Belum Kawin"）
    let ootid: Int?             // 选中索引
    let obtected: Int?          // inputType=1 使用数字键盘
}

// 下拉选项
struct VermeerItem: Codable {
    let contendent: String? // 选项文案（如 "Belum Kawin"）
    let oxystome: Int?      // 选项值（如 1/2）
}


// MARK: - 用户工作信息模型
struct UserWorkModel: Codable {
    let spot: [WorkSpotItem]?   // 工作信息项数组
}

// 单个工作信息项
struct WorkSpotItem: Codable {
    let serphoid: String?       // 字段顺序 ID
    let daceloninae: String?    // 标题（如 "公司名称"、"工作城市"）
    let unreproachable: String? // 占位提示文案
    let goss: String?           // 提交时的参数 key（如 company_name, work_city）
    let machiavellian: String?  // 字段类型（如 "phone", "first"...）
    let vermeer: [VermeerItem]? // 可选值数组
    let prateful: Int?          // 默认值
    let thortveitite: Int?      // 是否必填（1=必填，0=非必填）
    let uncurtailed: String?    // 认证状态文案（如 "已认证"）
    let outfieldsman: Bool?     // 是否已认证
    let dynastes: String?       // 当前填写/选择值
    let ootid: Int?             // 选中索引
}


// MARK: - 用户银行卡信息模型
struct UserCardModel: Codable {
    let spot: [CardSpotItem]?   // 银行卡信息项数组
}

// 单个银行卡信息项
struct CardSpotItem: Codable {
    let daceloninae: String?    // 字段标题，例如 "Nama Bank"
    let goss: String?           // 提交时的参数 key，例如 "bankCode"
    let unreproachable: String? // 占位提示文案，例如 "Silakan pilih bank"
    let machiavellian: String?  // 字段类型（如 "want"）
    let vermeer: [VermeerItem]? // 银行选项数组
    let prateful: Int?          // 默认值
    let thortveitite: Int?      // 是否必填（1=必填，0=非必填）
    let uncurtailed: String?    // 填写状态，例如 "已填写"
    let dynastes: String?       // 当前填写/选择值
    let unpreferable: String?   // 可能是显示用的别名（例如 "Bank BTPN"）
    let ootid: Int?             // 选中索引
}

// MARK: - 用户紧急联系人模型
struct UserContactModel: Codable {
    let unthrobbing: [UserContactItem]?   // 紧急联系人数组
}

// 单个紧急联系人
struct UserContactItem: Codable {
    let singularly: String?      // 已填写状态 (如 "1")
    let contendent: String?      // 姓名
    let marrowbone: String?      // 手机号
    let vermeer: [VermeerItem]? // 关系选项数组
    let daceloninae: String?     // 字段标题 (如 "Contacto de emergencia 1")
    let decently: String?        // 关系文案
    let stridlins: String?       // 关系占位文案 (如 "Por favor seleccione una relación")
    let umlauts: String?         // 手机号文案
    let mesothelium: String?     // 手机号占位文案 (如 "Por favor seleccione el número de teléfono móvil")
}
