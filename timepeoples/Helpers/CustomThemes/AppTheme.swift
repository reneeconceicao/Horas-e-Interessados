//
//  AppTheme.swift
//  mysalesmanagementapp
//
//  Created by Renêe Conceição on 13/08/25.
//


import SwiftUI

protocol AppTheme {
    var themeName: String { get }
    var primaryColor: Color { get }
    var primaryColorWhite: Color { get }
    var colorPremium: Color { get }
    var isPremium: Bool { get }
}

struct DefaultTheme: AppTheme {
    let themeName = "default"
    let primaryColor = Color("ColorThemePurple")
    let primaryColorWhite = Color("ColorThemePurpleWhite")
    let colorPremium = Color("ColorYellowPremium")
    let isPremium = false
}


struct GreenTheme: AppTheme {
    let themeName = "green"
    let primaryColor = Color("ColorThemeGreen")
    let primaryColorWhite = Color("ColorThemeGreenWhite")
    let colorPremium = Color("ColorYellowPremium")
    let isPremium = false
}

struct BrownTheme: AppTheme {
    let themeName = "brown"
    let primaryColor = Color("ColorThemeBrown")
    let primaryColorWhite = Color("ColorThemeBrownWhite")
    let colorPremium = Color("ColorYellowPremium")
    let isPremium = false
}

struct BlueTheme: AppTheme {
    let themeName = "blue"
    let primaryColor = Color("ColorThemeBlue")
    let primaryColorWhite = Color("ColorThemeBlueWhite")
    let colorPremium = Color.white
    let isPremium = false
}

struct RedTheme: AppTheme {
    let themeName = "red"
    let primaryColor = Color("ColorThemeRed")
    let primaryColorWhite = Color("ColorThemeRedWhite")
    let colorPremium = Color.yellow
    let isPremium = false
}

struct OrangeTheme: AppTheme {
    let themeName = "orange"
    let primaryColor = Color("ColorThemeOrange")
    let primaryColorWhite = Color("ColorThemeOrangeWhite")
    let colorPremium = Color("ColorYellowPremium")
    let isPremium = false
}


struct PinkTheme: AppTheme {
    let themeName = "pink"
    let primaryColor = Color("ColorPurple")
    let primaryColorWhite = Color("ColorPurpleWhite")
    let colorPremium = Color("ColorYellowPremium")
    let isPremium = false
}
