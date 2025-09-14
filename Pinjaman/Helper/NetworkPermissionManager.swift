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

    // 用于监控网络路径的对象
    private let monitor = NWPathMonitor()
    // 队列，用于处理网络监控的更新
    private let queue = DispatchQueue(label: "NetworkMonitor")

    // 网络连接类型的枚举
    enum ConnectionType {
        case wifi
        case cellular
        case unknown
    }

    // 初始化方法，开始监控网络状态
    private init() {
        monitor.start(queue: queue)
    }

    // 使用 async/await 异步获取网络连接状态
    func checkConnectionStatus() async -> (isConnected: Bool, connectionType: ConnectionType) {
        return await withCheckedContinuation { continuation in
            // 确保在同一队列上处理，以避免竞态条件
            monitor.pathUpdateHandler = { path in
                let isConnected = (path.status == .satisfied)
                let type = self.getConnectionType(path)
                continuation.resume(returning: (isConnected, type))
                // 停止监控，只获取一次状态
                self.monitor.cancel()
            }
        }
    }

    // 根据网络路径获取连接类型
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
