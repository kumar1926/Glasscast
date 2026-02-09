//
//  WeatherService.swift
//  Glasscast
//
//  Created by BizMagnets on 09/02/26.
//

import Foundation

class WeatherService {
    private let apiKey = "24ba8ea1b25cd53a7c5fcbf4f806a845"
    private let currentWeatherURL = "https://api.openweathermap.org/data/2.5/weather"
    private let forecastURL = "https://api.openweathermap.org/data/2.5/forecast"

    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        weatherLog("Fetching weather for coordinates: \(lat), \(lon)")

        // Fetch current weather and forecast in parallel
        async let currentData = fetchCurrentWeather(lat: lat, lon: lon)
        async let forecastData = fetchForecast(lat: lat, lon: lon)

        let (current, forecast) = try await (currentData, forecastData)

        // Convert to unified response
        let response = WeatherResponse(
            lat: lat,
            lon: lon,
            timezone: "UTC\(current.timezone >= 0 ? "+" : "")\(current.timezone / 3600)",
            current: CurrentWeather(
                dt: current.dt,
                temp: current.main.temp,
                humidity: current.main.humidity,
                windSpeed: current.wind.speed,
                weather: current.weather
            ),
            daily: convertToDailyForecast(forecast)
        )

        weatherLog("Successfully built weather response")
        return response
    }

    private func fetchCurrentWeather(lat: Double, lon: Double) async throws
        -> CurrentWeatherAPIResponse
    {
        var components = URLComponents(string: currentWeatherURL)!
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "appid", value: apiKey),
        ]

        guard let url = components.url else {
            throw WeatherError.invalidURL
        }

        weatherLog("Current weather URL: \(url.absoluteString)")

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherError.invalidResponse
        }

        weatherLog("Current weather status: \(httpResponse.statusCode)")

        guard httpResponse.statusCode == 200 else {
            if httpResponse.statusCode == 401 {
                throw WeatherError.invalidAPIKey
            }
            throw WeatherError.requestFailed(statusCode: httpResponse.statusCode)
        }

        return try JSONDecoder().decode(CurrentWeatherAPIResponse.self, from: data)
    }

    private func fetchForecast(lat: Double, lon: Double) async throws -> ForecastAPIResponse {
        var components = URLComponents(string: forecastURL)!
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "cnt", value: "40"),  // 5 days * 8 (3-hour intervals)
        ]

        guard let url = components.url else {
            throw WeatherError.invalidURL
        }

        weatherLog("Forecast URL: \(url.absoluteString)")

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherError.invalidResponse
        }

        weatherLog("Forecast status: \(httpResponse.statusCode)")

        guard httpResponse.statusCode == 200 else {
            if httpResponse.statusCode == 401 {
                throw WeatherError.invalidAPIKey
            }
            throw WeatherError.requestFailed(statusCode: httpResponse.statusCode)
        }

        return try JSONDecoder().decode(ForecastAPIResponse.self, from: data)
    }

    private func convertToDailyForecast(_ forecast: ForecastAPIResponse) -> [DailyForecast] {
        // Group forecast items by day and get one per day
        var dailyMap: [String: [ForecastItem]] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        for item in forecast.list {
            let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
            let dayKey = dateFormatter.string(from: date)
            dailyMap[dayKey, default: []].append(item)
        }

        // Convert to DailyForecast, taking the noon reading or middle of day
        return dailyMap.sorted { $0.key < $1.key }
            .prefix(5)
            .compactMap { (_, items) -> DailyForecast? in
                guard let first = items.first else { return nil }

                let temps = items.map { $0.main.temp }
                let minTemp = temps.min() ?? first.main.temp
                let maxTemp = temps.max() ?? first.main.temp

                return DailyForecast(
                    dt: first.dt,
                    temp: Temperature(day: first.main.temp, min: minTemp, max: maxTemp),
                    humidity: first.main.humidity,
                    weather: first.weather
                )
            }
    }

    private func weatherLog(_ message: String) {
        print("🌤️ WeatherService → \(message)")
    }
}



// MARK: - Weather Errors

enum WeatherError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidAPIKey
    case requestFailed(statusCode: Int)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL"
        case .invalidResponse:
            return "Invalid server response"
        case .invalidAPIKey:
            return "Invalid API key. Please check your OpenWeatherMap API key."
        case .requestFailed(let statusCode):
            return "Request failed with status code: \(statusCode)"
        case .decodingFailed:
            return "Failed to decode weather data"
        }
    }
}
