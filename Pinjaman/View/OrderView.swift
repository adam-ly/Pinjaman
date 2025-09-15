//
//  OrderView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/24.
//

import SwiftUI

enum OrderType: String, CaseIterable, Equatable {
    case all
    case inProgress
    case pendingRepayment
    case settled
    
    func tabTitle() -> String {
        switch self {
        case .all:
            return "All"
        case .inProgress:
            return "Apply"
        case .pendingRepayment:
            return "Repayment"
        case .settled:
            return "Finished"
        }
    }
    
    func getId() -> String {
        switch self {
        case .all:
            return "4"
        case .inProgress:
            return "7"
        case .pendingRepayment:
            return "6"
        case .settled:
            return "5"
        }
    }
}

struct OrderView: View {
    @EnvironmentObject var appSeting: AppSettings
    @State private var selectedTab = OrderType.all
    @State private var orderListModel: OrderListModel?
    @EnvironmentObject var navigationState: NavigationState
    @MainActor @State private var showLoading: Bool = false
    
//    @State var destination: (String, String) = ("","")
    
    let tabs = [OrderType.all,
                OrderType.inProgress,
                OrderType.pendingRepayment,
                OrderType.settled]
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(linkTextColor)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(secondaryTextColor)], for: .normal)
    }
       
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                VStack {
                    ZStack(alignment: .bottom) {
                        linkTextColor
                        Text("Order List")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                    }
                }
                .frame(height: 40 + 44)
                .onReceive(NotificationCenter.default.publisher(for: .didLogin)) { n in
                    self.onFetchOrder()
                }
                .onReceive(NotificationCenter.default.publisher(for: .onLanding)) { n in
                    if let tag = n.userInfo?["tag"] as? Int, tag == 1 {
                        self.onFetchOrder()
                    }
                }
                content
                    .loading(isLoading: $showLoading)
                    .onAppear {
                        if appSeting.isLogin() {
                            onFetchOrder()
                        }
                    }
            }
            .ignoresSafeArea(edges:.top)
        }
    }
    
    var content: some View {
        VStack(spacing: 12) {
            orderType
                .frame(height: 50)
                .padding(.top, 12)
            // 订单列表
            ScrollView {
                VStack {
                    ForEach(orderListModel?.mercantilism ?? []) { item in
                        OrderItemView(order: item) { link in
                            if let dest = link.getDestination() as? (String?, String?), let link = dest.0 {
                                navigationState.destination = link
                                navigationState.param = dest.1 ?? ""
                                navigationState.shouldGoToRoot = true
                            }
                        }
                    }
                }
            }
        }
        .background(Color(UIColor.systemGray6))
    }
    
    var orderType: some View {
        Picker("", selection: $selectedTab) {
            ForEach(tabs, id: \.self) { type in
                Text(type.tabTitle()).frame(height: 40)
            }
        }
        .pickerStyle(.segmented)
        .tint(.purple)
        .accentColor(.green)
        .padding(.horizontal)
        .onChange(of: selectedTab) { newValue in
            onFetchOrder()
        }
    }
}

extension OrderView {
    func onFetchOrder() {
        Task {
            do {
                showLoading = true
                let payload = OrderListPayload(polianite: self.selectedTab.getId())
                let response: PJResponse<OrderListModel> = try await NetworkManager.shared.request(payload)
                showLoading = false
                self.orderListModel = response.unskepticalness
            } catch {
                showLoading = false
            }
        }
    }
}

#Preview {
    OrderView()
}
