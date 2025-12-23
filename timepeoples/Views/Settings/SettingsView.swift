//
//  SettingsView.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 08/04/25.
//

import SwiftUI
import CoreData
import SwiftUIIntrospect


struct SettingsView: View {
    
    enum Field: Int, CaseIterable {
        case percentage
        case cost
        case delete
        case salePrice
    }

    @EnvironmentObject var themeManager: ThemeManager
    
    @AppStorage(PreferencesKeys.isPremium.key) private var isPremium: Bool = PreferencesKeys.isPremium.defaultValue
    
    @AppStorage(PreferencesKeys.defaultHourReminder.key) private var defaultHourReminder: Double = PreferencesKeys.defaultHourReminder.defaultValue
    
    @AppStorage(PreferencesKeys.showLogo.key) private var logoEnabled = PreferencesKeys.showLogo.defaultValue
    
    @AppStorage(PreferencesKeys.defaultSalePrice.key) private var defaultSalePrice: Double = PreferencesKeys.defaultSalePrice.defaultValue
    
    @AppStorage(PreferencesKeys.launchCounter.key) private var launchCounter: Int = PreferencesKeys.launchCounter.defaultValue
    
    @AppStorage(PreferencesKeys.defaultPercentageIncome.key) private var percentageIncome = PreferencesKeys.defaultPercentageIncome.defaultValue
    
    @AppStorage(PreferencesKeys.defaultAdditionalCost.key) private var additionalCost = PreferencesKeys.defaultAdditionalCost.defaultValue
    
    @AppStorage(PreferencesKeys.measurementUnits.key) private var measurementUnits = PreferencesKeys.measurementUnits.defaultValue
    
    
    
