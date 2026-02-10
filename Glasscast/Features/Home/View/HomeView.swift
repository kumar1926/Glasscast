//
//  HomeView.swift
//  Glasscast
//
//  Created by BizMagnets on 03/02/26.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = HomeViewModel()
    @Binding var selectedCity: City?
    @AppStorage("useCelsius") private var useCelsius: Bool = false

    var body: some View {
        ZStack {
            Color(UIColor(hex: "#122035"))
                .ignoresSafeArea()

            if viewModel.isLoading && viewModel.currentWeather == nil {
                // Loading state
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    Text("Getting weather...")
                        .foregroundColor(.white.opacity(0.7))
                }
            } else if let error = viewModel.error, viewModel.currentWeather == nil {
                // Error state
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.orange)
                    Text(error)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Button("Try Again") {
                        viewModel.refresh()
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(.white.opacity(0.2))
                    .cornerRadius(25)
                }
            } else {
                // Weather content
                ScrollView {
                    VStack(spacing: 10) {
                        // Header
                        HStack {
                            Image(
                                systemName: selectedCity != nil
                                    ? "mappin.circle.fill" : "location.fill"
                            )
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .padding()
                            .glassEffect(.clear)
                            Spacer()
                            VStack(spacing: 4) {
                                Text(viewModel.locationName)
                                    .font(.title3.bold())
                                    .foregroundColor(.white)

                                Text(viewModel.lastUpdatedDisplay.uppercased())
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            Spacer()
                        }
                        .padding(.horizontal)

                        // Current weather
                        VStack {
                            Image(systemName: viewModel.weatherIcon)
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(.white)

                            Text(temperatureString(viewModel.currentWeather?.temp))
                                .font(.system(size: 96, weight: .ultraLight))
                                .foregroundColor(.white)

                            Text(viewModel.conditionDisplay)
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.9))

                            HStack(spacing: 12) {
                                if let first = viewModel.dailyForecast.first {
                                    Text("H: \(temperatureString(first.temp.max))")
                                    Text("L: \(temperatureString(first.temp.min))")
                                }
                            }
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.top, 8)
                        }

                        // 5-Day Forecast
                        VStack {
                            HStack {
                                Text("5-DAY FORECAST")
                                    .font(.caption.bold())
                                    .tracking(1)
                                    .foregroundColor(.white)

                                Spacer()

                                Image(systemName: "calendar")
                                    .foregroundColor(.white)
                            }

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(viewModel.dailyForecast) { day in
                                        VStack(spacing: 16) {
                                            Text(day.dayName)
                                                .font(.system(size: 14, weight: .bold))

                                            Image(systemName: day.iconName)
                                                .renderingMode(.original)
                                                .font(.title2)

                                            VStack(spacing: 4) {
                                                Text(temperatureString(day.temp.max))
                                                    .font(.title2.bold())
                                                Text(temperatureString(day.temp.min))
                                                    .font(.subheadline)
                                                    .opacity(0.7)
                                            }
                                        }
                                        .foregroundColor(.white)
                                        .frame(width: 100, height: 160)
                                        .glassEffect(.regular, in: .rect(cornerRadius: 25))
                                    }
                                }
                            }
                        }

                        // Wind and Humidity
                        HStack(spacing: 20) {
                            // Wind card
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "wind")
                                    Text("WIND")
                                }
                                .font(.caption.bold())
                                .foregroundColor(.white.opacity(0.6))

                                Spacer()

                                HStack(alignment: .lastTextBaseline, spacing: 2) {
                                    Text(viewModel.windSpeedDisplay)
                                        .font(.system(size: 32, weight: .semibold))
                                        .foregroundColor(.white)
                                    Text("mph")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding(.bottom, 4)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .glassEffect(.clear, in: .rect(cornerRadius: 25))

                            // Humidity card
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "humidity")
                                    Text("HUMIDITY")
                                }
                                .font(.caption.bold())
                                .foregroundColor(.white.opacity(0.6))

                                Spacer()

                                HStack(alignment: .lastTextBaseline, spacing: 2) {
                                    Text(viewModel.humidityDisplay)
                                        .font(.system(size: 32, weight: .semibold))
                                        .foregroundColor(.white)
                                    Text("%")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding(.bottom, 4)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .glassEffect(.clear, in: .rect(cornerRadius: 25))
                        }
                        .frame(height: 120)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                .refreshable {
                    await viewModel.refreshAsync()
                }
            }
        }
        .onAppear {
            if let city = selectedCity {
                viewModel.fetchWeatherForCity(city)
            } else {
                viewModel.startFetchingWeather()
            }
        }
        .onChange(of: selectedCity) { _, newCity in
            if let city = newCity {
                viewModel.fetchWeatherForCity(city)
            }
        }
    }


    private func temperatureString(_ kelvin: Double?) -> String {
        guard let kelvin = kelvin else { return "--°" }
        if useCelsius {
            let celsius = Int(kelvin - 273.15)
            return "\(celsius)°"
        } else {
            let fahrenheit = Int((kelvin - 273.15) * 9 / 5 + 32)
            return "\(fahrenheit)°"
        }
    }
}

#Preview {
    HomeView(authViewModel: AuthViewModel(), selectedCity: .constant(nil))
}
