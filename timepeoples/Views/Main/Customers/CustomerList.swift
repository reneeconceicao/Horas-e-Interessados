//
//  WordListView.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 06/04/25.
//

import SwiftUI
import CoreData

struct CustomerList: View {
    
    
    
    @Environment(\.managedObjectContext) private var modelContext
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @AppStorage(PreferencesKeys.adsPendingProof.key) private var tipProofPremium: Bool = PreferencesKeys.adsPendingProof.defaultValue
    
    @AppStorage(PreferencesKeys.launchCounter.key) private var launchCounter: Int = PreferencesKeys.launchCounter.defaultValue
    
    @AppStorage(PreferencesKeys.isPremium.key) private var isPremium: Bool = PreferencesKeys.isPremium.defaultValue
    
    @State private var currentMaterial: MyClient?
    @State private var deleteConfirmation = false
    @State private var deleteError = false
    @State private var showDialog = false
    
    @State private var phoneServiceError = false
    @State private var phoneEmptyError = false
    
    @State private var isSharing = false
    @State private var shareText = ""
    
    @State private var showPremiumProof = false
    
    @State private var navigatePremium = false
    
    @State private var adLoading = false
    
    @State private var pdfURL: URL?
    
    @State private var noPendingSalesError = false
    
    @Binding var clients: [MyClient]
    @Binding var search: String
    let onNavigate: (Routes) -> Void
    let showCustomerDialogFilter: () -> Void
    var isFiltered: Bool
    private var computedClients: [MyClient]
    
    
    init(clients: Binding<[MyClient]>, search: Binding<String>, isFiltered: Bool, onNavigate: @escaping (Routes) -> Void, showCustomerDialogFilter: @escaping () -> Void) {
        self._clients = clients
        self._search = search
        self.isFiltered = isFiltered
        self.onNavigate = onNavigate
        self.showCustomerDialogFilter = showCustomerDialogFilter
        computedClients = clients.wrappedValue
    }
    
    var body: some View {
        HStack {
            
            SearchBar(text: $search, placeholder: String( localized: "Search people"))
                .padding([.horizontal], 8)
            
            
        }
        .padding([.top], 6)
        Group {
            
            if computedClients.isEmpty {
                
                VStack(alignment: .center) {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No interested found")
                        .font(.title)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing])
                }
                .frame(maxHeight: .infinity)
                .onTapGesture {
                    onNavigate(Routes.newCustomer)
                }
            } else {
                
                List(computedClients) { client in
                    
                    NavigationLink() {
                        NewCustomerView(updateClient: client)
                    }label: {
                        CustomerRow(customer: client, onMenuTap: {
                            currentMaterial = client
                            showDialog = true
                        })
                        .contentShape(Rectangle())
                        
                    }
                    .padding([.bottom],6)
                    .listRowBackground(
                        EmptyView()
                            .cardBackgroundClear()
                            .padding([.bottom], 6)
                    )
                    .swipeActions(edge: .trailing) {
                        
                        Button() {
                            currentMaterial = client
                            deleteConfirmation = true
                        } label: {
                            Image(systemName: "trash")
                                .imageScale(.large)
                                .tint(.red)
                        }
                        //.padding(.vertical, 5)
                        
                        Button() {
                            currentMaterial = client
                            showDialog = true
                        } label: {
                            Image(systemName: "ellipsis")
                                .imageScale(.large)
                                .tint(Color.primary.opacity(0.6))
                        }
                        
                    }
                    .listRowSeparator(.hidden)
                    

                    
                }
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 2)
                }
                .applyHiddenScrollIndicators()
                .listStyle(PlainListStyle())
                .alert("Do you really want to delete?", isPresented: $deleteConfirmation) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        if let client = currentMaterial {
                            withAnimation {
                                DataManager()
                                    .deleteClient(
                                        modelContext: modelContext,
                                        client: client
                                    )
                                if let i = clients.firstIndex(where: { client.id == $0.id }) {
                                    clients.remove(at: i)
                                }
                            }
                        }
                    }
                } message: {
                    Text("This action cannot be undone.")
                }
                
                .alert(currentMaterial?.wordName ?? "", isPresented: $showDialog) {
                    
                    
                    
                    
                    Button("Edit data") {
                        if let client = currentMaterial {
                            onNavigate(.editCustomer(client: client))
                        }
                    }
                    
                    
                    Button("Call...") {
                        if let client = currentMaterial {
                            if client.wordPhone.isEmpty {
                                phoneEmptyError = true
                                return
                            }
                            PhoneServices().callNumber(client.wordPhone) {
                                phoneServiceError = true
                            }
                        }
                    }
                    
                    
                    Button("Share") {
                        if let client = currentMaterial {
                            let shareHelper = ShareHelper()
                            shareText = shareHelper.shareClient(client: client)
                            isSharing = true
                        }
                    }
                    
                    Button("Delete", role: .destructive) {
                        deleteConfirmation = true
                    }
                    
                    
                }
                .onChange(of: computedClients) { newValue in
                    print("CHANGED!!!")
                }
                .toast(
                    isPresented: $deleteError,
                    duration: 3.5,
                    message: String(localized: "Error on delete")
                )
                .toast(
                    isPresented: $adLoading,
                    duration: 3.5,
                    message: String(localized: "The ad is loading, please try again soon")
                )
                .toast(
                    isPresented: $phoneServiceError,
                    duration: 3.5,
                    message: String(localized: "Telephone service currently unavailable. Verify your device settings.")
                )
                .toast(
                    isPresented: $phoneEmptyError,
                    duration: 3.5,
                    message: String(localized: "Phone not informed")
                )
                .toast(
                    isPresented: $noPendingSalesError,
                    duration: 3.5,
                    message: String(localized: "No pending sales found for this customer")
                )
                .sheet(isPresented: $isSharing) {
                    ShareSheet(activityItems: [shareText])
                }
            }
            
            
            
        }
        
    }
    
    
    
   
    
}



#Preview {
    //CustomerList(search: "", onNavigate: {_ in })
}
