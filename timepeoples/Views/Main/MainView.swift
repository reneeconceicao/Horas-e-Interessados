//
//  ContentView.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 02/04/25.
//

import SwiftUI
import SwiftData
import StoreKit
import GoogleMobileAds
import UIKit


struct MainView: View {
    
    @Environment(\.managedObjectContext) private var modelContext
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    @AppStorage(PreferencesKeys.launchCounter.key) private var launchCounter: Int = PreferencesKeys.launchCounter.defaultValue
    
    @AppStorage(PreferencesKeys.showWelcome.key) private var showWelcome: Bool = PreferencesKeys.showWelcome.defaultValue
    
    @State private var optionsWord = false
    
    @State private var iconChange = false
    
    @State private var firstDate: Date
    
    @State private var endDate: Date
    
    @State private var total = 0.0
    
    @State private var pending = 0.0
    
    @State private var totalExpense = 0.0
    
    @State private var pendingExpense = 0.0
    
    @State private var currentRoute: Routes?
    
    @State private var currentFilter: CurrentFilter = .month
    
    @State private var words: [MyDay] = []
    
    @State private var clients: [MyClient] = []
    
    @State private var showBackupToast = false
    
    @State private var showSaleSavedToast = false
    
    @State private var showEmptyListToast = false
    
    @State private var showCreateListToast = false
    
    @State private var navigatePremium = false
    
    @State private var currentListCreatedTitle = ""
    
    @State private var shareApp = false
    
    @State private var listId = 0
    
    @State private var dashboardId = 0
    
    @State private var currentOption: ListOptions = .dashboard
    
    @State private var searchRecipe = ""
    @State private var searchCustomer = ""
    @State private var searchList = ""
    @State private var reportTextPeriod = ""
    
    @State private var showFilterCustomer = false
    @State private var selectedOptionCustomer = 0
    @State private var isCheckedPendingCustomers = false
    
    @State private var showFilterExpenses = false
    @State private var selectedOptionExpense = 0
    @State private var isCheckedPendingExpenses = false
    
    
    @State private var selectedOptionSale = 0
    @State private var isCheckedPendingSales = false
    
    @State private var tempIsCheckedPendingSales = false
    @State private var tempSelectedOptionSale = 0
    
    @State private var showFilterSales = false
    
    @State private var email = ""
    
    private let calendar = Calendar.current
    
    enum ListOptions: LocalizedStringKey, CaseIterable {
        case dashboard = "Hours"
        case customers = "Interested"
    }
    
    @ViewBuilder
    private var routeDestination: some View {
        switch currentRoute {
        
            
        case .newWord:
            //ContentView()
            
            NewSaleView( onSaleSaved : {
                withAnimation {
                    showSaleSavedToast = true
                }
            })
            .onDisappear {
                withAnimation {
                    fetchWords()
                }
            }
            
        case .newCustomer:
            NewCustomerView()
                .onDisappear {
                    withAnimation {
                        fetchClients()
                    }
                }
            
        case .edit(let word) :
            
            NewSaleView(
                
                updateWord: word,
                onSaleSaved : {
                    fetchWords()
                    showSaleSavedToast = true
                })
            .onDisappear {
                fetchWords()
            }
            
            
            
        case .editCustomer(let client) :
            NewCustomerView(updateClient: client)
                .onDisappear {
                    withAnimation {
                        fetchClients()
                    }
                }
            
            
        case .settings :
            SettingsView(onBackupSuccess: {
                fetchWords()
                fetchClients()
                dashboardId = dashboardId + 1
                showBackupToast = true
            })
            
            
        case .none:
            EmptyView()
            
            
        case .some(.report):
            ReportView()
            
            
        }
        
        
        
    }
    
