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

class PJResponse<T: Codable>: Codable {
    var goss: ResponseCode
    var diarmuid: String
    var unskepticalness: T
}

//MARK: - 空返回
class EmptyModel: Codable {
    
}

//MARK: - 登录初始化 (每一次启动调用)
class ConfigModel: Codable {
    /// APP语言，1=英语，2=印尼语
    var filesniff: Int?
    /// 隐私协议地址
    let undefense: String?
    /// FB配置参数
    let overplace: Overplace?
}

/// FB配置参数
class Overplace: Codable {
    /// CFBundleURLScheme
    let unshakenness: String?
    /// FacebookAppID
    let detach: String?
    /// FacebookDisplayName
    let plastique: String?
    /// FacebookClientToke
    let noncodified: String?
}

//MARK: - 验证码登陆/注册
class LoginModel: Codable {
    var counterretaliation: String? // 登录手机号，用于个人中心展示
    var gratulated: String?         // 真实姓名，UI图上没有可忽略
    var moyle: String?              // 标识符
}

//MARK: - 个人信息
class PersonModel: Codable {
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
    let conclassorship: String?
    // 人脸照片
    let southernwood: String?
}

// MARK: - 首页数据模型
class HomeModel: Codable {
    let poikilitic: Poikilitic? // 所有H5相关链接
    let neurocentrum: Neurocentrum? // 借款协议
    let toothbrush: [String]? // 跑马灯
    let undulant: Int? // 是否完成认证
    let hoised: Int? // 是否展示还款提醒  1-是 0-否
    let chamos: String? // 还款提醒弹窗信息
    let mercantilism: [Mercantilism]? // 首页元素
    
    //产品id
    func getprdId() -> Int? {
        return getProduct()?.serphoid
    }
    
    //产品名称
    func getPrdName() -> String {
        return getProduct()?.multilayer ?? ""
    }
    
    //产品logo
    func getPrdLogo() -> String {
        return getProduct()?.underspore ?? ""
    }
    
    //申请按钮文案
    func getApplayButtonText() -> String {
        return getProduct()?.bullrushes ?? ""
    }
    
    //额度文案
    func getProdLimitContent() -> String {
        return getProduct()?.plumbog ?? ""
    }
    
    //额度
    func getProdLimitAmount() -> String {
        return getProduct()?.pithecanthropoid ?? ""
    }
    
    //产品期限文案
    func getProdExpiredContent() -> String {
        return getProduct()?.rhadamanthine ?? ""
    }
    
    //产品期限
    func getProdExpiredText() -> String {
        return getProduct()?.dirdums ?? ""
    }
    
    //产品利率文案
    func getProdinterestContent() -> String {
        return getProduct()?.marocain ?? ""
    }
    
    //产品利率
    func getProdinterestRate() -> String {
        return getProduct()?.cyclecar ?? ""
    }
    
    func getProdList() -> [Aladfar]? {
        return mercantilism?.filter({$0.oxystome == "germinancy"}).first?.aladfar
    }
    
    private func getProduct() -> Aladfar? {
        return mercantilism?.filter({$0.oxystome == "spiceable" || $0.oxystome == "occupiers"}).first?.aladfar?.first
    }
        
}

// H5相关链接
class Poikilitic: Codable {
    let bartholomite: String? // 客服小手机logo
    let sordidnesses: String? // 客服页面H5链接
    let emeers: String? // 关于我们页面H5链接
    let manglers: String? // 反馈页面H5链接
}

//协议
class Neurocentrum: Codable {
    let daceloninae: String? // 协议展示文案
    let heterogenean: String? // 协议H5链接
}

// 首页元素
class Mercantilism: Codable {
    let oxystome: String? // 广告图 / LARGE_CARD / SMALL_CARD / PRODUCT_LIST
    let aladfar: [Aladfar]? // 合并后的统一结构
}

