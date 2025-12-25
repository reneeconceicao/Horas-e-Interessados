//
//  NewWordView.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 02/04/25.
//

import SwiftUI
import CoreData
import MapKit

struct NewCustomerView: View {
    
    enum Field: Int, CaseIterable {
        case name
        case phone
        case notes
    }
    
//    @EnvironmentObject var themeManager : ThemeManager
    @StateObject private var locationManager = LocationManager()
    
    @AppStorage(PreferencesKeys.launchCounter.key) private var launchCounter: Int = PreferencesKeys.launchCounter.defaultValue
    
    @AppStorage(PreferencesKeys.isPremium.key) private var isPremium: Bool = PreferencesKeys.isPremium.defaultValue
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) var dismiss
    @State private var client = ""
    @State private var phoneNumber = ""
    @State private var notes: String = ""
    @State private var showPicker = false
    @State private var showLocationPicker = false
    @State private var nameEmptyError = false
    @State private var showPermissionAlert = false
    @State private var updateAuthorization = false
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @StateObject private var themeManager = ThemeManager()
    @State private var showMap = false
    
    @FocusState private var fieldFocus: Field?
    
    var myCustomer: MyClient?
    
    var onUpdated: () -> Void
    
    init(updateClient: MyClient? = nil, onUpdated: @escaping () -> Void = {}){
        myCustomer = updateClient
        self.onUpdated = onUpdated
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                ScrollView(showsIndicators: false) {
                    VStack( alignment: .leading, spacing: 16) {
                        ZStack {
                            TextField("Name", text: $client)
                                .padding([.trailing])
                                .padding([.trailing])
                                .focused($fieldFocus, equals: .name)
                            Button {
                                showPicker = true
                            } label: {
                                Image(systemName: "magnifyingglass")
                                    .imageScale(.medium)
                                    .foregroundStyle(.red)
                                    .padding([.trailing], 4)
                                    .cornerRadius(8)
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        TextField("Phone", text: $phoneNumber)
                            .focused($fieldFocus, equals: .phone)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("Notes about this person (optional)")
                                //.foregroundStyle(themeManager.currentTheme.primaryColor)
                                .foregroundStyle(.primary)
                                .font(.subheadline.bold())
                            //.fontWeight(.bold)
                            TextEditor(text: $notes)
                                .focused($fieldFocus, equals: .notes)
                                .frame(minHeight: 80)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(fieldFocus == .notes ? themeManager.currentTheme.primaryColor : Color.gray.opacity(0.5), lineWidth: fieldFocus == .notes ? 1.5 : 1)
                                        
                                )
                                
                        }
                        .padding(.horizontal)
                        
                        Button {
                            
                            if (locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse) {
                                showMap = true
                            } else {
                                showPermissionAlert = true
                            }
                        } label: {
                            Text("Select location")
                        }
                        .padding()
                        
                        if (selectedCoordinate != nil) {
                            Button {
                                showMap = true
                            } label: {
                                LocationPreviewMap(
                                    coordinate: selectedCoordinate
                                    ?? locationManager.currentLocation
                                    ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
                                )
                                .frame(height: 160)
                            }
                            .padding(.horizontal)
                            
                            Button("Open in Maps") {
                                if let coordinates = selectedCoordinate {
                                    openInAppleMaps(latitude: coordinates.latitude, longitude: coordinates.longitude)
                                }
                                
                            }
                            .padding()
                        }
                        Spacer()
                        
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
                            Button("Save") {
                                
                                if (client.isEmpty) {
                                    nameEmptyError = true
                                    return
                                }
                                
                                
                                if let customer = myCustomer {
                                    updateClient(myClient: customer)
                                    dismiss()
                                } else {
                                    createNewCustomer()
                                    dismiss()
                                }
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
                
                
                locationManager.updateAuthorization()
                
                if let newClient = myCustomer {
                    client = newClient.wordName
                    phoneNumber = newClient.wordPhone
                    notes = newClient.wordNotes
                    if (!(newClient.latitude == 0 && newClient.longitude == 0)) {
                        selectedCoordinate = CLLocationCoordinate2DMake(newClient.latitude, newClient.longitude)
                    }
                }
                
                
            }
            .alert("We need location permission to open the map", isPresented: $showPermissionAlert){
                
                Button("Open Settings") {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url)
                }
                Button("Cancel", role: .cancel) {
                    
                }
            }
            .alert("Type name please", isPresented: $nameEmptyError){
                Button("OK") {
                    
                }
            }
            .sheet(isPresented: $showMap) {
                LocationPickerView(
                    initialCoordinate: selectedCoordinate,
                    userLocation: locationManager.currentLocation
                ) { newCoordinate in
                    // callback ao salvar
                    selectedCoordinate = newCoordinate
                }
            }
            //.padding([.top, .leading, .trailing])
            .sheet(isPresented: $showPicker) {
                ContactPicker(
                    onContactSelected: { name, phone in
                        client = name
                        phoneNumber = phone
                        showPicker = false
                    },
                    onCancel: {
                        showPicker = false
                    }
                )
            }
            
        }
        
    }
    
    func createNewCustomer() {
        let newClient = MyClient(context: context)
        newClient.id = UUID()
        
        newClient.clientName = client
        newClient.clientPhone = phoneNumber
        if let selectedCoordinate = selectedCoordinate {
            newClient.latitude = selectedCoordinate.latitude
            newClient.longitude = selectedCoordinate.longitude
        }
        newClient.clientNotes = notes
        
        
        Task {
            try withAnimation {
                try context.save()
            }
        }
        
    }
    
    func updateClient(myClient: MyClient) {
        
        myClient.clientName = client
        myClient.clientPhone = phoneNumber
        myClient.clientNotes = notes
        if let selectedCoordinate = selectedCoordinate {
            myClient.latitude = selectedCoordinate.latitude
            myClient.longitude = selectedCoordinate.longitude
        }
        
        
        Task {
            try withAnimation {
                try context.save()
                onUpdated()
            }
        }
        
        
    }
    
    

    func openInAppleMaps(latitude: Double, longitude: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)

        mapItem.name = "Local salvo"

        let options: [String: Any] = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: coordinate),
            MKLaunchOptionsMapSpanKey: NSValue(
                mkCoordinateSpan: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        ]

        mapItem.openInMaps(launchOptions: options)
    }

}


#Preview {
    NewCustomerView()
}
