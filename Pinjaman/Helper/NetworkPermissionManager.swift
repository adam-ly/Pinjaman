//
//  NetworkManager.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/14.
//

import Foundation
import Network

// 一个单例网络管理器，用于监控网络连接状态
class NetworkPermissionManager {
    static let shared = NetworkPermissionManager()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkPermissionManager")

    // 网络连接类型的枚举
    enum ConnectionType {
        case wifi
        case cellular
        case unknown
    }
    
    func checkConnectionStatus(callBack: @escaping (Bool, ConnectionType) -> Void) {
        monitor.cancel()
        // 立即获取当前路径状态
        monitor.pathUpdateHandler = { [weak self] path in
            let type = self?.getConnectionType(path) ?? .unknown
            print("network isConnect = \(type != .unknown) type = \(type)")
            callBack(type != .unknown, type)
        }
        monitor.start(queue: queue)
    }
    
    private func getConnectionType(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else {
            return .unknown
        }
    }
    
    // 停止网络监控
    deinit {
        monitor.cancel()
    }
}