// aladfar
class Aladfar: Codable {
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
class PersonCenterModel: Codable {
    let mercantilism: [MenuItem]?   // 菜单数据
    let phytocoenoses: OrderCount?  // 订单数量统计
    let manlihood: Int?             // 是否完成认证 1是 0否
    let roshelle: Roshelle?         // 注销文案
}

// 菜单项
class MenuItem: Codable, Identifiable {
    let daceloninae: String? // 标题
    let nectarium: String?   // 跳转地址 http 开头时拼接公参 h5
    let poikilitic: String?  // 图标地址
}

//订单数量统计
class OrderCount: Codable {
    let fairyfolk: Int?     // 未完成
    let contractors: Int?   // 已完成
    let abseil: Int?        // 已取消
}

//注销文案
class Roshelle: Codable {
    let daceloninae: String?       // 标题
    let anticreationist: String?   // 注销说明文案
    let expatriated: String?       // 确认提示
}


// MARK: - 准入接口
class ProductRequestModel: Codable {
    let overprize: Int?       // 成功
    let nectarium: String?    // 跳转地址 http 开头时拼接公参 h5
    let filesniff: Int?       // 状态码（示例：2）
    let oxystome: Int?        // 标志位（示例：1）
    let peculated: String?    // 返回消息（示例："成功"）
}

// MARK: - 产品详情模型
class ProductDetailModel: Codable {
    let overprize: Int?                  // 状态码 (示例：200)
    let demotika: ProductInfo?           // 产品信息
    let chummies: Int?                   // 状态位 (示例：1)
    let popular: String?                 // 温馨提示文案
    let lucubrator: UserInfo?            // 用户信息
    let ridding: [AuthItem]?             // 认证项
    let noneuphoniousness: NextStep?     // 下一步认证项
    let neurocentrum: Neurocentrum?         // 借款协议
    
    // 1. 定义 CodingKeys 以便手动解码
    private enum CodingKeys: String, CodingKey {
        case overprize, demotika, chummies, popular, lucubrator, ridding, noneuphoniousness, neurocentrum
    }
    
    // 2. 实现自定义的 Decodable 初始化方法
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 解码其他属性，这些属性没有问题，可以使用默认的 decodeIfPresent
        self.overprize = try container.decodeIfPresent(Int.self, forKey: .overprize)
        self.demotika = try container.decodeIfPresent(ProductInfo.self, forKey: .demotika)
        self.chummies = try container.decodeIfPresent(Int.self, forKey: .chummies)
        self.popular = try container.decodeIfPresent(String.self, forKey: .popular)
        self.lucubrator = try container.decodeIfPresent(UserInfo.self, forKey: .lucubrator)
        self.ridding = try container.decodeIfPresent([AuthItem].self, forKey: .ridding)
        self.neurocentrum = try container.decodeIfPresent(Neurocentrum.self, forKey: .neurocentrum)
        
        // 3. 处理 noneuphoniousness 属性
        // 使用 try? 尝试将它解码为 NextStep 类型
        if let nextStep = try? container.decodeIfPresent(NextStep.self, forKey: .noneuphoniousness) {
            self.noneuphoniousness = nextStep
        } else {
            self.noneuphoniousness = nil
        }
    }
}

// 产品信息
class ProductInfo: Codable {
    let serphoid: String?        // 产品id
    let multilayer: String?      // 产品名称
    let underspore: String?      // 产品LOGO
    let vb: String?              // 额度描述
    @LossyString var pityroid: String? // 额度 (下单必传)
    let intercivilization: String? // 期限描述
    @LossyString var duramens: String? // 借款期限 (下单必传)
    let spliffs: Int?            // 借款期限类型 (下单必传)
    let bullrushes: String?      // 底部按钮文案
    let charca: String?          // 订单号 (下单/埋点必传)
    let toxosozin: String?       // 订单号 (同上)
    let peritonealize: FeeInfo?  // 额度和费用信息
    let cones: [String]?         // 额度范围
    let mindedness: [LossyString]?       // 借款期限范围
    let shulem: Int?             // 订单id
    let expatriated: String?     // html 描述
    let barnlike: Int?
    let nectarium: String?       // 跳转地址
    let radiobroadcasted: ContactInfo? // 联系方式
    let habituation: String?     // 投诉页面链接
}

