//
//  PermissionsManager.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 10/04/25.
//

import SwiftUI

class PermissionsManager: NSObject {
    func hasNotificationPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()


        // Obtain the notification settings.
        let settings = await center.notificationSettings()


        // Verify the authorization status.
        guard (settings.authorizationStatus == .authorized) ||
              (settings.authorizationStatus == .provisional) else { return false}

        return true

    }
    
    func requestNotificationPermission(onGranted: () async -> Void, onDenied: () -> Void) async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            if (granted) {
                await onGranted()
            } else {
                onDenied()
            }
        } catch {
            // Handle errors that may occur during requestAuthorization.
        }
    }
}
