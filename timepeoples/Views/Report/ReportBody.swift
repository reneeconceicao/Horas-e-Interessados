//
//  ReportBodyView.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 07/04/25.
//

import SwiftUI


struct ReportBody: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @Binding var isMonthReport: Bool
    
    @Binding var showStudiesDialog: Bool
    
    @Binding var studiesNumber: String
    
    @State var totalValue: Double = 0.0
    
    @State var totalProfitValue: Double = 0.0
    
    @State var totalExpenseValue: Double = 0.0
    
    @State var totalPendingValue: Double = 0.0
    
    @State var totalHomeCare: Int = 0
    @State var totalBeautySalon: Int = 0
    
    
    
    @Binding var reportTextBody: String
    
   
    
    
    @Binding var words: [MyDay]
    
    
    
    var body: some View {
        
            VStack {
                
                VStack(spacing: 6) {
                    Group {
                        HStack {
                            Text("Hours")
                                .font(.headline.bold())
                                .opacity(1)
                            
                            
                            Spacer()
                        }
                        
                        
                        
                        HStack {
                            Text("Total hours")
                                .font(.subheadline.bold())
                                .opacity(1)
                            Spacer()
                            Text(minutesToHours(minutes: totalValue))
                                .font(.subheadline.bold())
                                .opacity(1)
                        }
                        .padding([.leading, .bottom])
                    }
                    
                    if (isMonthReport) {
                        Group {
                            HStack {
                                Text("Studies")
                                    .font(.headline)
                                    .opacity(1)
                                //.padding([.bottom])
                                Spacer()
                            }
                            HStack {
                                
                                Text("Total studies")
                                    .font(.subheadline.bold())
                                    .opacity(1)
                                    .onTapGesture {
                                        showStudiesDialog = true
                                    }
                                Button {
                                    showStudiesDialog = true
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                }
                                Spacer()
                                Text(studiesNumber)
                                    .font(.subheadline.bold())
                                    .opacity(1)
                                    .onTapGesture {
                                        showStudiesDialog = true
                                    }
                            }
                            .padding([.leading])
                        }
                    }
                }
            
           
        }
        .onChange(of: isMonthReport) { newValue in
            reportTextBody = ""
            updateReportText()
        }
        .onChange(of: words) { newValue in
            reportTextBody = ""
            
            let minutes = words.reduce(0, {result, word in result + word.minutes})
            let hours = (words.reduce(0, {result, word in result + word.hours})) * 60
            totalValue = minutes + hours
            
            updateReportText()
            
        }
        .onAppear {
            let minutes = words.reduce(0, {result, word in result + word.minutes})
            let hours = (words.reduce(0, {result, word in result + word.hours})) * 60
            totalValue = minutes + hours
            updateReportText()
        }

        
    }
    
    func updateReportText(){
        
        reportTextBody = String(localized: "Hours: \(minutesToHours(minutes: totalValue))")
        reportTextBody.append("\n\n")
        
        if (isMonthReport) {
            reportTextBody.append(String(localized: "Studies: \(studiesNumber)"))
            reportTextBody.append("\n\n")
        }
        
        print("Updated")
    }
    
    
    
}

#Preview {
    //ReportBodyView(onShare: {})
}