// 费用信息
class FeeInfo: Codable {
    let outmode: FeeDetail?      // 期限信息
    let solventless: FeeDetail?  // 利率信息
}

class FeeDetail: Codable {
    let daceloninae: String?   // 描述
    let intrastate: String?    // 值 (期限/利率)
}

// 联系方式
class ContactInfo: Codable {
    let dynastes: String?       // 联系电话
}

// 用户信息
class UserInfo: Codable {
    let sensationally: String?  // 手机号
    let papyrologist: String?   // 身份证号
    let contendent: String?     // 姓名
}

// 认证项
class AuthItem: Codable, Identifiable {
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
    
    var id: String {
        // 使用可选链和默认值来确保不会崩溃
        let daceloninaeString = daceloninae ?? ""
        let thortveititeString = thortveitite.map { String($0) } ?? ""        
        return daceloninaeString + "-" + thortveititeString
    }
}

// 下一步认证
class NextStep: Codable {
    let oversceptical: String?  // 认证类型
    let nectarium: String?
    let oxystome: Int?
    let daceloninae: String?    // 标题
}

// MARK: - 获取用户身份信息（第一项）
class UserIdentityModel: Codable {
    let aladfar: IdentityInfo?   // 身份证 & 人脸自拍信息
    let diarmuid: String?        // 其他扩展字段
}

// 身份信息详情
class IdentityInfo: Codable {
    let perpetuating: Int?       // 状态位（1 表示需要上传 / 已认证状态）
    let sofars: String?          // 证件文案（如 "KTP bagian depan"）
    let caliology: String?       // 证件地址（有值代表证件已上传完成）
    let polymyarii: String?      // 人脸自拍文案（如 "Pengenalan Wajah"）
    let circumvents: String?     // 人脸照片地址（有值代表自拍已上传完成）
}

/// MARK: - 身份信息項 (IdentityInfoItem)
/// 頂層數據模型，對應整個 JSON 對象
class IdentityCardResponse: Codable {
    let contendent: String?          // 姓名
    let cinctured: String?
    let bivouacked: String?
    let geanticlinal: String?
    let immethodic: String?
    let sweepwasher: String?
    let easternism: Bool?
    let pseudostigma: String?
    let concierges: String?
    let affectlessness: String?
    let uncranked: String?           // 彈窗頂部文案
    @LossyString var befitted: String? // 正確使用 IntOrString 屬性包裝器
    let unexcorticated: [IdentityInfoItem]? // 證件信息列表
    
    // 自定义编码键，确保键名正确
    private enum CodingKeys: String, CodingKey {
        case contendent, cinctured, bivouacked, geanticlinal, immethodic, sweepwasher, easternism, pseudostigma, concierges, affectlessness, uncranked, befitted, unexcorticated
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 使用 decodeIfPresent() 来安全地处理可能缺失的键
        contendent = try container.decodeIfPresent(String.self, forKey: .contendent)
        cinctured = try container.decodeIfPresent(String.self, forKey: .cinctured)
        bivouacked = try container.decodeIfPresent(String.self, forKey: .bivouacked)
        geanticlinal = try container.decodeIfPresent(String.self, forKey: .geanticlinal)
        immethodic = try container.decodeIfPresent(String.self, forKey: .immethodic)
        sweepwasher = try container.decodeIfPresent(String.self, forKey: .sweepwasher)
        easternism = try container.decodeIfPresent(Bool.self, forKey: .easternism)
        pseudostigma = try container.decodeIfPresent(String.self, forKey: .pseudostigma)
        concierges = try container.decodeIfPresent(String.self, forKey: .concierges)
        affectlessness = try container.decodeIfPresent(String.self, forKey: .affectlessness)
        uncranked = try container.decodeIfPresent(String.self, forKey: .uncranked)
        unexcorticated = try container.decodeIfPresent([IdentityInfoItem].self, forKey: .unexcorticated)
        
