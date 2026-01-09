//
//  RegistrationRequest.swift
//  Final
//
//  Created by nika kovziridze on 09.01.26.
//

import Foundation

struct RegistrationRequest: Encodable {
    let username: String?
    let email: String?
    let city: String?
    let password: String?
}
