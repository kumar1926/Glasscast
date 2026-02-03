//
//  ValidationHelper.swift
//  Glasscast
//
//  Created by BizMagnets on 03/02/26.
//

import Foundation

struct ValidationHelper {

    // MARK: - Email Validation

    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    static func validateEmail(_ email: String) -> String? {
        if email.isEmpty {
            return "Email is required"
        }
        if !isValidEmail(email) {
            return "Please enter a valid email address"
        }
        return nil
    }

    // MARK: - Password Validation

    static func validatePassword(_ password: String) -> String? {
        if password.isEmpty {
            return "Password is required"
        }
        if password.count < 8 {
            return "Password must be at least 8 characters"
        }
        if !password.contains(where: { $0.isUppercase }) {
            return "Password must contain at least one uppercase letter"
        }
        if !password.contains(where: { $0.isLowercase }) {
            return "Password must contain at least one lowercase letter"
        }
        if !password.contains(where: { $0.isNumber }) {
            return "Password must contain at least one number"
        }
        return nil
    }

    static func validateConfirmPassword(_ password: String, _ confirmPassword: String) -> String? {
        if confirmPassword.isEmpty {
            return "Please confirm your password"
        }
        if password != confirmPassword {
            return "Passwords do not match"
        }
        return nil
    }

    // MARK: - Form Validation

    static func validateLoginForm(email: String, password: String) -> (
        isValid: Bool, errors: [String: String]
    ) {
        var errors: [String: String] = [:]

        if let emailError = validateEmail(email) {
            errors["email"] = emailError
        }

        if password.isEmpty {
            errors["password"] = "Password is required"
        }

        return (errors.isEmpty, errors)
    }

    static func validateSignupForm(email: String, password: String, confirmPassword: String) -> (
        isValid: Bool, errors: [String: String]
    ) {
        var errors: [String: String] = [:]

        if let emailError = validateEmail(email) {
            errors["email"] = emailError
        }

        if let passwordError = validatePassword(password) {
            errors["password"] = passwordError
        }

        if let confirmError = validateConfirmPassword(password, confirmPassword) {
            errors["confirmPassword"] = confirmError
        }

        return (errors.isEmpty, errors)
    }
}
