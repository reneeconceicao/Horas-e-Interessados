//
//  AppDelegate.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 10/04/25.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    @AppStorage(PreferencesKeys.launchCounter.key) private var launchCounter: Int = PreferencesKeys.launchCounter.defaultValue
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        
        UNUserNotificationCenter.current().delegate = self
        
        launchCounter = launchCounter + 1
        
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    

}
