//
//  ContentView.swift
//  mysalesmanagementapp
//
//  Created by Renêe Conceição on 12/08/25.
//
import SwiftUI

struct ThemeSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @AppStorage(PreferencesKeys.isPremium.key) private var isPremium: Bool = PreferencesKeys.isPremium.defaultValue
    
    @State private var currentOption: ThemesListOptions = .theme_default
    
    @State private var navigatePremium = false
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("Choose your favorite color")
                    .foregroundStyle(themeManager.currentTheme.primaryColor)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(ThemesListOptions.allCases, id: \.self) { option in
                                Text(option.rawValue)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 6)
                                    .background(currentOption == option ? Color(UIColor.systemFill) : Color.gray.opacity(0))
                                    .foregroundColor(currentOption == option ? .primary : .primary)
                                    .cornerRadius(8)
                                    .id(option)
                                    .onTapGesture {
                                        withAnimation {
                                            currentOption = option
                                            proxy.scrollTo(option, anchor: .center)
                                        }
                                    }
                                    .font(currentOption == option ? .footnote.bold() : .footnote)
                                
                            }
                        }
                        .padding(.vertical, 2)
                        .padding(.horizontal, 2)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        
                        
                    }
                }
                
                
                ScrollView(showsIndicators: false) {
                    let width = geo.size.width * 0.7
                    switch (currentOption) {
                    case .theme_default:
                        Spacer()
                        ThemePreview(color: .colorThemePurple, isPremium: false, width: width)
                        Spacer()
                    case .theme_green:
                        Spacer()
                        ThemePreview(color: .colorThemeGreen, isPremium: false, width: width)
                        Spacer()
                    case .theme_brown:
                        Spacer()
                        ThemePreview(color: .colorThemeBrown, isPremium: false, width: width)
                        Spacer()
                    case .theme_blue:
                        Spacer()
                        ThemePreview(color: .colorThemeBlue, isPremium: false, width: width)
                        Spacer()
                    case .theme_red:
                        Spacer()
                        ThemePreview(color: .colorThemeRed, isPremium: false, width: width)
                        Spacer()
                    case .theme_orange:
                        Spacer()
                        ThemePreview(color: .colorThemeOrange, isPremium: false, width: width)
                        Spacer()
                    case .theme_pink:
                        Spacer()
                        ThemePreview(color: .colorPurple, isPremium: false, width: width)
                        Spacer()
                    }
                }
                .padding()
                .padding(.top, 8)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    switch (currentOption) {
                    case .theme_default:
                        themeManager.setTheme(DefaultTheme().themeName)
                    case .theme_green:
                        themeManager.setTheme(GreenTheme().themeName)
                    case .theme_brown:
                        themeManager.setTheme(BrownTheme().themeName)
                    case .theme_blue:
                        themeManager.setTheme(BlueTheme().themeName)
                    case .theme_red:
                        themeManager.setTheme(RedTheme().themeName)
                    case .theme_orange:
                        themeManager.setTheme(OrangeTheme().themeName)
                    case .theme_pink:
                        themeManager.setTheme(PinkTheme().themeName)
                        
                    }
                    dismiss()
                }
                .foregroundStyle(.white)
            }
        }
        
    }
}

enum ThemesListOptions: LocalizedStringKey, CaseIterable {
    case theme_default = "Default"
    case theme_green = "Green"
    case theme_pink = "Pink"
    case theme_blue = "Blue"
    case theme_orange = "Orange"
    case theme_red = "Red"
    case theme_brown = "Brown"
}

#Preview {
    let themeManager = ThemeManager()
    ThemeSelectionView()
        .environmentObject(themeManager)
}
