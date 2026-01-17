//
//  OrderTrackingPage.swift
//  Final
//
//  Created by nika kovziridze on 17.01.26.
//

import SwiftUI
import MapKit

struct OrderTrackingPage: View {
    let order: Order

    @State private var courierCoordinate: CLLocationCoordinate2D
    @State private var currentStatus: String
    @State private var route: MKRoute?
    @State private var routeCoordinates: [CLLocationCoordinate2D] = []
    @State private var routeIndex = 0

    init(order: Order) {
        self.order = order
        _currentStatus = State(initialValue: order.status)
        
        _courierCoordinate = State(
            initialValue: CLLocationCoordinate2D(
                latitude: order.address.latitude + 0.01,
                longitude: order.address.longitude - 0.01
            )
        )
    }

    var body: some View {
        VStack {
            OrderRouteMapView(
                destination: destinationCoordinate,
                courier: courierCoordinate,
                route: route
            )
            .frame(height: 420)

            Text("Status: \(currentStatus)")
                .font(.headline)
                .padding()
        }
        .navigationTitle("Tracking Order")
        .onAppear {
            fetchRoute()
        }
        .onChange(of: route) { _ in
            startRouteMovement()
        }
    }
        

    private var destinationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: order.address.latitude,
            longitude: order.address.longitude
        )
    }
}

extension OrderTrackingPage {
    func startCourierMovement() {
        let destination = destinationCoordinate
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { timer in
            let latDiff = destination.latitude - courierCoordinate.latitude
            let lngDiff = destination.longitude - courierCoordinate.longitude
            
            let step = 0.0005
            
            if abs(latDiff) < step && abs(lngDiff) < step {
                timer.invalidate()
                return
            }
            
            courierCoordinate.latitude += latDiff * 0.2
            courierCoordinate.longitude += lngDiff * 0.2
            
            updateStatus()
        }
    }
    
    func startRouteMovement() {
        Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { timer in
            guard routeIndex < routeCoordinates.count else {
                timer.invalidate()
                currentStatus = "Delivered"
                return
            }
            
            courierCoordinate = routeCoordinates[routeIndex]
            routeIndex += 1
            
            updateStatus()
        }
    }
    func updateStatus() {
        let latDiff = abs(destinationCoordinate.latitude - courierCoordinate.latitude)
        let lngDiff = abs(destinationCoordinate.longitude - courierCoordinate.longitude)
        
        let distance = max(latDiff, lngDiff)
        
        if distance < 0.0005 {
            currentStatus = "Delivered"
        } else if distance < 0.002 {
            currentStatus = "Nearby"
        } else {
            currentStatus = "On the Way"
        }
    }
    
    private func fetchRoute() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: courierCoordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.transportType = .walking

        let directions = MKDirections(request: request)

        directions.calculate { response, error in
            guard let route = response?.routes.first else {
                print("Route error:", error?.localizedDescription ?? "")
                return
            }

            self.route = route
            self.routeCoordinates = route.polyline.coordinates
            self.routeIndex = 0
        }
    }



}

//MARK: - Destination Pin
struct DestinationPin: View {
    var body: some View {
        Image(systemName: "house.fill")
            .font(.title)
            .foregroundColor(.green)
    }
}
//MARK: - CourierDot

struct CourierDot: View {
    @State private var pulse = false

    var body: some View {
        ZStack {
            Circle()
                .fill(.blue.opacity(0.3))
                .frame(width: 30, height: 30)
                .scaleEffect(pulse ? 1.3 : 0.8)

            Circle()
                .fill(.blue)
                .frame(width: 14, height: 14)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever()) {
                pulse.toggle()
            }
        }
    }
}

extension MKPolyline {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}
