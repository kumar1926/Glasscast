//
//  AuthViewModel.swift
//  Glasscast
//
//  Created by BizMagnets on 03/02/26.
//

import Combine
import Foundation
import Supabase
import SwiftUI



@MainActor
class AuthViewModel: ObservableObject {
    @Published var session: Session?
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false

    func getInitialSession() async {
        authLog("Checking initial session...")
        do {
            let current = try await supabase.auth.session
            self.session = current
            self.isAuthenticated = current != nil
            authLog("Session found: \(current != nil)")
        } catch {
            authLog("No active session. Error: \(error.localizedDescription)")
            self.session = nil
            self.isAuthenticated = false
        }
    }
    func signUp(email: String, password: String) async {
        authLog("SignUp started for email: \(email)")
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await supabase.auth.signUp(
                email: email,
                password: password
            )

            self.session = result.session
            self.isAuthenticated = self.session != nil

            authLog("SignUp success. Session exists: \(self.session != nil)")
            if result.user != nil {
                authLog("User created successfully")
            }
        } catch {
            authLog("SignUp failed: \(error.localizedDescription)")
            self.session = nil
            self.isAuthenticated = false
        }
    }

    func signIn(email: String, password: String) async {
        authLog("SignIn started for email: \(email)")
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await supabase.auth.signIn(
                email: email,
                password: password
            )

            self.session = result
            self.isAuthenticated = true

            authLog("SignIn success. User authenticated")
        } catch {
            authLog("SignIn failed: \(error.localizedDescription)")
            self.session = nil
            self.isAuthenticated = false
        }
    }
    func signOut() async {
        authLog("SignOut started")
        do {
            try await supabase.auth.signOut()
            self.session = nil
            self.isAuthenticated = false
            authLog("SignOut successful")
        } catch {
            authLog("SignOut failed: \(error.localizedDescription)")
        }
    }
    func authLog(_ message: String) {
        print("🔐 AuthViewModel → \(message)")
    }

}
