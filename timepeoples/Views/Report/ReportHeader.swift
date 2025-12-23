//
//  Periodo.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 06/04/25.
//


import SwiftUI

enum PeriodReportSummary: LocalizedStringKey, CaseIterable {
    case monthly = "Monthly"
    case yearly = "Yearly"
}

struct ReportHeader: View {
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding var isMonthReport: Bool
    @Binding var reportTextPeriod: String
    @Binding var startDate: Date
    @Binding var endDate: Date

    @State private var selectedPeriod: PeriodReportSummary = .monthly
    @State private var selectedDayFirst: Date = Date()
    @State private var selectedDayEnd: Date = Date()
    @State private var selectedMonth: Date = Date()
    @State private var selectedYear: Date = Date()

    @State private var showDayFirstPickerSheet = false
    @State private var showDayEndPickerSheet = false
    @State private var showMonthPickerSheet = false
    @State private var showYearPickerSheet = false

    let calendar = Calendar.current


    var periodText: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale.current

        switch selectedPeriod {
        case .monthly:
            //formatter.dateFormat = "MMMM yyyy"
            formatter.setLocalizedDateFormatFromTemplate("MMyyyy")
            return [formatter.string(from: selectedMonth)]
        case .yearly:
            formatter.dateFormat = "yyyy"
            return [formatter.string(from: selectedYear)]
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Picker("", selection: $selectedPeriod) {
                ForEach(PeriodReportSummary.allCases, id: \.self) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            //.padding(.horizontal)

            
            HStack(alignment: .center, spacing: 0) {
                ZStack {
                    
                    HStack {
                        Spacer()
                        if (periodText.count == 1) {
                            Button {
                                changePeriod(value: -1)
                            }
                            label: {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal)
                            }
                            .foregroundStyle(.primary)
                            
                            Text(periodText[0])
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .onTapGesture {
                                    if selectedPeriod == .monthly {
                                        showMonthPickerSheet = true
                                    } else if selectedPeriod == .yearly {
                                        showYearPickerSheet = true
                                    }
                    
                                }
                                .onAppear {
                                    reportTextPeriod = periodText[0]
                                }
                            Button {
                                changePeriod(value: 1)
                            }
                            label: {
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal)
                            }
                            .foregroundStyle(.primary)
                            Spacer()
                        }
                    }
                    if selectedPeriod == .monthly {
                        HStack {
                            Spacer()
                            Button {
                                showMonthPickerSheet = true
                            } label: {
                                Image(systemName: "calendar")
                            }
                            .padding(.horizontal)
                            .foregroundStyle(.primary)
                        }
                    } else if selectedPeriod == .yearly {
                        HStack {
                            Spacer()
                            Button {
                                showYearPickerSheet = true
                            } label: {
                                Image(systemName: "calendar")
                            }
                            .padding(.horizontal)
                            .foregroundStyle(.primary)
                        }
                    }
                    Spacer()
                }
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(themeManager.currentTheme.primaryColor, lineWidth: 2)
            }
            .cornerRadius(8)
        }
        .onChange(of: periodText) { newText in
            if (newText.count == 1) {
                reportTextPeriod = periodText[0]
            } else {
                let text = "\(periodText[0])\n\(periodText[1])"
                reportTextPeriod = text
            }
        }
        .onAppear {
            //reportTextPeriod = "Apple"
        }
        .onChange(of: selectedPeriod) { _ in
            switch selectedPeriod {
            case .monthly:
                isMonthReport = true
                let components = calendar.dateComponents([.year, .month], from: selectedMonth)
                if let start = calendar.date(from: components),
                   let range = calendar.range(of: .day, in: .month, for: start) {
                    let end = calendar.date(byAdding: .day, value: range.count - 1, to: start)!
                    startDate = start.startOfDay(using: calendar)
                    endDate = end.endOfDay(using: calendar)
                }
            case .yearly:
                isMonthReport = false
                let components = calendar.dateComponents([.year], from: selectedYear)
                if let start = calendar.date(from: components),
                   let range = calendar.range(of: .day, in: .year, for: start) {
                    let end = calendar.date(byAdding: .day, value: range.count - 1, to: start)!
                    startDate = start.startOfDay(using: calendar)
                    endDate = end.endOfDay(using: calendar)
                }
            }
        
            
        }
        .sheet(isPresented: $showDayFirstPickerSheet) {
            NavigationView {
                VStack {
                    DatePicker("Choose a day", selection: $selectedDayFirst, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                    Spacer()
                }
                .navigationTitle("Choose a day")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            startDate = selectedDayFirst.startOfDay(using: calendar)
                            showDayFirstPickerSheet = false
                        }
                        .foregroundStyle(.white)
                    }
                }
            }
        }
        
        .sheet(isPresented: $showDayEndPickerSheet) {
            NavigationView {
                VStack {
                    DatePicker("Choose a day", selection: $selectedDayEnd, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                    Spacer()
                }
                .navigationTitle("Choose a day")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            endDate = selectedDayEnd.endOfDay(using: calendar)
                            showDayEndPickerSheet = false
                        }
                        .foregroundStyle(.white)
                    }
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
                            startDate = start.startOfDay(using: calendar)
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
                            startDate = start.startOfDay(using: calendar)
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
        if (selectedPeriod == .monthly) {
            selectedMonth = Calendar.current.date(byAdding: .month, value: value, to: selectedMonth) ?? Date()
            let components = calendar.dateComponents([.year, .month], from: selectedMonth)
            if let start = calendar.date(from: components),
               let range = calendar.range(of: .day, in: .month, for: start) {
                let end = calendar.date(byAdding: .day, value: range.count - 1, to: start)!
                startDate = start.startOfDay(using: calendar)
                endDate = end.endOfDay(using: calendar)
            }
        } else if (selectedPeriod == .yearly) {
            selectedYear = Calendar.current.date(byAdding: .year, value: value, to: selectedYear) ?? Date()
            let components = calendar.dateComponents([.year], from: selectedYear)
            if let start = calendar.date(from: components),
               let range = calendar.range(of: .day, in: .year, for: start) {
                let end = calendar.date(byAdding: .day, value: range.count - 1, to: start)!
                startDate = start.startOfDay(using: calendar)
                endDate = end.endOfDay(using: calendar)
            }
        }
    }
}
