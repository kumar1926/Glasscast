//
//  SettingsViewModel.swift
//  Glasscast
//
//  Created by BizMagnets on 09/02/26.
//

import Foundation
import SwiftUI
import Combine
import Supabase

@MainActor
class SettingsViewModel: ObservableObject {

    @AppStorage("useCelsius") var useCelsius: Bool = false
    @Published var isSigningOut: Bool = false
    @Published var error: String?

    func signOut() async {
        settingsLog("Signing out...")
        isSigningOut = true

        do {
            try await supabase.auth.signOut()
            settingsLog("Sign out successful")
        } catch {
            settingsLog("Sign out failed: \(error.localizedDescription)")
            self.error = error.localizedDescription
        }

        isSigningOut = false
    }

    func toggleTemperatureUnit() {
        useCelsius.toggle()
        settingsLog("Temperature unit changed to: \(useCelsius ? "Celsius" : "Fahrenheit")")
    }

    private func settingsLog(_ message: String) {
        print("⚙️ SettingsViewModel → \(message)")
    }
}
