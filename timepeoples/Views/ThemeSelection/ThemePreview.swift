//
//  ThemePreview.swift
//  mysalesmanagementapp
//
//  Created by Renêe Conceição on 23/08/25.
//

import SwiftUI

struct ThemePreview: View {
    
    @State private var toogleOn = true
    
    let color: Color
    let isPremium: Bool
    var width: CGFloat
    
    var body: some View {
        
        VStack(spacing: 0) {
            Text("Sales Management")
                .padding(.vertical, 4)
                .foregroundStyle(.background)
                .frame(maxWidth: .infinity)
                .background(color)
                .font(.headline)
                
            Text("Text")
                .foregroundStyle(color)
                .font(.headline)
                .padding(.all, 8)
                .padding(.horizontal, 48)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color, lineWidth: 2)
                }
                .cornerRadius(8)
                .padding(.top)
                .padding(.top)
            
            HStack {
                Rectangle()
                    .foregroundStyle(.gray)
                    .cornerRadius(32)
                
                Toggle("", isOn: $toogleOn)
                    .tint(color)
                    .allowsHitTesting(false)
                
                    
                    
            }
            .padding()
            .padding(.top)
            .padding(.top)
            
            
            HStack {
                Image(systemName: "checkmark.circle")
                    .imageScale(.large)
                    .foregroundStyle(color)
                
                Rectangle()
                    .foregroundStyle(.gray)
                    .cornerRadius(32)
                
                
            }
            .padding()
            .padding(.top)
            HStack {
                Image(systemName: "checkmark.circle")
                    .imageScale(.large)
                    .foregroundStyle(color)
                
                Rectangle()
                    .foregroundStyle(.gray)
                    .cornerRadius(32)
                
                
            }
            .padding()
            Button("Button") {
                
            }
            .buttonStyle(.borderedProminent)
            .tint(color)
            .padding()
            .padding(.bottom)
            .allowsHitTesting(false)
        }
        
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(color, lineWidth: 2)
        }
        .cornerRadius(8)
        .frame(width: width)
        
        
        if (isPremium) {
            Image(systemName: "crown.fill")
                .padding(.top)
                .foregroundStyle(.yellow)
        }
    }
}

#Preview {
    ThemePreview(color: .colorPurple, isPremium: true, width: 350)
}