        // 特殊处理 befitted 属性，使其兼容 Int 和 String 类型
        if let intValue = try? container.decodeIfPresent(Int.self, forKey: .befitted) {
            self.befitted = String(intValue)
        } else {
            self.befitted = try? container.decodeIfPresent(String.self, forKey: .befitted)
        }
    }
}

/// 對應 JSON 數據中 unexcorticated 陣列的每個元素
class IdentityInfoItem: ObservableObject, Codable, Identifiable {
    let id = UUID() // 為了遵循 Identifiable，我們加上一個唯一的 ID
    
    let samplings: String? // 該信息的名稱，例如 "KTP Nama"
    
    @Published var estaminets: String = ""
    
    let goss: String? // 保存時需要傳入的參數 key
    
    // MARK: - Codable 相關
    // 因為使用了 @Published，需要手動實現 Codable 協議
    private enum CodingKeys: String, CodingKey {
        case samplings, estaminets, goss
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        samplings = try container.decodeIfPresent(String.self, forKey: .samplings)
        estaminets = try container.decodeIfPresent(String.self, forKey: .estaminets) ?? ""
        goss = try container.decodeIfPresent(String.self, forKey: .goss)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(samplings, forKey: .samplings)
        try container.encodeIfPresent(estaminets, forKey: .estaminets)
        try container.encodeIfPresent(goss, forKey: .goss)
    }
    
}

// MARK: - 用户个人信息模型
class UserIndivisualModel: Codable, Identifiable {
    let spot: [SpotItem]?   // 个人信息项数组
}

// 单个信息项

class SpotItem: Codable, Identifiable, Hashable {
    
    static func == (lhs: SpotItem, rhs: SpotItem) -> Bool {
        return lhs.goss == rhs.goss &&
               lhs.oxystome == rhs.oxystome &&
               lhs.dynastes == rhs.dynastes
    }
    
    // 实现 Hashable 协议的 hash 方法
    func hash(into hasher: inout Hasher) {
        // 结合 id、contendent 和 oxystome 进行哈希计算
        hasher.combine(goss)
        hasher.combine(oxystome)
        hasher.combine(dynastes)
    }
    
    @LossyString var serphoid: String?       // 字段顺序 ID
    let daceloninae: String?    // 标题（如 "婚姻状况"）
    let unreproachable: String? // 占位提示文案
    let goss: String?           // 提交时的参数 key
    let machiavellian: String?  // 字段类型（如 "want"）
    let vermeer: [VermeerItem]? // 可选值数组
    let prateful: Int?          // 默认值
    let thortveitite: Int?      // 是否必填（1=必填，0=非必填）
    let uncurtailed: String?    // 认证状态文案（如 "已认证"）
    let outfieldsman: Bool?     // 是否已认证
    @LossyString var oxystome: String?   //回显值key
    var dynastes: String = "" // 当前选择值（如 "Belum Kawin"）
    let ootid: Int?             // 选中索引
    let obtected: Int?          // inputType=1 使用数字键盘
    let unpreferable: String?   // 银行卡内容
    
    // 1. 定义 CodingKeys，包含所有需要手动解码的键
    private enum CodingKeys: String, CodingKey {
        case serphoid
        case daceloninae
        case unreproachable
        case goss
        case machiavellian
        case vermeer
        case prateful
        case thortveitite
        case uncurtailed
        case outfieldsman
        case oxystome
        case dynastes
        case ootid
        case obtected
        case unpreferable
    }
    
