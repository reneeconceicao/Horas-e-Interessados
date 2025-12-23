//
//  NewWordView.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 02/04/25.
//

import SwiftUI
import CoreData
import GoogleMobileAds

struct NewSaleView: View {
    
    enum Field: Int, CaseIterable {
        case hours
        case minutes
        case notes
    }
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Environment(\.managedObjectContext) private var modelContext
    
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var date: Date = Date.now
    @State private var hours: String = ""
    @State private var minutes: String = ""
    @State private var notes: String = ""
    
    @State var myWord: MyDay?
    
    @FocusState private var fieldFocus: Field?
    
    var onSaleSaved: () -> Void
    
    init(updateWord: MyDay? = nil, onSaleSaved: @escaping () -> Void = {}){
        
        myWord = updateWord
        
        self.onSaleSaved = onSaleSaved
        
        
        
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 8) {
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            Text("Select date")
                                //.foregroundStyle(themeManager.currentTheme.primaryColor)
                                .foregroundStyle(.primary)
                                .font(.subheadline.bold())
                            
                            HStack {
                                Spacer()
                                DatePicker ("", selection: $date, displayedComponents: .date)
                                    .labelsHidden()
                                    .datePickerStyle(.compact)
                                Spacer()
                            }
                        }
                        .padding([.all], 8)
                        
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(themeManager.currentTheme.primaryColor, lineWidth: 2)
                        }
                        .cornerRadius(8)
                        .padding(.horizontal)
                        
                        
                        .padding(.top)
                        
                        
                        VStack(alignment: .leading) {
                            Text("Hours")
                                .foregroundStyle(.primary)
                                .font(.subheadline.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            TextEditor(text: $hours)
                                .focused($fieldFocus, equals: .hours)
                                .frame(minHeight: 36)
                                .frame(width: proxy.size.width * 0.3)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(fieldFocus == .hours ? themeManager.currentTheme.primaryColor : Color.gray.opacity(0.5), lineWidth: fieldFocus == .hours ? 1.5 : 1)
                                )
                                .keyboardType(.numberPad)
                                .numbersOnly($hours, includeDecimal: false)
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        
                        VStack(alignment: .leading) {
                            Text("Minutes")
                                
                                .foregroundStyle(.primary)
                                .font(.subheadline.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            TextEditor(text: $minutes)
                                .focused($fieldFocus, equals: .minutes)
                                .frame(minHeight: 36)
                                .frame(width: proxy.size.width * 0.3)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(fieldFocus == .minutes ? themeManager.currentTheme.primaryColor : Color.gray.opacity(0.5), lineWidth: fieldFocus == .minutes ? 1.5 : 1)
                                )
                                .keyboardType(.numberPad)
                                .numbersOnly($minutes, includeDecimal: false)
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)
                        

                        
                        VStack(alignment: .leading) {
                            Text("Details")
                                //.foregroundStyle(themeManager.currentTheme.primaryColor)
                                .foregroundStyle(.primary)
                                .font(.subheadline.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            TextEditor(text: $notes)
                                .focused($fieldFocus, equals: .notes)
                                .frame(minHeight: 36)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(fieldFocus == .notes ? themeManager.currentTheme.primaryColor : Color.gray.opacity(0.5), lineWidth: fieldFocus == .notes ? 1.5 : 1)
                                )
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        
                            
                        
                        
                        
                    }
                    .navigationTitle("Register")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                fieldFocus = .none
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                
                                if let word = myWord {
                                    
                                    updateWord(myWord: word)
                                    
                                    dismiss()
                                    
                                    
                                } else {
                                    createNewWord()
                                    dismiss()
                                }
                            } label: {
                                Text("Save")
                                
                            }
                            .foregroundStyle(.white)
                        }
                    }
                }
                .onTapGesture {
                    fieldFocus = .none
                }
            }
            
            
            .onAppear {
                
                    if let word = myWord {
                        date = word.wordDate
                        hours = String(Int(word.hours))
                        minutes = String(Int(word.minutes))
                        notes = word.wordNotes
                    }
            }
           
            
            
            
        }
        
    }
    
    
    func createNewWord(onCreate: @escaping () -> Void = {}) {
        let newWord = MyDay(context: context)
        newWord.id = UUID()
        newWord.date = date
        newWord.hours = Double(hours) ?? 0.0
        newWord.minutes = Double(minutes) ?? 0.0
        newWord.notes = notes
        
        
        Task {
            try withAnimation {
                try context.save()
                myWord = newWord
                onCreate()
            }
            await MainActor.run {
                onSaleSaved()
            }
        }
        
    }
    
    func updateWord(myWord: MyDay) {
        myWord.date = date
        myWord.hours = Double(hours) ?? 0.0
        myWord.minutes = Double(minutes) ?? 0.0
        myWord.notes = notes
        
        do {
            try context.save()
            print("SAVED!!!")
        } catch {
            print("ERROR ON SAVE")
        }

        onSaleSaved()
        
//
        
    }
    
    
    
}


#Preview {
    NewSaleView()
}


struct ManualTapEffect: ViewModifier {
    @GestureState private var isPressed = false
    @GestureState private var isDraging = false

    func body(content: Content) -> some View {
        content
            .background(isPressed && !isDraging ? Color.primary.opacity(0.2) : Color.clear)
            .animation(.easeInOut(duration: 0.2), value: isPressed && !isDraging)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in
                        state = true
                    }
                    .updating($isDraging) { value, state, _ in
                        if abs(value.translation.height) > 2 || abs(value.translation.width) > 2 {
                            state = true
                        }
                    }
            )
    }
}

extension View {
    func manualTapEffect() -> some View {
        self.modifier(ManualTapEffect())
    }
}


class ClientState: ObservableObject {
    @Published var tempClientName: String? = nil
    @Published var tempClient: MyClient? = nil
    @Published var isSelectingClient = false
}

class ServiceState: ObservableObject {
    @Published var isAddingServices = false
}
