//
//  PinjamanApp.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/8.
//

import SwiftUI

@main
struct PinjamanApp: App {
    
    @StateObject var settings = AppSettings()
    @State var isNetworkConntected: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                TabBarView()
                LaunchView()
            }.environmentObject(settings)
        }
    }
    
    func onCheckConnection() {
    
    }
    
    func onFetchConfig() async {
        do {
            let payload = LoginInitializationPayload(bilirubinic: "en", chartographical: 0, puboiliac: 0)
            let response: Response<ConfigModel> = try await NetworkManager.shared.get(payload)
            
        } catch {
            
        }
        
    }
}
