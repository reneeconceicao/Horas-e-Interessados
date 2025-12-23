//
//  NumbersOnlyViewModifier.swift
//  recipecalculatorapp
//
//  Created by Renêe Conceição on 06/06/25.
//


//
// Created for NumericTextFields
// by Stewart Lynch on 2022-12-18
// Using Swift 5.0
//
// Follow me om Mastodon: @StewartLynch@iosDev.space
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import SwiftUI
import Combine

struct NumbersOnlyViewModifier: ViewModifier {
    
    @Binding var text: String
    var includeDecimal: Bool
    
    func body(content: Content) -> some View {
        content
            .keyboardType(includeDecimal ? .decimalPad : .numberPad)
            .onReceive(Just(text)) { newValue in
                var numbers = "0123456789"
                let decimalSeparator: String = Locale.current.decimalSeparator ?? "."
                if includeDecimal {
                    numbers += decimalSeparator
                }
                if newValue.components(separatedBy: decimalSeparator).count-1 > 1 {
                    let filtered = newValue
                    self.text = String(filtered.dropLast())
                } else {
                    let filtered = newValue.filter { numbers.contains($0)}
                    if filtered != newValue {
                        self.text = filtered
                    }
                }
            }
    }
}

extension View {
    func numbersOnly(_ text: Binding<String>, includeDecimal: Bool = false) -> some View {
        self.modifier(NumbersOnlyViewModifier(text: text, includeDecimal: includeDecimal))
    }
}

func toDecimalDouble(_ value: String) -> Double {
    return Double(value.replacingOccurrences(of: ",", with: ".")) ?? 0
}

func toDecimalString(_ value: Double) -> String {
    return String(value).replacingOccurrences(of: Locale.current.decimalSeparator ?? ".", with: ".")
}

func toPercentage(_ value: Double?) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    if let number = value {
        return formatter.string(from: NSNumber(value: number/100)) ?? ""
    }
    return ""
}

