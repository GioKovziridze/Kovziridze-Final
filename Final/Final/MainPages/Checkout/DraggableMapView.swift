//
//  DraggableMapView.swift
//  Final
//
//  Created by nika kovziridze on 16.01.26.
//


import SwiftUI
import MapKit

struct DraggableMapView: UIViewRepresentable {
    @Binding var selectedAddress: Address?
    
    // Default region: Tbilisi
    var initialRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.7151, longitude: 44.8271),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
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
