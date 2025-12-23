//
//  ItemView.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 21/04/25.
//

import SwiftUI

struct CustomerRow: View {
    
    @ObservedObject var customer: MyClient
    
    @AppStorage(PreferencesKeys.customerRowTip.key) private var tipMaterialRow: Bool = PreferencesKeys.customerRowTip.defaultValue
    
    @State private var showCustomerRowTip = true
    @State private var isShowingCustomerRowTip = false
    @State private var arrowOffset: CGFloat = 0
    
    var onMenuTap: () -> Void
    
    var body: some View {
        ZStack {
            HStack {
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "person.fill")
                            .padding([.trailing], 8)
                        Text(customer.wordName)
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.top], 4)
                    }
                    HStack {
                        Image(systemName: "phone.fill")
                            .padding([.trailing], 8)
                        Text(customer.wordPhone.isEmpty ? String(localized: "Phone not informed") : customer.wordPhone)
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.top], 4)
                    }
                    
                }
                if ProcessInfo.processInfo.isMacCatalystApp {
                    Spacer()
                    Button {
                        onMenuTap()
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .padding([.trailing])
                }
            }
            if showCustomerRowTip && tipMaterialRow && !ProcessInfo.processInfo.isMacCatalystApp {
                HStack {
                    Spacer()
                    Image(systemName: "arrowshape.left.fill")
                        .imageScale(.large)
                        .foregroundColor(.red)
                        .offset(x: arrowOffset)
                        .opacity(Double(1 - abs(arrowOffset / 140)))
                        .onAppear {
                            animateArrow()
                        }
                    Text("Swipe")
                        .offset(x: arrowOffset)
                        .foregroundStyle(.red)
                        .opacity(Double(1 - abs(arrowOffset / 140)))
                    
                }
                .onAppear {
                    isShowingCustomerRowTip = true
                }
                .onDisappear {
                    if isShowingCustomerRowTip {
                        tipMaterialRow = false
                    }
                }
                

            }
        }
        
    }
        
    
    func animateArrow() {
        withAnimation(.easeOut(duration: 5)) {
            arrowOffset = -300
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.2) {
            withAnimation {
                showCustomerRowTip = false
                tipMaterialRow = false
            }
        }
    }
}

#Preview {
    
    
}
