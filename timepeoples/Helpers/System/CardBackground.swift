//
//  CardBackground.swift
//  mysalesmanagementapp
//
//  Created by Renêe Conceição on 13/08/25.
//


import SwiftUI

// view modifier
struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color("ColorCardBackground"))
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.2), radius: 2.5, x: -2, y: 2)
            
    }
}

// view modifier
struct CardBackgroundClear: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color("ColorCardBackground"))
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.1), radius: 2.5, x: -2, y: 2)
            
    }
}

extension View {
    func cardBackground() -> some View {
        modifier(CardBackground())
    }
}


extension View {
    func cardBackgroundClear() -> some View {
        modifier(CardBackgroundClear())
    }
}
