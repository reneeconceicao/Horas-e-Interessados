//
//  DataManager.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 29/04/25.
//

import Foundation
import CoreData
import SwiftUI

class DataManager {
    
    func fetchAllWords(modelContext: NSManagedObjectContext) -> [MyDay]  {
        let request = MyDay.fetchRequest()
        do {
            let words = try modelContext.fetch(request)
            return words
        } catch {
            return []
        }
    }
    
    
    
    func fetchSaleById(context: NSManagedObjectContext, saleId: UUID) -> MyDay? {
        let request = MyDay.fetchRequest()
        
        let predicate = NSPredicate(format: "id == %@", saleId as CVarArg)
        
        request.predicate = predicate
        
        do {
            return try context.fetch(request).first ?? nil
            
            
            
        } catch {
            return nil
        }
    }
    
    
    
    
    func fetchSalesByClientAndDate(context: NSManagedObjectContext, client: MyClient, firstDate: Date, endDate: Date) -> [MyDay] {
        let request = MyDay.fetchRequest()
        
        let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@) AND clientId == %@", firstDate as NSDate, endDate as NSDate, client.id! as CVarArg)
        
        request.predicate = predicate
        
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    
    func deleteWord(modelContext: NSManagedObjectContext, word: MyDay) {
        do {
            modelContext.delete(word)
            try modelContext.save()
        } catch {
            print("Error on delete word")
        }
    }
    
    
    
    func deleteClient(modelContext: NSManagedObjectContext, client: MyClient) {
        
        modelContext.delete(client)
        do {
            try modelContext.save()
        } catch {
            print("Error on delete word")
        }
    }
    
    
    
    
}
