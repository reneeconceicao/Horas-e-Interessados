//
//  manicurecalendarApp.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 02/04/25.
//

import SwiftUI
import SwiftData
import StoreKit


@main
struct manicurecalendarApp: App {
    
    
    
    @StateObject private var themeManager = ThemeManager()
    
    let modelContext = WordContainer().persistentContainer.viewContext
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    var isLogged:Bool = false
    
    init() {
        setupNavigationBarAppearance(
            backgroundColor: UIColor(named: "ColorPurple") ?? .purple,
            titleColor: .white,
            buttonColor: .white
        )
    }
    
    
    var body: some Scene {
        
        WindowGroup {
                    MainView()
                        .environment(\.managedObjectContext, modelContext)
                        .environmentObject(themeManager)
                        
                        
        }
        
        
        
    }
    
   
    
}
