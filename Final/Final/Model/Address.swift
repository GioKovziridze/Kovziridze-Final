//
//  Address.swift
//  Final
//
//  Created by nika kovziridze on 16.01.26.
//
import Foundation
import MapKit

struct Address: Codable, Identifiable {
    var id: UUID = UUID()
    var latitude: Double
    var longitude: Double
    var addressLine: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(coordinate: CLLocationCoordinate2D, addressLine: String) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.addressLine = addressLine
    }
}
