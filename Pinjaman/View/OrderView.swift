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
            return LocalizeContent.orderAll.text()
        case .inProgress:
            return LocalizeContent.orderApply.text()
        case .pendingRepayment:
            return LocalizeContent.orderRepayment.text()
        case .settled:
            return LocalizeContent.orderFinished.text()
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
    @EnvironmentObject private var router: NavigationRouter
    @MainActor @State private var showLoading: Bool = false
        
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
                navBar
                content
            }
            .ignoresSafeArea(edges:.top)
            .onReceive(NotificationCenter.default.publisher(for: .didLogin)) { n in
                self.onFetchOrder()
            }
            .onReceive(NotificationCenter.default.publisher(for: .onLanding)) { n in
                if let tag = n.userInfo?["tag"] as? Int, tag == 1 {
                    self.onFetchOrder()
                }
            }
            .loading(isLoading: $showLoading)
            .onAppear {
                if appSeting.isLogin() {
                    onFetchOrder()
                }
            }
        }
    }
    
    var navBar: some View {
        VStack {
            ZStack(alignment: .bottom) {
                linkTextColor
                Text(LocalizeContent.orderList.text())
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
            }
        }
        .frame(height: 40 + 44)
    }
    
    var content: some View {
        VStack(spacing: 12) {
            orderType
                .frame(height: 50)
                .padding(.top, 12)
            if (orderListModel?.mercantilism ?? []).count > 0 {
                orderList
            } else {
                emptyView
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
    
    var emptyView: some View {
        VStack(spacing: 20) {
            Image("order_empty")
            Text(LocalizeContent.orderEmpty.text())
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(secondaryTextColor)
        }.frame(maxHeight: .infinity)
    }
    
    var orderList: some View {
        // 订单列表
        ScrollView {
            VStack {
                ForEach(orderListModel?.mercantilism ?? []) { item in
                    OrderItemView(order: item) { link in
                        let dest = link.getDestinationPath(parameter: "")
                        router.push(to: dest)
                    }
                }
            }
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
