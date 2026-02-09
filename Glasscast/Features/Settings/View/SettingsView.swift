//
//  SettingsView.swift
//  Glasscast
//
//  Created by BizMagnets on 09/02/26.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            Color(UIColor(hex: "#122035"))
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                Text("Settings")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()

                ScrollView {
                    VStack(spacing: 20) {
                        // Temperature Unit
                        VStack(alignment: .leading, spacing: 12) {
                            Text("TEMPERATURE UNIT")
                                .font(.caption.bold())
                                .tracking(1)
                                .foregroundColor(.white.opacity(0.6))

                            HStack {
                                Text("Use Celsius (°C)")
                                    .foregroundColor(.white)

                                Spacer()

                                Toggle("", isOn: $viewModel.useCelsius)
                                    .labelsHidden()
                                    .tint(.blue)
                            }
                            .padding()
                            .background(.white.opacity(0.1))
                            .cornerRadius(12)

                            Text(
                                viewModel.useCelsius
                                    ? "Showing temperatures in Celsius"
                                    : "Showing temperatures in Fahrenheit"
                            )
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                        }

                        // Account Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("ACCOUNT")
                                .font(.caption.bold())
                                .tracking(1)
                                .foregroundColor(.white.opacity(0.6))

                            Button {
                                Task {
                                    await authViewModel.signOut()
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                    Text("Sign Out")
                                    Spacer()

                                    if viewModel.isSigningOut {
                                        ProgressView()
                                            .progressViewStyle(
                                                CircularProgressViewStyle(tint: .white)
                                            )
                                            .scaleEffect(0.8)
                                    }
                                }
                                .foregroundColor(.red)
                                .padding()
                                .background(.white.opacity(0.1))
                                .cornerRadius(12)
                            }
                            .disabled(viewModel.isSigningOut)
                        }

                        // App Info
                        VStack(alignment: .leading, spacing: 12) {
                            Text("ABOUT")
                                .font(.caption.bold())
                                .tracking(1)
                                .foregroundColor(.white.opacity(0.6))

                            VStack(spacing: 0) {
                                HStack {
                                    Text("Version")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("1.0.0")
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .padding()

                                Divider()
                                    .background(.white.opacity(0.1))

                                HStack {
                                    Text("Weather Data")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("OpenWeatherMap")
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .padding()
                            }
                            .background(.white.opacity(0.1))
                            .cornerRadius(12)
                        }

                        Spacer()
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthViewModel())
}
