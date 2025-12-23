//
//  MyWord+Extension.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 23/04/25.
//

import Foundation

extension MyClient {
    
    var wordId: UUID {
        id ?? UUID()
    }
    
    var wordName: String {
        clientName ?? ""
    }
    
    var wordPhone: String {
        clientPhone ?? ""
    }
    
    var wordNotes: String {
        clientNotes ?? ""
    }
    
    
}
