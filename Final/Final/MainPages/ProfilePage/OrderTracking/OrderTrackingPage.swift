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
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.96, blue: 0.98),
                    Color(red: 0.94, green: 0.94, blue: 0.97)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(.all)
            
            VStack(spacing: 24) {
                // MARK: - Map Card with refined borders
                VStack(spacing: 0) {
                    OrderRouteMapView(
                        destination: destinationCoordinate,
                        courier: courierCoordinate,
                        route: route
                    )
                    .frame(height: 440)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color.indigo.opacity(0.3),
                                        Color.purple.opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(
                        color: Color.indigo.opacity(0.08),
                        radius: 20,
                        x: 0,
                        y: 8
                    )
                }
                .padding(.horizontal, 20)
                
                // MARK: - Status Card with glassmorphic effect
                VStack(spacing: 16) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(statusColor)
                            .frame(width: 8, height: 8)
                            .shadow(color: statusColor.opacity(0.5), radius: 4)
                        
                        Text(currentStatus)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(statusColor.opacity(0.12))
                            .overlay(
                                Capsule()
                                    .strokeBorder(statusColor.opacity(0.3), lineWidth: 1)
                            )
                    )
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color.indigo.opacity(0.1),
                                    Color.clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 1)
                        .padding(.horizontal, 20)
                    
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.indigo.opacity(0.1),
                                            Color.purple.opacity(0.08)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.indigo, Color.purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Delivery Address")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Text(order.address.addressLine.isEmpty ? "Your Address" : order.address.addressLine)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.25))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.7))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.indigo.opacity(0.15),
                                            Color.purple.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(
                            color: Color.indigo.opacity(0.06),
                            radius: 16,
                            x: 0,
                            y: 4
                        )
                )
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.9))
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.indigo.opacity(0.15), lineWidth: 1)
                            )
                            .frame(width: 36, height: 36)
                            .shadow(
                                color: Color.black.opacity(0.06),
                                radius: 8,
                                x: 0,
                                y: 2
                            )
                        
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.35))
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            fetchRoute()
            startRouteMovement()
        }
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
        case "Delivered": return Color(red: 0.2, green: 0.78, blue: 0.35)
        case "Nearby": return Color(red: 1.0, green: 0.8, blue: 0.0)
        default: return Color(red: 1.0, green: 0.58, blue: 0.0)
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
