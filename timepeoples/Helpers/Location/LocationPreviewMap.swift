
import SwiftUI
import MapKit

struct LocationPreviewMap: UIViewRepresentable {

    let coordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.isUserInteractionEnabled = false
        return map
    }

    func updateUIView(_ map: MKMapView, context: Context) {

        // Remove pins antigos
        map.removeAnnotations(map.annotations)

        // Novo pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        map.addAnnotation(annotation)

        // Atualiza região
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )

        map.setRegion(region, animated: true)
    }
}

