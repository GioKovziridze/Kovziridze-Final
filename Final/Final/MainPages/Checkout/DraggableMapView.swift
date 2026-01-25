//
//  DraggableMapView.swift
//  Final
//
//  Created by nika kovziridze on 16.01.26.
//


import SwiftUI
import MapKit

let cityCoordinates: [String: CLLocationCoordinate2D] = [
    "Tbilisi": CLLocationCoordinate2D(latitude: 41.7151, longitude: 44.8271),
    "Batumi": CLLocationCoordinate2D(latitude: 41.6168, longitude: 41.6367),
    "Kutaisi": CLLocationCoordinate2D(latitude: 42.2679, longitude: 42.6946),
    "Rustavi": CLLocationCoordinate2D(latitude: 41.5495, longitude: 45.0060),

    "New York": CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
    "Tel-Aviv": CLLocationCoordinate2D(latitude: 32.0853, longitude: 34.7818),
    "Milan": CLLocationCoordinate2D(latitude: 45.4642, longitude: 9.1900),
    "Berlin": CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050),
    "Beijing": CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074),
    "Rio": CLLocationCoordinate2D(latitude: -22.9068, longitude: -43.1729),
    "Paris": CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
    "Amsterdam": CLLocationCoordinate2D(latitude: 52.3676, longitude: 4.9041),
    "Madrid": CLLocationCoordinate2D(latitude: 40.4168, longitude: -3.7038)
]

struct DraggableMapView: UIViewRepresentable {
    @Binding var selectedAddress: Address?
    let city: String
    
    // Default region: New York
    var initialRegion: MKCoordinateRegion {
    let coordinate = cityCoordinates[city]
    ?? cityCoordinates["New York"]!

    return MKCoordinateRegion(
    center: coordinate,
    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    }
    
    private let accentGreen = UIColor(red: 0.45, green: 0.78, blue: 0.62, alpha: 1.0)
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.setRegion(initialRegion, animated: false)
        mapView.delegate = context.coordinator
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.mapTapped(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        let config = MKHybridMapConfiguration(elevationStyle: .realistic)
        mapView.preferredConfiguration = config
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        if let address = selectedAddress {
            let annotation = MKPointAnnotation()
            annotation.coordinate = address.coordinate
            uiView.addAnnotation(annotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: DraggableMapView
        
        init(_ parent: DraggableMapView) {
            self.parent = parent
        }
        
        @objc func mapTapped(_ sender: UITapGestureRecognizer) {
            guard let mapView = sender.view as? MKMapView else { return }
            let point = sender.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

            parent.selectedAddress = Address(coordinate: coordinate, addressLine: "")
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "pin"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if view == nil {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view?.canShowCallout = false
                view?.isDraggable = true
                (view as? MKPinAnnotationView)?.pinTintColor = .red
            } else {
                view?.annotation = annotation
            }
            
            return view
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                     didChange newState: MKAnnotationView.DragState,
                     fromOldState oldState: MKAnnotationView.DragState) {
            if newState == .ending {
                if let coordinate = view.annotation?.coordinate {
                    parent.selectedAddress?.latitude = coordinate.latitude
                    parent.selectedAddress?.longitude = coordinate.longitude
                }
            }
        }
    }
}
