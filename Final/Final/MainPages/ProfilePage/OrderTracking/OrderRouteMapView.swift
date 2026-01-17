//
//  OrderRouteMapView.swift
//  Final
//
//  Created by nika kovziridze on 17.01.26.
//


import SwiftUI
import MapKit

struct OrderRouteMapView: UIViewRepresentable {

    let destination: CLLocationCoordinate2D
    let courier: CLLocationCoordinate2D
    let route: MKRoute?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = false
        mapView.pointOfInterestFilter = .excludingAll
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)

        let destinationPin = MKPointAnnotation()
        destinationPin.coordinate = destination
        destinationPin.title = "Delivery Address"
        mapView.addAnnotation(destinationPin)

        let courierPin = MKPointAnnotation()
        courierPin.coordinate = courier
        courierPin.title = "Courier"
        mapView.addAnnotation(courierPin)

        if let route = route {
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 80, left: 40, bottom: 80, right: 40),
                animated: true
            )
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {

        func mapView(
            _ mapView: MKMapView,
            rendererFor overlay: MKOverlay
        ) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            renderer.lineCap = .round
            return renderer
        }
    }
}
