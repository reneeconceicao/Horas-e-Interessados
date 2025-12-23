//
//  ShareHelper.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 20/04/25.
//

import SwiftUI
import CoreData

struct ShareHelper {
    
    func shareSale(sale: MyDay) -> String {
        
        var text = ""
        
        text.append(String(localized: "Sale date: \(formatShortDate(sale.wordDate))"))
        
        text.append("\n\n")
        
        
//        text.append(String(localized: ("Notes: \(sale.wordNotes)")))
        
        
        return text
        
    }
    
    func shareClient(client: MyClient) -> String {
        
        var text = ""
        text.append(String(localized: "Name: \(client.wordName)"))
                
        text.append("\n\n")
        
        text.append(String(localized: "Phone: \(client.wordPhone)"))
                
        text.append("\n\n")
        
        if !client.wordNotes.isEmpty {
            text.append(String(localized: ("Notes: \(client.wordNotes)")))
        }
        
        return text
        
    }
    
}

