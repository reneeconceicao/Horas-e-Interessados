//
//  LocationPickerView 2.swift
//  timepeoples
//
//  Created by Renêe Conceição on 15/12/25.
//
import SwiftUI
import MapKit

struct LocationPickerView: View {
    
    let initialCoordinate: CLLocationCoordinate2D?
    let userLocation: CLLocationCoordinate2D?
    
    var onSave: (CLLocationCoordinate2D) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    
    var body: some View {
        ZStack {
            MapViewRepresentable(
                selectedCoordinate: $selectedCoordinate,
                userLocation: initialCoordinate ?? userLocation
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Button {
                    if let coord = selectedCoordinate {
                        onSave(coord)
                        dismiss()
                    }
                } label: {
                    Text("Confirm")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                
                
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    
                }
                .padding(.bottom)
            }
        }
        .onAppear {
            // 🔑 LÓGICA CENTRAL
            if let initialCoordinate {
                selectedCoordinate = initialCoordinate
            } else if let userLocation {
                selectedCoordinate = userLocation
            }
        }
    }
}
