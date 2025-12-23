//
//  PhoneServices.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 04/04/25.
//

import SwiftUI

class PhoneServices: NSObject {
    func callNumber(_ number: String, onUnavailable: () -> Void ) {
        let formattedNumer = sanitizePhoneNumber(number)
            if let url = URL(string: "tel://\(formattedNumer)"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                onUnavailable()
                print("Phone service unavailable: \(formattedNumer)")
            }
        }
    
    private func sanitizePhoneNumber(_ number: String) -> String {
        let allowedCharacters = CharacterSet(charactersIn: "0123456789+*#,;")
        return number.filter { char in
            char.unicodeScalars.allSatisfy { allowedCharacters.contains($0) }
        }
    }
}
