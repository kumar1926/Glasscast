//
//  HomeViewModel.swift
//  Glasscast
//
//  Created by BizMagnets on 09/02/26.
//

import Combine
import CoreLocation
import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var currentWeather: CurrentWeather?
    @Published var dailyForecast: [DailyForecast] = []
    @Published var locationName: String = "Loading..."
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var lastUpdated: Date?

    private let locationManager = LocationManager()
    private let weatherService = WeatherService()
    private var cancellables = Set<AnyCancellable>()
    private var currentCity: City?

    init() {
        setupLocationObserver()
    }

    func startFetchingWeather() {
        homeLog("Starting weather fetch...")
        isLoading = true
        error = nil
        currentCity = nil
        locationManager.requestLocation()
    }

    func refresh() {
        if let city = currentCity {
            fetchWeatherForCity(city)
        } else {
            startFetchingWeather()
        }
    }

    func refreshAsync() async {
        refresh()
        while isLoading {
            try? await Task.sleep(nanoseconds: 100_000_000)
        }
    }

    func fetchWeatherForCity(_ city: City) {
        homeLog("Fetching weather for city: \(city.name)")
        currentCity = city
        locationName = city.displayName
        isLoading = true
        error = nil

        Task {
            await fetchWeather(lat: city.lat, lon: city.lon)
        }
    }

    private func setupLocationObserver() {
        locationManager.$location
            .compactMap { $0 }
            .sink { [weak self] location in
                guard let self = self, self.currentCity == nil else { return }
                Task {
                    await self.fetchWeather(
                        lat: location.coordinate.latitude,
                        lon: location.coordinate.longitude
                    )
                }
            }
            .store(in: &cancellables)

        locationManager.$locationName
            .sink { [weak self] name in
                if self?.currentCity == nil {
                    self?.locationName = name
                }
            }
            .store(in: &cancellables)

        locationManager.$error
            .compactMap { $0?.localizedDescription }
            .sink { [weak self] errorMessage in
                self?.error = errorMessage
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }

    private func fetchWeather(lat: Double, lon: Double) async {
        homeLog("Fetching weather for: \(lat), \(lon)")

        do {
            let response = try await weatherService.fetchWeather(lat: lat, lon: lon)

            self.currentWeather = response.current
            self.dailyForecast = Array(response.daily.prefix(5))
            self.lastUpdated = Date()
            self.isLoading = false
            self.error = nil

            homeLog("Weather fetched successfully")
        } catch {
            homeLog("Weather fetch failed: \(error.localizedDescription)")
            self.error = error.localizedDescription
            self.isLoading = false
        }
    }

    private func homeLog(_ message: String) {
        print("🏠 HomeViewModel → \(message)")
    }

    var temperatureDisplay: String {
        guard let current = currentWeather else { return "--°" }
        return "\(current.tempFahrenheit)°"
    }

    var conditionDisplay: String {
        currentWeather?.conditionDescription ?? "Loading..."
    }

    var highTempDisplay: String {
        guard let first = dailyForecast.first else { return "H: --°" }
        return "H: \(first.highTempFahrenheit)°"
    }

    var lowTempDisplay: String {
        guard let first = dailyForecast.first else { return "L: --°" }
        return "L: \(first.lowTempFahrenheit)°"
    }

    var windSpeedDisplay: String {
        guard let current = currentWeather else { return "--" }
        return "\(Int(current.windSpeed))"
    }

    var humidityDisplay: String {
        guard let current = currentWeather else { return "--" }
        return "\(current.humidity)"
    }

    var weatherIcon: String {
        currentWeather?.iconName ?? "cloud.fill"
    }

    var lastUpdatedDisplay: String {
        guard let date = lastUpdated else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return "Updated at \(formatter.string(from: date))"
    }
}
