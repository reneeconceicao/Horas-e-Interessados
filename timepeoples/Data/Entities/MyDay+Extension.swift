//
//  MyWord+Extension.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 23/04/25.
//

import Foundation

extension MyDay {
    
    var wordId: UUID {
        id ?? UUID()
    }
    
    var wordDate: Date {
        date ?? Date.now
    }
    
    var wordNotes: String {
        notes ?? ""
    }

}
