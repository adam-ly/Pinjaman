//
//  AddressPickerView.swift
//  Pinjaman
//
//  Created by MAC on 2025/8/30.
//
import SwiftUI

struct SSContentView: View {
    @State private var showHalfModal = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            Button("显示半高浮层") {
                withAnimation(.spring()) {
                    showHalfModal = true
                }
            }
            // 半高浮层
            if showHalfModal {
                HalfModalView(isPresented: $showHalfModal) {
                    Text("这是一个半高浮层")
                        .frame(height: 40)
                        .padding()

                    Button {
                        withAnimation(.spring()) {
                            showHalfModal.toggle()
                        }
                    } label: {
                        Text("关闭")
                            .frame(height: 40)
                    }
                    .padding(.bottom, 34)
                }
            }
        }
    }
}

struct HalfModalView<Content: View>: View {
    @Binding var isPresented: Bool
    @ViewBuilder let content: () -> Content
    @State private var offset: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring()) {
                        offset = UIScreen.main.bounds.height
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isPresented = false
                        }
                    }
                }
            
            VStack {
                content()
            }
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .offset(y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SSContentView()
    }
}
