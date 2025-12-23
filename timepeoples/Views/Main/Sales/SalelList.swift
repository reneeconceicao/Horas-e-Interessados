//
//  WordListView.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 06/04/25.
//

import SwiftUI
import CoreData

struct SaleList: View {
    
    
    
    @Environment(\.managedObjectContext) private var modelContext
    
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var currentSale: MyDay?
    @State private var deleteConfirmation = false
    @State private var showDialog = false
    @State var search: String = ""
    @State private var phoneServiceError = false
    @State private var phoneEmptyError = false
    @State private var paidOutConfirmation = false
    @State private var paidOutValue = 0.0
    @State private var isSharing = false
    @State private var shareText = ""
    
    @State private var shareTextSale: String = ""
    @State private var showShareSheetPDF = false
    @State private var pdfURL: URL?
    
    
    @Binding var words: [MyDay]
    let onNavigate: (Routes) -> Void
    let onItemUpdated: () -> Void
    private var filteredWords: [MyDay]
    
    init(words: Binding<[MyDay]>, selectedOptionSale: Int, isCheckedPendingSales: Bool, onNavigate: @escaping (Routes) -> Void, onItemUpdated: @escaping () -> Void) {
        self._words = words
        self.onNavigate = onNavigate
        self.onItemUpdated = onItemUpdated
        
        filteredWords = words.wrappedValue
        
//        if (isCheckedPendingSales) {
//            if (selectedOptionSale == 0) {
//                self.filteredWords = words.wrappedValue.filter { $0.price > $0.received }.sorted { $0.wordDate > $1.wordDate }
//            }
//            if (selectedOptionSale == 1) {
//                self.filteredWords = words.wrappedValue.filter { $0.price > $0.received }.sorted { $0.wordDate < $1.wordDate }
//            }
//            if (selectedOptionSale == 2) {
//                self.filteredWords = words.wrappedValue.filter { $0.price > $0.received }.sorted { $0.wordClientName < $1.wordClientName }
//            }
//            
//            if (selectedOptionSale == 3) {
//                self.filteredWords = words.wrappedValue.filter { $0.price > $0.received }.sorted { $0.price > $1.price }
//            }
//            if (selectedOptionSale == 4) {
//                self.filteredWords = words.wrappedValue.filter { $0.price > $0.received }.sorted { ($0.price - $0.received) > ($1.price - $1.received) }
//            }
//        } else {
//            if (selectedOptionSale == 0) {
//                self.filteredWords = words.wrappedValue.sorted { $0.wordDate > $1.wordDate }
//            }
//            if (selectedOptionSale == 1) {
//                self.filteredWords = words.wrappedValue.sorted { $0.wordDate < $1.wordDate }
//            }
//            if (selectedOptionSale == 2) {
//                self.filteredWords = words.wrappedValue.sorted { $0.wordClientName < $1.wordClientName }
//            }
//            
//            if (selectedOptionSale == 3) {
//                self.filteredWords = words.wrappedValue.sorted { $0.price > $1.price }
//            }
//            if (selectedOptionSale == 4) {
//                self.filteredWords = words.wrappedValue.sorted { ($0.price - $0.received) > ($1.price - $1.received) }
//            }
//        }
    }
    
    var body: some View {
        
        VStack {
            Divider()
                .frame(height: 1.5)
                .background(themeManager.currentTheme.primaryColor)
                .padding([.bottom], 0)
            Group {
                if filteredWords.isEmpty {
                    
                    VStack(alignment: .center) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("No hour records found")
                            .font(.title)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding([.leading, .trailing])
                    }
                    .frame(maxHeight: .infinity)
                    .onTapGesture {
                        onNavigate(Routes.newWord)
                    }
                } else {
                    
                    List(filteredWords) { sale in
                        NavigationLink() {
                            NewSaleView(updateWord: sale)
                        }label: {
                            SaleRow(word: sale, onMenuTap: {
                                currentSale = sale
                                showDialog = true
                            })
                            .contentShape(Rectangle())
                            .onTapGesture {
                                currentSale = sale
                                showDialog = true
                            }
                           
                        }
                        //.listRowBackground(rowColor(word: sale))
                        .padding([.bottom],6)
                        .listRowBackground(
                            EmptyView()
                                .cardBackgroundClear()
                                .padding([.bottom], 6)
                        )
                        
                        .swipeActions(edge: .trailing) {
                            Button() {
                                currentSale = sale
                                deleteConfirmation = true
                            } label: {
                                Image(systemName: "trash")
                                    .imageScale(.large)
                                    .tint(.red)
                            }
                        }
                        
                        .listRowSeparator(.hidden)
                    }
                    .safeAreaInset(edge: .top) {
                        Color.clear.frame(height: 0.1)
                    }
                    .applyHiddenScrollIndicators()
                    .listStyle(PlainListStyle())
                    .alert("Do you really want to delete?", isPresented: $deleteConfirmation) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            
                            if let sale = currentSale {
                                withAnimation {
                                    DataManager()
                                        .deleteWord(modelContext: modelContext, word: sale)
                                    if let i = words.firstIndex(where: { sale.id == $0.id }) {
                                        words.remove(at: i)
                                    }
                                    onItemUpdated()
                                }
                            }
                        }
                    } message: {
                        Text("This action cannot be undone.")
                    }
                    .onChange(of: Array(words)) { newValue in
                        print("CHANGED!!!")
                    }
                    .toast(
                        isPresented: $phoneEmptyError,
                        duration: 3.5,
                        message: String(localized: "Phone not informed")
                    )
                    .toast(
                        isPresented: $phoneServiceError,
                        duration: 3.5,
                        message: String(localized: "Telephone service currently unavailable. Verify your device settings.")
                    )
                    .sheet(isPresented: $isSharing) {
                        let text = shareText
                        ShareSheet(activityItems: [text])
                    }
                    .sheet(isPresented: $showShareSheetPDF) {
                        if let pdfURL {
                            ShareFileSheet(activityItems: [pdfURL], isPresented: $showShareSheetPDF)
                        }
                    }
                    .alert(String(localized: "Select a option"), isPresented: $showDialog) {
                        
                        
                        
                        Button("Open") {
                            if let sale = currentSale {
                                onNavigate(Routes.edit(word: sale))
                            }
                            
                        }
                        
                        Button("Delete", role: .destructive) {
                            deleteConfirmation = true
                        }
                        
                        
                    }
                    
                    
                }
            }
        }
    }
    
    private func rowColor(word: MyDay) -> Color {
        
        let weekDay = dayNumberOfWeek(from: word.wordDate)
        switch weekDay {
        case 1:
            return Color(.colorSunday)
        case 2:
            return Color(.colorMonday)
        case 3:
            return Color(.colorTuesday)
        case 4:
            return Color(.colorWednesday)
        case 5:
            return Color(.colorThursday)
        case 6:
            return Color(.colorFriday)
        case 7:
            return Color(.colorSaturday)
        default:
            return Color(.colorPurple)
        }
    }
    
}



#Preview {
    //SaleList(search: "", onNavigate: {_ in })
}
