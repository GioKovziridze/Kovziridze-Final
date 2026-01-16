//
//  Address.swift
//  Final
//
//  Created by nika kovziridze on 16.01.26.
//
import Foundation
import MapKit

struct Address: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var addressLine: String
}
