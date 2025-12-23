//
//  WordContainer.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 23/04/25.
//

import Foundation
import CoreData

class WordContainer {
    let persistentContainer : NSPersistentContainer
    
    init(){
        persistentContainer = NSPersistentContainer(name: "WordModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
}
