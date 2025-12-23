//
//  ReportView.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 07/04/25.
//

import SwiftUI
import CoreData

struct ReportView: View {
    
    enum DialogField: Int, CaseIterable {
        case studiesNumber
    }
    
    @Environment(\.managedObjectContext) private var modelContext
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var isSharing = false
    
    @State private var firstDate: Date = firstDayOfCurrentMonth()
    
    @State private var endDate: Date = lastDayOfCurrentMonth()
    
    @State private var reportTextPeriod = ""
    
    @State private var reportTextBody = ""
    
    @State private var isMonthReport = true
    
    @State private var words: [MyDay] = []
    
    @State private var currentStudies = "0"
    
    @State var showStudiesDialog = false
    
    @State private var studiesNumber = ""
    
    @State private var currentStudiesRecord: MyStudies? = nil
    
    @FocusState private var fieldFocus: DialogField?
    
    
    var body: some View {
        
        //GeometryReader {geometry in
        ZStack {
            VStack {
                ReportHeader(
                    isMonthReport: $isMonthReport,
                    reportTextPeriod: $reportTextPeriod,
                    startDate: $firstDate,
                    endDate: $endDate
                )
                .padding([.trailing, .leading, .top])
                ScrollView {
                    VStack {
                        ReportBody(
                            isMonthReport: $isMonthReport,
                            showStudiesDialog: $showStudiesDialog,
                            studiesNumber: $currentStudies,
                            reportTextBody: $reportTextBody,
                            words: $words,
                        )
                        .padding([.trailing, .leading])
                        .padding([.top], 4)
                        
                        Button("Share") {
                            isSharing = true
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(themeManager.currentTheme.primaryColor)
                        .padding([.top], 36)
                        
                        
                    }
                    
                }
                Spacer()
                
                
            }
            if showStudiesDialog {
                
                
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showStudiesDialog = false
                        fieldFocus = .none
                    }
                
                VStack(spacing: 16) {
                    
                    Text("Total studies for the month")
                        .font(.headline)
                    
                    TextField("Number of studies", text: $studiesNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .focused($fieldFocus, equals: .studiesNumber)
                        .numbersOnly($studiesNumber, includeDecimal: false)
                    
                    HStack() {
                        Spacer()
                        Button("Cancel", role: .destructive) {
                            
                            showStudiesDialog = false
                            
                            fieldFocus = .none
                        }
                        Spacer()
                        Button("Save") {
                            
                            updateStudies()
                            
                            showStudiesDialog = false
                            
                            fieldFocus = .none
                            
                        }
                        .foregroundColor(.blue)
                        Spacer()
                    }
                }
                .onAppear {
                    
                    fieldFocus = .studiesNumber
                }
                .padding()
                .background(.background)
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(.horizontal, 40)
            }
        }
        .applyHiddenScrollIndicators()
        .onChange(of: reportTextBody) { newValue in
            //print("reportText new value : \(newValue)")
        }
        .onAppear {
            fetchWords()
            fetchStudies()
        }
        .onChange(of: firstDate) { _ in
            DispatchQueue.main.async {
                fetchWords()
                fetchStudies()
            }
        }
        .onChange(of: endDate) { _ in
            DispatchQueue.main.async {
                fetchWords()
                fetchStudies()
            }
            
        }
        .onChange(of: words){ _ in
            print(words.count)
        }
        
        .sheet(isPresented: $isSharing) {
            let text = String(localized: "Report \n\n\(reportTextPeriod) \n\n\(reportTextBody)")
            ShareSheet(activityItems: [text])
            
        }
        //.padding([.trailing, .leading, .top])
        .navigationTitle("Reporting")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func fetchWords() {
        let request = MyDay.fetchRequest()
        
        let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", firstDate as NSDate, endDate as NSDate)
        
        let sort = [NSSortDescriptor(key: "date", ascending: false)]
        
        request.sortDescriptors = sort
        
        request.predicate = predicate
        
        
        do {
            words = try modelContext.fetch(request)
        } catch {
            print("Error on fetch")
        }
        
    }
    
    private func updateStudies() {
        if let currentRecord = currentStudiesRecord {
            let number = studiesNumber.isEmpty ? "0" : studiesNumber
            currentRecord.total = String(Int(number) ?? 0)
            Task {
                try withAnimation {
                    try modelContext.save()
                }
                await MainActor.run {
                    fetchStudies()
                }
            }
        } else {
            
            let newRecord = MyStudies(context: modelContext)
            newRecord.id = UUID()
            newRecord.date = firstDate
            let number = studiesNumber.isEmpty ? "0" : studiesNumber
            newRecord.total = String(Int(number) ?? 0)
            
            
            Task {
                
                try modelContext.save()
                
                await MainActor.run {
                    fetchStudies()
                }
            }
        }
    }
    
    private func fetchStudies() {
        
        let request = MyStudies.fetchRequest()
        
        let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", firstDate as NSDate, endDate as NSDate)
        
        
        request.predicate = predicate
        
        
        do {
            let first = try modelContext.fetch(request).first
            
            if let studie = first {
                studiesNumber = studie.studiesTotal
                currentStudies = studiesNumber
                currentStudiesRecord = studie
            } else {
                studiesNumber = "0"
                currentStudies = studiesNumber
                currentStudiesRecord = nil
            }
            
        } catch {
            print("Error on fetch")
        }
        
    }
    
    
    
}


#Preview {
//    ReportView()
//        .environment(\.managedObjectContext, WordContainer().persistentContainer.viewContext)
    
}
