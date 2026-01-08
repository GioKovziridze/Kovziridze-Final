//
//  AuthValidator.swift
//  Final
//
//  Created by nika kovziridze on 06.01.26.
//

import Foundation

enum AuthValidationError: LocalizedError {
    case emptyFields
    case invalidEmail
    case shortPassword
    case passwordsDoNotMatch

    var errorDescription: String? {
        switch self {
        case .emptyFields:
            return "Please fill out all fields."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .shortPassword:
            return "Password must be at least 6 characters."
        case .passwordsDoNotMatch:
            return "Passwords do not match."
        }
    }
}

struct AuthValidator {

    // MARK: - Registration Validation
    static func validateRegistration(
        username: String?,
        email: String?,
        city: String?,
        password: String?,
        confirmPassword: String?
    ) throws {

        guard
            let username, !username.isEmpty,
            let email, !email.isEmpty,
            let city, !city.isEmpty,
            let password, !password.isEmpty,
            let confirmPassword, !confirmPassword.isEmpty
        else {
            throw AuthValidationError.emptyFields
        }

        if !isValidEmail(email) {
            throw AuthValidationError.invalidEmail
        }

        if password.count < 6 {
            throw AuthValidationError.shortPassword
        }

        if password != confirmPassword {
            throw AuthValidationError.passwordsDoNotMatch
        }
    }

    // MARK: - Login Validation
    static func validateLogin(
        email: String?,
        password: String?
    ) throws {

        guard
            let email, !email.isEmpty,
            let password, !password.isEmpty
        else {
            throw AuthValidationError.emptyFields
        }

        if !isValidEmail(email) {
            throw AuthValidationError.invalidEmail
        }

        if password.count < 6 {
            throw AuthValidationError.shortPassword
        }
    }

    // MARK: - Helpers
    private static func isValidEmail(_ email: String) -> Bool {
        email.contains("@") && email.contains(".")
    }
}