    // 2. 手动实现 Decodable 初始化方法
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 使用 try? container.decodeIfPresent 来安全地解码。
        // 如果键不存在，它会返回 nil，而不是抛出 keyNotFound 错误。
        self._serphoid = try container.decodeIfPresent(LossyString.self, forKey: .serphoid) ?? LossyString(wrappedValue: nil)
        self.daceloninae = try container.decodeIfPresent(String.self, forKey: .daceloninae)
        self.unreproachable = try container.decodeIfPresent(String.self, forKey: .unreproachable)
        self.goss = try container.decodeIfPresent(String.self, forKey: .goss)
        self.machiavellian = try container.decodeIfPresent(String.self, forKey: .machiavellian)
        self.vermeer = try container.decodeIfPresent([VermeerItem].self, forKey: .vermeer)
        self.prateful = try container.decodeIfPresent(Int.self, forKey: .prateful)
        self.thortveitite = try container.decodeIfPresent(Int.self, forKey: .thortveitite)
        self.uncurtailed = try container.decodeIfPresent(String.self, forKey: .uncurtailed)
        self.outfieldsman = try container.decodeIfPresent(Bool.self, forKey: .outfieldsman)
        self._oxystome = try container.decodeIfPresent(LossyString.self, forKey: .oxystome) ?? LossyString(wrappedValue: nil)
        self.dynastes = try container.decodeIfPresent(String.self, forKey: .dynastes) ?? ""
        self.ootid = try container.decodeIfPresent(Int.self, forKey: .ootid)
        self.obtected = try container.decodeIfPresent(Int.self, forKey: .obtected)
        self.unpreferable = try container.decodeIfPresent(String.self, forKey: .unpreferable)
    }
    
    // 3. 必须实现 Encodable 方法，以确保 Codable 协议完整
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self._serphoid, forKey: .serphoid)
        try container.encodeIfPresent(daceloninae, forKey: .daceloninae)
        try container.encodeIfPresent(unreproachable, forKey: .unreproachable)
        try container.encodeIfPresent(goss, forKey: .goss)
        try container.encodeIfPresent(machiavellian, forKey: .machiavellian)
        try container.encodeIfPresent(vermeer, forKey: .vermeer)
        try container.encodeIfPresent(prateful, forKey: .prateful)
        try container.encodeIfPresent(thortveitite, forKey: .thortveitite)
        try container.encodeIfPresent(uncurtailed, forKey: .uncurtailed)
        try container.encodeIfPresent(outfieldsman, forKey: .outfieldsman)
        try container.encode(self._oxystome, forKey: .oxystome)
        try container.encode(dynastes, forKey: .dynastes)
        try container.encodeIfPresent(ootid, forKey: .ootid)
        try container.encodeIfPresent(obtected, forKey: .obtected)
        try container.encodeIfPresent(unpreferable, forKey: .unpreferable)
    }
}

// 下拉选项
class VermeerItem: Codable, Identifiable, Hashable {
    let id = UUID() // 为 Identifiable 协议提供默认实现
    let contendent: String? // 选项文案（如 "Belum Kawin"）
    @LossyString var oxystome: String?      // 选项值（如 1/2）
    
    // 实现 Hashable 协议的 hash 方法
    func hash(into hasher: inout Hasher) {
        // 结合 id、contendent 和 oxystome 进行哈希计算
        hasher.combine(id)
        hasher.combine(contendent)
        hasher.combine(oxystome)
    }
    
    // 实现相等性判断（Hashable 要求 Equatable）
    static func == (lhs: VermeerItem, rhs: VermeerItem) -> Bool {
        return lhs.id == rhs.id &&
        lhs.contendent == rhs.contendent &&
        lhs.oxystome == rhs.oxystome
    }
}

// MARK: - 用户工作信息模型
class UserWorkModel: Codable {
    let spot: [SpotItem]?   // 工作信息项数组
}

// MARK: - 用户紧急联系人模型
class UserContactModel: Codable {
    let unthrobbing: [UserContactItem]?   // 紧急联系人数组
}

// 单个紧急联系人
class UserContactItem: Codable, Identifiable {
    var singularly: String?      // 已填写状态 (如 "1")
    var contendent: String?      // 姓名
    var marrowbone: String?      // 手机号
    let vermeer: [VermeerItem]? // 关系选项数组
    let daceloninae: String?     // 字段标题 (如 "Contacto de emergencia 1")
    let decently: String?        // 关系文案
    let stridlins: String?       // 关系占位文案 (如 "Por favor seleccione una relación")
    let umlauts: String?         // 手机号文案
    let mesothelium: String?     // 手机号占位文案 (如 "Por favor seleccione el número de teléfono móvil")
}

