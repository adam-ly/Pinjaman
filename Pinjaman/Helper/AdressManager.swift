//
//  AdressManager.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/14.
//

import Foundation
import CoreLocation

/// 一个用于管理定位权限和位置更新的单例类
class AddressManager: NSObject, CLLocationManagerDelegate {
    
    /// 单例共享实例
    static let shared = AddressManager()
    
    private var locationManager: CLLocationManager
    
    /// 用于处理位置更新的回调闭包
    var onLocationUpdate: ((CLLocation?) -> Void)?
    
    var currentLocation: CLLocation?
    
    var locationData: [String: String] = [:]
    
    /// 私有初始化方法，配置 CLLocationManager
    override private init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        // 可以根据需要设置精确度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 应用程序进入后台时是否继续更新位置
        self.locationManager.allowsBackgroundLocationUpdates = false
    }
    
    /// 请求使用时定位权限
    ///
    /// - 注：此方法会触发系统权限弹窗。您需要在 Info.plist 中添加 `NSLocationWhenInUseUsageDescription`。
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// 检查当前的定位权限状态
    ///
    /// - returns: 定位权限状态。
    func authorizationStatus() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
    
    /// 开始获取位置更新
    func startUpdatingLocation() {
        stopUpdatingLocation()        
        // 在开始前检查权限状态
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
            print("开始获取位置更新...")
        } else {
            onLocationUpdate?(nil)
            NotificationCenter.postAlert(alertType: .location)
            print("未获得定位权限，无法开始更新。当前状态: \(status.rawValue)")
        }
    }
    
    /// 停止获取位置更新
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        print("停止获取位置更新。")
    }
    
    // MARK: - CLLocationManagerDelegate
    /// 代理方法：当定位权限状态改变时调用
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("定位权限已授权。")
            // 权限获得后可以立即开始更新
            startUpdatingLocation()
        case .denied:
            print("定位权限被拒绝。")
        case .notDetermined:
            print("定位权限未确定。")
        case .restricted:
            print("定位权限受限。")
        @unknown default:
            print("未知的定位权限状态。")
        }
    }
    
    /// 代理方法：当获取到新的位置信息时调用
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("获取到新位置: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                       
            // 使用 CLGeocoder 进行反向地理编码以获取完整的地址信息
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("反向地理编码失败: \(error.localizedDescription)")
                    // 在失败时，只返回经纬度数据
                    let fallbackData: [String: String] = [
                        "spotsman": String(format: "%.6f", floor(location.coordinate.latitude * 1_000_000) / 1_000_000),
                        "hundredth": String(format: "%.6f", floor(location.coordinate.longitude * 1_000_000) / 1_000_000)
                    ]
                    self.currentLocation = location
                    self.onLocationUpdate?(location)
                    return
                }
                
                if let placemark = placemarks?.first {
                    // 从 placemark 中提取所有必要信息
                    let formattedLatitude = String(format: "%.6f", floor(location.coordinate.latitude * 1_000_000) / 1_000_000)
                    let formattedLongitude = String(format: "%.6f", floor(location.coordinate.longitude * 1_000_000) / 1_000_000)
                    
                    // 根据您提供的 JSON 键名创建字典
                    let locationData: [String: String] = [
                        "adsheart": placemark.administrativeArea ?? "", // 省
                        "puget": placemark.isoCountryCode ?? "", // 国家代码
                        "unstraight": placemark.country ?? "", // 国家
                        "beslings": placemark.thoroughfare ?? "", // 街道
                        "spotsman": formattedLatitude, // 纬度
                        "hundredth": formattedLongitude, // 经度
                        "unlabored": placemark.locality ?? "", // 市
                        "digits": placemark.subLocality ?? "" // 区/县
                    ]
                    self.locationData = locationData
                    print("格式化后的完整位置数据: \(locationData)")
                    
                    // 通过回调闭包传递完整的位置信息和字典
                    self.currentLocation = location
                    self.onLocationUpdate?(location)
                    
                } else {
                    // 如果没有找到地址信息，只返回经纬度
                    let fallbackData: [String: String] = [
                        "spotsman": String(format: "%.6f", floor(location.coordinate.latitude * 1_000_000) / 1_000_000),
                        "hundredth": String(format: "%.6f", floor(location.coordinate.longitude * 1_000_000) / 1_000_000)
                    ]
                    self.locationData = locationData
                    self.currentLocation = location
                    self.onLocationUpdate?(location)
                }
            }
        }
    }
    
    /// 代理方法：当定位失败时调用
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败: \(error.localizedDescription)")
    }
}
