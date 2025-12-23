//
//  RadioButtonGroup.swift
//  mysalesmanagementapp
//
//  Created by Renêe Conceição on 20/08/25.
//
import SwiftUI

struct RadioButtonGroup: View {
    @Binding var selected: Int
    
    let color: Color
    
    let options: [String]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            ForEach(0..<options.count, id: \.self) { index in
                HStack {
                    
                    Text(options[index])
                        .padding(.vertical, 12)
                        
                    Spacer()
                    if (selected == index) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.primary)
                    }
                }
                
                .contentShape(Rectangle())
                .onTapGesture {
                    selected = index
                }
                .padding(.horizontal)
                if index < options.count - 1 {
                    Divider()
                        .padding(.leading)
                } else {
                    Divider()
                        .padding(.leading)
                        .opacity(0)
                }
            }
        }
        
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        
    }
}
