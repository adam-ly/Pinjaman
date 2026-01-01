//
//  NetworkManager.swift
//  Pinjaman
//
//  Created by MAC on 2025/9/14.
//
import CoreTelephony
import Network

class NetworkPermissionManager {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkPermissionManager_queue",qos: .userInteractive)
    
    private(set) var isConnected = false
    
    func startMonitoring(callBack: @escaping (Bool)-> Void) {        
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            print("网络状态: \(path.status)")
            print("使用的网络: \(path.availableInterfaces)")
            DispatchQueue.main.async(execute: {
                callBack(path.status == .satisfied)
            })
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
