//
//  Rota.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 04/04/25.
//

import SwiftUI

enum Routes: Hashable {
    case newWord
    case newCustomer
    case edit(word: MyDay)
    case editCustomer(client: MyClient)
    case report
    case settings
    
}
