//
//  DashboardHeader.swift
//  mysalesmanagementapp
//
//  Created by Renêe Conceição on 02/09/25.
//

import SwiftUI

struct SaleHeader: View {
    
    @EnvironmentObject private var themeManager: ThemeManager
    
   
    @Binding var total: Double
    @Binding var firstDate: Date
    @Binding var endDate: Date
    @Binding var currentFilter: CurrentFilter
    var isFiltered: Bool
    
    @State private var selectedMonth: Date = Date()
    @State private var selectedYear: Date = Date()
    
    @State private var showMonthPickerSheet = false
    @State private var showYearPickerSheet = false
    
    
    @State private var showDialog = false
    
    @State private var showDialogFilter = false
    @State private var showDatePicker = false
    
    private let calendar = Calendar.current
    
    var showSalesDialogFilter: () -> Void
    
    var earningsLabel: String {
        switch currentFilter {
        
        case .month: return String(localized: "Hours of the month")
        case .year: return String(localized: "Hours of the year")
        }
    }
    
    var periodText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        
        switch currentFilter {
        
        case .month:
            formatter.setLocalizedDateFormatFromTemplate("MMyyyy")
            return formatter.string(from: selectedMonth)
        case .year:
            formatter.dateFormat = "yyyy"
            return formatter.string(from: selectedYear)
        }
    }
    
    var onNavigate: (Routes) -> Void
    
    var body: some View {
        VStack {
            
            ZStack {
                
                Text(minutesToHours(minutes: total))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(.colorBlue)
                
                // Label à esquerda
                HStack {
                    Text(earningsLabel)
                        .font(.footnote)
                        .foregroundColor(.primary)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .padding([.horizontal])
            
            
            ZStack {
                
                HStack {
                    Spacer()
                    if (currentFilter == .month || currentFilter == .year) {
                        Button {
                            changePeriod(value: -1)
                        }
                        label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.primary)
                                .padding(.horizontal)
                        }
                        .foregroundStyle(.secondary)
                    }
                    
                    Text(periodText)
                        
                        //.opacity(0.6)
                        .multilineTextAlignment(.center)
                        .onTapGesture {
                            if currentFilter == .month {
                                showMonthPickerSheet = true
                            } else if currentFilter == .year {
                                showYearPickerSheet = true
                            }
                        }
                        
                    if (currentFilter == .month || currentFilter == .year) {
                        Button {
                            changePeriod(value: 1)
                        }
                        label: {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.primary)
                                .padding(.horizontal)
                        }
                        .foregroundStyle(.secondary)
                    }
                    
                   
                    Spacer()
                    
                }
                

                HStack {
                    
                    Spacer()
                    
                    
                    
                    
                    
                    Button {
                        showDialogFilter = true
                        
                    } label: {
                        Image(systemName: "calendar")
                            .imageScale(.medium)
                    }
                    .padding(.trailing)
                    .foregroundStyle(.primary)
                }
                Spacer()
            }
            .padding(.vertical, 4)
            
        }
        .alert("Select a period", isPresented: $showDialogFilter) {
            
            
            
            Button("Month") {
                currentFilter = .month
            }
            
            Button("Year") {
                currentFilter = .year
            }
            
            Button("Cancel", role: .cancel) {
                
            }
            
        }
        
        .onChange(of: currentFilter) { filter in
            
            switch (filter) {
            
            case .month:
                let components = calendar.dateComponents([.year, .month], from: selectedMonth)
                if let start = calendar.date(from: components),
                   let range = calendar.range(of: .day, in: .month, for: start) {
                    let end = calendar.date(byAdding: .day, value: range.count - 1, to: start)!
                    firstDate = start.startOfDay(using: calendar)
                    endDate = end.endOfDay(using: calendar)
                }
                
                
            
            case .year:
                let components = calendar.dateComponents([.year], from: selectedYear)
                if let start = calendar.date(from: components),
                   let range = calendar.range(of: .day, in: .year, for: start) {
                    let end = calendar.date(byAdding: .day, value: range.count - 1, to: start)!
                    firstDate = start.startOfDay(using: calendar)
                    endDate = end.endOfDay(using: calendar)
                }
            }
        }
        
        
        
        
        
        .sheet(isPresented: $showMonthPickerSheet) {
            NavigationView {
                VStack {
                    MonthYearPicker(date: $selectedMonth) { newMonth in
                        let components = calendar.dateComponents([.year, .month], from: newMonth)
                        if let start = calendar.date(from: components),
                           let range = calendar.range(of: .day, in: .month, for: start) {
                            let end = calendar.date(byAdding: .day, value: range.count - 1, to: start)!
                            firstDate = start.startOfDay(using: calendar)
                            endDate = end.endOfDay(using: calendar)
                        }
                    }
                    .frame(height: 180)
                    Spacer()
                }
                .navigationTitle("Choose a month")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            showMonthPickerSheet = false
                        }
                        .foregroundStyle(.white)
                    }
                }
            }
        }
        .sheet(isPresented: $showYearPickerSheet) {
            NavigationView {
                VStack {
                    MonthYearPicker(date: $selectedYear) { newYear in
                        let components = calendar.dateComponents([.year], from: newYear)
                        if let start = calendar.date(from: components),
                           let range = calendar.range(of: .day, in: .year, for: start) {
                            let end = calendar.date(byAdding: .day, value: range.count - 1, to: start)!
                            firstDate = start.startOfDay(using: calendar)
                            endDate = end.endOfDay(using: calendar)
                        }
                    }
                    .frame(height: 180)
                    Spacer()
                }
                .navigationTitle("Choose a year")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            showYearPickerSheet = false
                        }
                        .foregroundStyle(.white)
                    }
                }
            }
        }
    }
    
    func changePeriod(value: Int) {
        if (currentFilter == .month) {
            selectedMonth = Calendar.current.date(byAdding: .month, value: value, to: selectedMonth) ?? Date()
            let components = calendar.dateComponents([.year, .month], from: selectedMonth)
            if let start = calendar.date(from: components),
               let range = calendar.range(of: .day, in: .month, for: start) {
                let end = calendar.date(byAdding: .day, value: range.count - 1, to: start)!
                firstDate = start.startOfDay(using: calendar)
                endDate = end.endOfDay(using: calendar)
            }
        } else if (currentFilter == .year) {
            selectedYear = Calendar.current.date(byAdding: .year, value: value, to: selectedYear) ?? Date()
            let components = calendar.dateComponents([.year], from: selectedYear)
            if let start = calendar.date(from: components),
               let range = calendar.range(of: .day, in: .year, for: start) {
                let end = calendar.date(byAdding: .day, value: range.count - 1, to: start)!
                firstDate = start.startOfDay(using: calendar)
                endDate = end.endOfDay(using: calendar)
            }
        }
    }
    
    
}


#Preview {
    //DashboardHeader()
}