    @Environment(\.managedObjectContext) private var modelContext
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.openURL) private var openURL
    
    @State private var measurementDefault = ""
    
    @State private var labelInterval = ""
    
    @State private var searchServices = ""
    
    @State var words: [MyDay] = []
    
    @State var allWords: [MyDay] = []
    
    @State var allClients: [MyClient] = []
    
    @State private var fileURL: URL?
    
    @State private var pdfURL: URL?
    
    @State private var showShareSheet = false
    
    @State private var showShareSheetPDF = false
    
    @State private var showJsonPickerSheet = false
    
    @State private var showReminderHourSheet = false
    
    @State private var shareApp = false
    
    @State private var rateError = false
    
    @State private var restoreError = false
    
    @State private var restoreConfirmation = false
    
    @State private var restoreSuccess = false
    
    @State private var jsonString: String = ""
    
    @State private var showCreateBackupHelp = false
    
    @State private var showRestoreBackupHelp = false
    
    @State private var manageSubscription = false
    
    @State private var showPermissionDialog = false
    
    @State private var shareTextRecipes: String = ""
    
    @State private var isSharingTextRecipes = false
    
    @State private var navigatePremium = false
    
    @State private var adLoading = false
    
    @State private var tmpReminder: Date = Date()
    
    @FocusState private var fieldFocus: Field?
    
    var onBackupSuccess: () -> Void
    
    var body: some View {
        
        
        ZStack {
            
            Form {
                Section(header: Text("Defaults")
                    .foregroundStyle(themeManager.currentTheme.primaryColor)
                    .font(.footnote.bold())) {
                        
                        
                        NavigationLink(destination: ThemeSelectionView()) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Change app color")
                                }
                                Spacer()
                            }
                        }
                        
                    }

                Section(header: Text("Application")
                    .foregroundStyle(themeManager.currentTheme.primaryColor)
                    .font(.footnote.bold())) {
                        Button {
                            
                            let url = "https://apps.apple.com/app/id6756936803?action=write-review"
                            
                            guard let writeReviewURL = URL(string: url) else {
                                rateError = true
                                return
                            }
                            
                            openURL(writeReviewURL)
                            
                        } label: {
                            HStack {
                                Image(systemName: "star.fill")
                                    .imageScale(.medium)
                                    .foregroundStyle(.yellow)
                                    .padding([.trailing], 8)
                                Text("Rate us")
                                    .tint(.primary)
                                Spacer()
                                
                            }
                            
                            
                        }
                        Button {
                            
                            shareApp = true
                            
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.up.on.square")
                                    .imageScale(.medium)
                                    .foregroundStyle(themeManager.currentTheme.primaryColor)
                                    .padding([.trailing], 8)
                                VStack(alignment: .leading) {
                                    Text("Share app")
                                        .tint(.primary)
                                    Text("Did you like the app? Share with your friends and help the app get even better!")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                
                            }
                            
                            
                        }
                        
                        Link("Terms", destination: URL(string:  "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                            .tint(.primary)
                        
                        Link("Privacy policy", destination: URL(string:  "https://beautytoolstech.web.app/policy.html")!)
                            .tint(.primary)
                        
                        if (isPremium) {
                            Button {
                                if ProcessInfo.processInfo.isMacCatalystApp {
                                    let url = "https://apps.apple.com/account/subscriptions"
                                    guard let subscriptionsURL = URL(string: url) else {
                                        
                                        return
                                    }
                                    openURL(subscriptionsURL)
                                } else {
                                    manageSubscription = true
                                }
                            } label: {
                                HStack {
                                    Text("Manage subscription")
                                    Spacer()
                                }
                                .tint(.primary)
                                
                            }
                        }
                    }
                
            }

            .applyHiddenScrollIndicators()
            .manageSubscriptionsSheet(isPresented: $manageSubscription)
            .sheet(isPresented: $shareApp) {
                let text = String(localized: "Hey, \n\nHours & interested people is a fast, simple and secure app that I use to manage my hours and interested people. \n\nGet it for free at:\n\nhttps://apps.apple.com/app/id6756936803 for iOS")
                ShareSheet(activityItems: [text])
            }
            
            
            
            
            .toast(
                isPresented: $adLoading,
                paddingBottom: 32,
                duration: 3.5,
                message: String(localized: "The ad is loading, please try again soon")
            )
            .toast(
                isPresented: $restoreError,
                duration: 3.5,
                message: String(localized: "Error: Unable to restore selected backup"),
                image: "exclamationmark.triangle.fill",
                imageColor: .yellow
            )
            .toast(
                isPresented: $rateError,
                duration: 3.5,
                message: String(localized: "Error: Unable to open app review page. Please, visit App Store to rate us."),
                imageColor: .yellow
            )
            
            .sheet(isPresented: $showShareSheet) {
                if let fileURL {
                    ShareFileSheet(activityItems: [fileURL], isPresented: $showShareSheet)
                }
            }
            .sheet(isPresented: $showShareSheetPDF) {
                if let pdfURL {
                    ShareFileSheet(activityItems: [pdfURL], isPresented: $showShareSheetPDF)
                }
            }
            
            .sheet(isPresented: $isSharingTextRecipes) {
                ShareSheet(activityItems: [shareTextRecipes])
            }
            .sheet(isPresented: $showReminderHourSheet) {
                NavigationView {
                    VStack {
                        
                        Text("Default time for new reminders")
                            .font(.title3)
                            .padding(.top)
                        
                        DatePicker("",
                                   selection: $tmpReminder,
                                   displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        
                        Spacer()
                        
                    }
                    .navigationTitle("Choose time")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                defaultHourReminder = tmpReminder.timeIntervalSince1970
                                showReminderHourSheet = false
                            }
                            .foregroundStyle(.white)
                        }
                    }
                }
            }
            .onAppear {
                
                Task {
                    words = await fetchAllWords()
                }
                Task {
                    allWords = await fetchAllWords()
                    allClients = await fetchAllClients()
                    
                }
                
                
                tmpReminder = Date(timeIntervalSince1970: defaultHourReminder)
            }
            
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Group {
                        Button("Done") {
                            fieldFocus = .none
                        }
                        //.bold()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
    
    private func fetchAllWords() async -> [MyDay]  {
        let request = MyDay.fetchRequest()
        
        do {
            let myWords = try modelContext.fetch(request)
            return myWords
        } catch {
            return []
        }
        
    }
    
    private func fetchAllClients() async -> [MyClient]  {
        let request = MyClient.fetchRequest()
        
        do {
            let myClients = try modelContext.fetch(request)
            return myClients
        } catch {
            return []
        }
        
    }
    
    
//    func clearAllWords(onComplete: () -> Void) {
//        let request: NSFetchRequest<NSFetchRequestResult> = MySale.fetchRequest()
//        
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
//        do {
//            try modelContext.execute(deleteRequest)
//            try modelContext.save()
//            onComplete()
//        } catch {
//            print("Error on delete all words")
//        }
//    }

}

#Preview {
    
    //    SettingsView {}
    //        .environment(\.managedObjectContext, WordContainer().persistentContainer.viewContext)
    //
}
