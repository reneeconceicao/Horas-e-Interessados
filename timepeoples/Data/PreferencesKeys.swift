//
//  PreferencesKeys.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 08/04/25.
//

import Foundation

enum PreferencesKeys {
    
    struct Preference<T> {
        let key: String
        let defaultValue: T
    }
    
    
    //Percentage and measurements
    
    static let defaultPercentageIncome = Preference<Double>(key: "setting_percentage_income", defaultValue: 2)
    
    static let defaultAdditionalCost = Preference<Double>(key: "setting_additional_cost", defaultValue: 0.15)
    
    static let measurementUnits = Preference<Int>(key: "setting_measurement_units", defaultValue: 0)
    
    //tips
    
    static let servicesTip = Preference<Bool>(key: "setting_services_tip", defaultValue: true)
    
    static let materialShelfTip = Preference<Bool>(key: "setting_material_shelf_tip", defaultValue: true)
    
    static let saleRowTip = Preference<Bool>(key: "setting_recipe_row_tip", defaultValue: true)
    
    static let customerRowTip = Preference<Bool>(key: "setting_material_row_tip", defaultValue: true)
    
    static let serviceRowTip = Preference<Bool>(key: "setting_service_row_tip", defaultValue: true)
    
    static let expenseRowTip = Preference<Bool>(key: "setting_expense_row_tip", defaultValue: true)
    
    static let listRowTip = Preference<Bool>(key: "setting_list_row_tip", defaultValue: true)
    
    static let newMaterialTip = Preference<Bool>(key: "setting_new_material_tip", defaultValue: true)
    
    static let useMaterialTip = Preference<Bool>(key: "setting_use_material_tip", defaultValue: true)
    
    //Launch counter
    static let launchCounter = Preference<Int>(key: "setting_launch_counter", defaultValue: 0)
    
    //Welcome screen
    static let showWelcome = Preference<Bool>(key: "setting_show_welcome", defaultValue: true)
    
    static let isNewUser = Preference<Bool>(key: "setting_is_new_user", defaultValue: true)
    
    //Notifications
    static let isNotificationPermissionDenied = Preference<Bool>(key: "setting_is_notification_permission_denied", defaultValue: false)

    
    //Premium
    static let isPremium = Preference<Bool>(key: "setting_is_premium", defaultValue: false)
    
    //Auto backup
    static let isAutoBackup = Preference<Bool>(key: "setting_is_auto_backup", defaultValue: false)
    
    //Show logo
    static let showLogo = Preference<Bool>(key: "setting_show_logo", defaultValue: true)
    
    //Ads
    static let countLaunchWithoutAds = 10
    
    static let defaultSalePrice = Preference<Double>(key: "setting_default_sale_price", defaultValue: 0)
    
    static let defaultHourReminder = Preference<Double>(key: "setting_default_hour_reminder", defaultValue: {
        var comps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        comps.hour = 9
        comps.minute = 0
        return Calendar.current.date(from: comps)?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
    }())
    
    static let adsCreateShoppingList = Preference<Bool>(key: "setting_ads_share_recipe", defaultValue: false)
    
    static let adsExportPDF = Preference<Bool>(key: "setting_ads_export_pdf", defaultValue: false)
    
    static let adsExportCSV = Preference<Bool>(key: "setting_ads_export_csv", defaultValue: false)
    
    static let adsPendingProof = Preference<Bool>(key: "setting_ads_pending_proof", defaultValue: false)
    
    static let adsShareProof = Preference<Bool>(key: "setting_ads_share_proof", defaultValue: false)
    
    //Profile
    static let profileName = Preference<String>(key: "setting_profile_name", defaultValue: "")
    
    static let profilePhone = Preference<String>(key: "setting_profile_phone", defaultValue: "")
    
    static let profileEmail = Preference<String>(key: "setting_profile_email", defaultValue: "")
    
    static let profileAddress = Preference<String>(key: "setting_profile_address", defaultValue: "")
    
    
}
