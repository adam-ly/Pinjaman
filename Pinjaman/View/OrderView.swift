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
    
    @State private var selectedTab = OrderType.all
    @State private var orderListModel: OrderListModel?
    @State private var shouldNavigate = false
    @MainActor @State private var showLoading: Bool = false
    
    @State var destination: (String, String) = ("","")
    
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
        NavigationView {
            content
                .navigationTitle("Order List")
                .navigationBarTitleDisplayMode(.inline)
                .hideTabBarOnPush(showTabbar: true)
                .loading(isLoading: $showLoading)
                .onAppear {
                    onFetchOrder()
                }
        }.tint(.white)
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
                                self.destination = (link, dest.1 ?? "")
                                shouldNavigate = true
                            }
                        }
                    }
                }
            }
            NavigationLink(destination: NavigationManager.navigateTo(for: destination.0, prodId: destination.1), isActive: $shouldNavigate) {
                EmptyView() // 隐藏的 NavigationLink 标签
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
