//
//  ItemView.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 21/04/25.
//

import SwiftUI

struct SaleRow: View {
    
    @AppStorage(PreferencesKeys.saleRowTip.key) private var tipSaleRow: Bool = PreferencesKeys.saleRowTip.defaultValue
    
    @State private var showSaleRowTip = true
    @State private var isShowingSaleRowTip = false
    @State private var arrowOffset: CGFloat = 0
    
    var word: MyDay
    var onMenuTap: () -> Void
    
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 14) {

                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.primary)
                        
                    Text(formatDateTimeItemList(from: word.wordDate))
                        
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundStyle(.primary)
                    let minutes = (word.hours * 60) + word.minutes
                    Text(minutesToHours(minutes: minutes))
                        
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if (!word.wordNotes.isEmpty) {
                    HStack {
                        
                        Text(word.wordNotes)
                            .lineLimit(1)
                            .foregroundStyle(.primary)
                            
                        Spacer()
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding([.bottom], 4)
            
                //.padding([.bottom], 4)
                
        }
    }
    
    func totals(word: MyDay) -> String {
        
        return ""
    }
}

#Preview {
    //    let word = Word(client: "Renee", service1: true, service2: true, price1:  10, price2: 80)
    //    ItemView(word: word)
}