    init() {
        let components = calendar.dateComponents([.year, .month], from: Date())
        if let start = calendar.date(from: components),
           let range = calendar.range(of: .day, in: .month, for: start) {
            let end = calendar.date(byAdding: .day, value: range.count - 1, to: start)!
            self.firstDate = start.startOfDay(using: calendar)
            self.endDate = end.endOfDay(using: calendar)
        } else {
            self.firstDate = Date()
            self.endDate = Date()
        }
    }
    
    
    var body: some View {
        NavigationView() {
            ZStack {
                
                VStack(alignment: .center, spacing: 0) {
                    
                    Picker("", selection: $currentOption) {
                        ForEach(ListOptions.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding([.top, .leading, .trailing])
                    
                    
                    
                    switch (currentOption) {
                    case .dashboard:
                        
                        
                        SaleHeader(
                            total: $total,
                            firstDate: $firstDate,
                            endDate: $endDate,
                            currentFilter: $currentFilter,
                            isFiltered: isCheckedPendingSales,
                            showSalesDialogFilter: {
                                showFilterSales = true
                            },
                            onNavigate: { route in
                                currentRoute = route
                            })
                        .padding(.top)
                        .padding(.bottom, 4)
                        
                        .id(listId)
                        
                        SaleList(
                            words: $words,
                            selectedOptionSale: selectedOptionSale,
                            isCheckedPendingSales: isCheckedPendingSales,
                            onNavigate: { route in
                                currentRoute = route
                            },
                            onItemUpdated: {
                                fetchWords()
                            }
                        )
                        .onAppear {
                            withAnimation {
                                
                                fetchWords()
                                fetchClients()
                                
                                
                            }
                        }
                        .id(listId)
                        
                    case .customers:
                        
                        
                        CustomerList(
                            clients: $clients,
                            search: $searchCustomer,
                            isFiltered: isCheckedPendingCustomers,
                            onNavigate: { route in
                                currentRoute = route
                            },
                            showCustomerDialogFilter: {
                                showFilterCustomer = true
                            }
                        )
                        .id(listId)
                        .onAppear {
                            withAnimation {
                                fetchWords()
                                fetchClients()
                                
                            }
                        }
                    }
                    VStack {
                        HStack {
                            
                            
                            switch (currentOption) {
                            case .dashboard:
                                
                                Button {
                                    currentRoute = Routes.report
                                }label: {
                                    Image(systemName: "info.circle.fill")
                                        .imageScale(.large)
                                        .foregroundStyle(themeManager.currentTheme.primaryColorWhite)
                                        .font(.headline.bold())
                                    Text("Reporting")
                                        .foregroundStyle(themeManager.currentTheme.primaryColorWhite)
                                        .font(.headline.bold())
                                    
                                }
                                .padding([.leading, .trailing, .bottom])
                                .padding([.top])
                                Spacer()
                                
                                
                                Button {
                                    currentRoute = Routes.newWord
                                }label: {
                                    HStack {
                                        Text("Add Hours")
                                            .foregroundStyle(themeManager.currentTheme.primaryColorWhite)
                                            .font(.headline.bold())
                                        Image(systemName: "plus.circle.fill")
                                            .imageScale(.large)
                                            .foregroundStyle(themeManager.currentTheme.primaryColorWhite)
                                            .font(.headline.bold())
                                        
                                    }
                                }
                                .padding([.leading, .trailing, .bottom])
                                .padding([.top])
                                
                            case .customers :
                                Spacer()
                                Button {
                                    currentRoute = Routes.newCustomer
                                }label: {
                                    HStack {
                                        Text("Add Interested")
                                            .foregroundStyle(themeManager.currentTheme.primaryColorWhite)
                                            .font(.headline.bold())
                                        Image(systemName: "person.circle.fill")
                                            .imageScale(.large)
                                            .foregroundStyle(themeManager.currentTheme.primaryColorWhite)
                                            .font(.headline.bold())
                                        
                                    }
                                }
                                .padding([.leading, .trailing, .bottom])
                                .padding([.top])
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    
                    NavigationLink(
                        destination: routeDestination,
                        isActive: Binding(
                            get: { currentRoute != nil },
                            set: { isActive in
                                if !isActive { currentRoute = nil }
                            }
                        )
                    ) {
                        EmptyView()
                    }
                }
                
                
            }
            .toast(
                isPresented: $showBackupToast,
                paddingBottom: 120,
                duration: 3.5,
                message: String(localized: "Backup restored successfully")
            )
            .toast(
                isPresented: $showSaleSavedToast,
                paddingBottom: 120,
                duration: 2,
                message: String(localized: "Sale saved successfully")
            )
            
            .sheet(isPresented: $shareApp) {
                let text = String(localized: "Hey, \n\nHours & interested people is a fast, simple and secure app that I use to manage my hours and interested people. \n\nGet it for free at:\n\nhttps://apps.apple.com/app/id6756936803 for iOS")
                ShareSheet(activityItems: [text])
            }
            .navigationTitle("Hours & interested")
            
            
            .toolbar {
                
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            currentRoute = Routes.settings
                        }label: {
                            HStack {
                                Image(systemName: "gear")
                                    .imageScale(.large)
                                Text("Settings")
                                
                            }
                        }
                        
                        
                        Button {
                            shareApp = true
                        }label: {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .imageScale(.large)
                                Text("Share app")
                                
                            }
                        }
                        
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
        
        
        
        .onChange(of: firstDate) { _ in
            DispatchQueue.main.async {
                withAnimation {
                    fetchWords()
                    
                }
            }
        }
        .onChange(of: endDate) { _ in
            DispatchQueue.main.async {
                withAnimation {
                    fetchWords()
                    
                }
            }
            
        }
        
        
        
        .onChange(of: searchCustomer) { period in
            withAnimation {
                fetchClients()
            }
        }
        .onChange(of: isCheckedPendingCustomers) { _ in
            withAnimation {
                fetchClients()
            }
        }
        .onChange(of: selectedOptionCustomer) { _ in
            withAnimation {
                fetchClients()
            }
        }
        
        .onAppear {
            
            print("CONTEXT MAIN:: \(modelContext)")
            
            fetchWords()
            
            fetchClients()
            
            
            
            
            
            
            
            
        }
        
    }
    
    func fetchWord(_ id:UUID) -> MyDay? {
        let request = MyDay.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as NSObject)
        
        do {
            let sales = try modelContext.fetch(request)
            return sales.first
        } catch {
            return nil
        }
    }
    
    private func fetchWords() {
        let request = MyDay.fetchRequest()
        
        let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", firstDate as NSDate, endDate as NSDate)
        
        let sort = [NSSortDescriptor(key: "date", ascending: false)]
        
        request.sortDescriptors = sort
        
        request.predicate = predicate
        
        
        do {
            
            words = try modelContext.fetch(request)
            let minutes = words.reduce(0.0, {result, word in result + word.minutes})
            let hours = words.reduce(0.0, {result, word in result + word.hours})
            total = (hours * 60) + minutes
            
        } catch {
            print("Error on fetch")
        }
        
    }
    
    
    
    private func fetchClients() {
        let request = MyClient.fetchRequest()
        
        
        if !searchCustomer.isEmpty {
            request.predicate = NSPredicate(format: "clientName CONTAINS[cd] %@ OR clientNotes CONTAINS[cd] %@", argumentArray: [searchCustomer, searchCustomer])
        }
        let sort = [NSSortDescriptor(key: "clientName", ascending: true)]
        
        request.sortDescriptors = sort
        
        do {
            
            let data = try modelContext.fetch(request)
            
            clients = data
            
        } catch {
            print("Error on fetch")
        }
        
    }
    
    
    func requestReview(){
        if (launchCounter > 4) {
            let scenes = UIApplication.shared.connectedScenes
            if let windowScene = scenes.first as? UIWindowScene {
                if #available(iOS 16.0, *) {
                    AppStore.requestReview(in: windowScene)
                } else {
                    SKStoreReviewController.requestReview(in: windowScene)
                }
            }
        }
    }
    
}


#Preview {
    MainView()
}
