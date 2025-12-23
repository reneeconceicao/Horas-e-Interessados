//
//  CurrencyHelper.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 15/04/25.
//

import Foundation

func minutesToHours(minutes: Double) -> String {
    let intMinutes = Int(minutes)
    let remainderMinutes = intMinutes % 60
    let hours = intMinutes / 60
    return "\(String(format: "%02d", hours)):\(String(format: "%02d", remainderMinutes))"
}
