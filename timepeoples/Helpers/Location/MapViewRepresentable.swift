//
//  MapViewRepresentable.swift
//  timepeoples
//
//  Created by Renêe Conceição on 15/12/25.
//


import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {

    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    let userLocation: CLLocationCoordinate2D?

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator as? any MKMapViewDelegate

        // 🔑 HABILITA INTERAÇÕES
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.isRotateEnabled = true
        map.isPitchEnabled = true

        map.showsUserLocation = true

        // 🔑 Gesture de toque SEM bloquear zoom
        let tap = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        tap.cancelsTouchesInView = false
        tap.delegate = context.coordinator
        map.addGestureRecognizer(tap)

        return map
    }

    func updateUIView(_ map: MKMapView, context: Context) {

        map.removeAnnotations(map.annotations)

        if let coord = selectedCoordinate ?? userLocation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coord
            map.addAnnotation(annotation)

            let region = MKCoordinateRegion(
                center: coord,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )

            map.setRegion(region, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {

        let parent: MapViewRepresentable

        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            let map = gesture.view as! MKMapView
            let point = gesture.location(in: map)
            let coordinate = map.convert(point, toCoordinateFrom: map)
            parent.selectedCoordinate = coordinate
        }

        // 🔑 PERMITE ZOOM + TAP AO MESMO TEMPO
        func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
        ) -> Bool {
            true
        }
    }
}