@propertyWrapper
struct LossyString: Codable {
    var wrappedValue: String?

    // ...你的原始实现...
    init(wrappedValue: String?) {
        self.wrappedValue = wrappedValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.singleValueContainer()
        if let stringValue = try? container?.decode(String.self) {
            wrappedValue = stringValue
        } else if let intValue = try? container?.decode(Int.self) {
            wrappedValue = String(intValue)
        } else {
            wrappedValue = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

// MARK: - 绑卡信息模型
class BankInfoModel: Codable {
    let spot: [SpotItem]?   // 工作信息项数组
}

// MARK:
class LornOrderModel: Codable {
    let nectarium: String?
}

import Foundation

// MARK: - 主数据模型
/// 订单列表数据模型
import Foundation

// MARK: - 主数据模型
import Foundation

// MARK: - 主数据模型
/// 订单列表数据模型
struct OrderListModel: Codable {
    /// 订单列表数据
    let mercantilism: [OrderModel]?
    /// 状态码，例如 1
    let moonie: Int?
}

// MARK: - 订单详情模型
/// 单个订单详情模型
struct OrderModel: Codable, Identifiable {
    /// 订单 ID
    @LossyString var shulem: String?
    @LossyString var centroids: String?
    let orthotolidin: Int?
    /// 产品名称
    let multilayer: String?
    /// 产品 logo URL
    let underspore: String?
    /// 订单状态
    @LossyString var osmic: String?
    let pungling: String?
    let spinosely: String?
    /// 状态名称
    let bullrushes: String?
    /// 该笔订单的描述
    let letorate: String?
    /// 借款金额
    let eveready: String?
    let naevus: String?
    /// H5 跳转地址
    let intertwist: String?
    /// 到期时间
    let dissuade: String?
    /// 应还
    let unmatured: String?
    /// 借款时间
    let slabness: String?
    /// 应还时间
    let unamazement: String?
    /// 借款期限
    let duramens: String?
    /// 订单列表显示数据
    let forheed: [OrderItem]?
    /// 借款协议 展示文案
    let deactivations: String?
    /// 借款协议 跳转 URL
    let romanticalism: String?
    
    /// Conform to Identifiable protocol using the order ID as a unique identifier.
    var id: String =  UUID().uuidString
    
    private enum CodingKeys: String, CodingKey {
        case shulem
        case centroids
        case orthotolidin
        case multilayer
        case underspore
        case osmic
        case pungling
        case spinosely
        case bullrushes
        case letorate
        case eveready
        case naevus
        case intertwist
        case dissuade
        case unmatured
        case slabness
        case unamazement
        case duramens
        case forheed
        case deactivations
        case romanticalism
    }
}

// MARK: - 订单列表显示数据
/// 订单列表显示数据项模型
struct OrderItem: Codable, Identifiable {
    /// Conform to Identifiable protocol with a unique UUID, as this item has no unique identifier from the server.
    var id: String = UUID().uuidString
    
    /// 标题
    let daceloninae: String?
    /// 值
    let basilicae: String?
    
    private enum CodingKeys: String, CodingKey {
        case daceloninae
        case basilicae
    }
}
// MARK: - 地址项模型
struct AddressItem: Codable, Identifiable, Hashable {
    // `Identifiable` 协议要求，使用唯一的 ID
    var id = UUID()

    let serphoid: Int?        // JSON 键: serphoid
    let goss: String?         // JSON 键: goss (城市代码/ID)
    let contendent: String?   // JSON 键: contendent (城市名称)
    let umbelliferae: String? // JSON 键: umbelliferae (上级ID)
    let parachor: String?     // JSON 键: parachor (上级ID)
    let untripped: String?    // JSON 键: untripped
    let repartitionable: String? // JSON 键: repartitionable
    let forheed: [AddressItem]?  // JSON 键: forheed (子地址列表)

    // 使用 CodingKeys 将 JSON 中的键名映射到 Swift 属性名，以便于理解和使用。
    enum CodingKeys: String, CodingKey {
        case serphoid
        case goss
        case contendent
        case umbelliferae
        case parachor
        case untripped
        case repartitionable
        case forheed
    }
    
    // MARK: - 自定义 Codable 方法
    
    /// 自定义解码器，用于处理 JSON 中可能缺失的键
    public init(from decoder: Decoder) throws {
        // 创建一个键容器
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 使用 decodeIfPresent 方法安全地解码每一个可选属性。
        // 如果 JSON 中缺少某个键，该方法会返回 nil，而不会抛出错误，
        // 从而避免程序闪退。
        self.serphoid = try container.decodeIfPresent(Int.self, forKey: .serphoid)
        self.goss = try container.decodeIfPresent(String.self, forKey: .goss)
        self.contendent = try container.decodeIfPresent(String.self, forKey: .contendent)
        self.umbelliferae = try container.decodeIfPresent(String.self, forKey: .umbelliferae)
        self.parachor = try container.decodeIfPresent(String.self, forKey: .parachor)
        self.untripped = try container.decodeIfPresent(String.self, forKey: .untripped)
        self.repartitionable = try container.decodeIfPresent(String.self, forKey: .repartitionable)
        self.forheed = try container.decodeIfPresent([AddressItem].self, forKey: .forheed)
    }
    
    /// 自定义编码器，用于在将模型转换为 JSON 时，只包含非 nil 的值
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // 使用 encodeIfPresent 方法安全地编码每一个可选属性。
        // 如果属性值为 nil，则不会将其写入到 JSON 中。
        try container.encodeIfPresent(self.serphoid, forKey: .serphoid)
        try container.encodeIfPresent(self.goss, forKey: .goss)
        try container.encodeIfPresent(self.contendent, forKey: .contendent)
        try container.encodeIfPresent(self.umbelliferae, forKey: .umbelliferae)
        try container.encodeIfPresent(self.parachor, forKey: .parachor)
        try container.encodeIfPresent(self.untripped, forKey: .untripped)
        try container.encodeIfPresent(self.repartitionable, forKey: .repartitionable)
        try container.encodeIfPresent(self.forheed, forKey: .forheed)
    }
}


// ----------------------------------------
// MARK: - 使用示例
// ----------------------------------------
/*
// 假设这是您的 JSON 数据
let jsonString = """
[
  {
    "serphoid": 1,
    "goss": "0001",
    "contendent": "Sumatera",
    "untripped": null,
    "repartitionable": null,
    "forheed": [
      {
        "serphoid": 1,
        "goss": "00010001",
        "contendent": "Aceh",
        "umbelliferae": "0001",
        "repartitionable": null,
        "forheed": [
          {
            "serphoid": 1,
            "goss": "000100010001",
            "contendent": "Kabupaten Aceh Barat",
            "parachor": "00010001",
            "forheed": []
          }
        ]
      }
    ]
  }
]
"""

func decodeAddressData() {
    let jsonData = jsonString.data(using: .utf8)!

    do {
        // 由于 JSON 根是数组，我们直接解码为 [AddressItem]
        let addresses = try JSONDecoder().decode([AddressItem].self, from: jsonData)

        // 打印解析后的数据
        print("成功解析 \(addresses.count) 个地址项。")

        if let firstAddress = addresses.first {
            print("第一个地址项名称：\(firstAddress.contendent ?? "无")")

            if let firstChild = firstAddress.forheed?.first {
                print("第一个子地址项名称：\(firstChild.contendent ?? "无")")

                if let firstGrandchild = firstChild.forheed?.first {
                    print("第一个孙地址项名称：\(firstGrandchild.contendent ?? "无")")
                }
            }
        }

    } catch {
        print("解码失败: \(error)")
    }
}

decodeAddressData()
*/
