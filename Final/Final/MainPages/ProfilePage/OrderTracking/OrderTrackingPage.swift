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

    @Environment(\.dismiss) private var dismiss 
    @ObservedObject private var userStore = UserStore.shared
    @State private var courierCoordinate: CLLocationCoordinate2D
    @State private var route: MKRoute?
    @State private var routeCoordinates: [CLLocationCoordinate2D] = []
    @State private var routeIndex = 0

    init(order: Order) {
        self.order = order
        
        _courierCoordinate = State(
            initialValue: CLLocationCoordinate2D(
                latitude: order.address.latitude + 0.01,
                longitude: order.address.longitude - 0.01
            )
        )
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.indigo.opacity(0.9), Color(red: 0.18, green: 0.16, blue: 0.28)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // MARK: - Map Card
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.indigo.opacity(0.1))
                        .shadow(color: Color.black.opacity(0.35), radius: 20, x: 0, y: 10)
                    
                    OrderRouteMapView(
                        destination: destinationCoordinate,
                        courier: courierCoordinate,
                        route: route
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                    .padding(6)
                }
                .frame(height: 420)
                .padding(.horizontal)
                
                // MARK: - Status Card
                VStack(spacing: 12) {
                    Text("Order Status")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    
                    Text(currentStatus)
                        .font(.title2.weight(.semibold))
                        .foregroundColor(statusColor)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 24)
                        .background(
                            Capsule()
                                .fill(statusColor.opacity(0.2))
                        )
                    
                    HStack(spacing: 12) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.white.opacity(0.8))
                        Text("Destination: \(order.address.addressLine.isEmpty ? "Your Address" : order.address.addressLine)")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.subheadline)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.indigo.opacity(0.4)))
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(.black)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            fetchRoute()
            startRouteMovement()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var destinationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: order.address.latitude,
            longitude: order.address.longitude
        )
    }
    
    private var currentStatus: String {
        userStore.currentUser?.orders.first(where: { $0.id == order.id })?.status ?? "Pending"
    }
    
    private var statusColor: Color {
        switch currentStatus {
        case "Delivered": return .green
        case "Nearby": return .yellow
        default: return .orange
        }
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

        let newStatus: String
        if distance < 0.0005 {
            newStatus = "Delivered"
        } else if distance < 0.002 {
            newStatus = "Nearby"
        } else {
            newStatus = "On the Way"
        }

        userStore.updateOrderStatus(orderID: order.id, status: newStatus)
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
