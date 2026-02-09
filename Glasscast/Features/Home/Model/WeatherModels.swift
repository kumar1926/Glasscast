//
//  WeatherModels.swift
//  Glasscast
//
//  Created by BizMagnets on 09/02/26.
//

import Foundation

// MARK: - API Response Models

struct WeatherResponse: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let current: CurrentWeather
    let daily: [DailyForecast]
}

struct CurrentWeather: Codable {
    let dt: Int
    let temp: Double
    let humidity: Int
    let windSpeed: Double
    let weather: [WeatherCondition]

    enum CodingKeys: String, CodingKey {
        case dt, temp, humidity, weather
        case windSpeed = "wind_speed"
    }
}

struct DailyForecast: Codable, Identifiable {
    let dt: Int
    let temp: Temperature
    let humidity: Int
    let weather: [WeatherCondition]

    var id: Int { dt }
}

struct Temperature: Codable {
    let day: Double
    let min: Double
    let max: Double
}

struct WeatherCondition: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - Computed Helpers

extension CurrentWeather {
    var tempFahrenheit: Int {
        Int((temp - 273.15) * 9 / 5 + 32)
    }

    var conditionDescription: String {
        weather.first?.description.capitalized ?? "Unknown"
    }

    var iconName: String {
        guard let condition = weather.first else { return "cloud.fill" }
        return WeatherIconMapper.systemIcon(for: condition.icon)
    }
}

extension DailyForecast {
    var highTempFahrenheit: Int {
        Int((temp.max - 273.15) * 9 / 5 + 32)
    }

    var lowTempFahrenheit: Int {
        Int((temp.min - 273.15) * 9 / 5 + 32)
    }

    var dayName: String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }

    var iconName: String {
        guard let condition = weather.first else { return "cloud.fill" }
        return WeatherIconMapper.systemIcon(for: condition.icon)
    }
}

// MARK: - Weather Icon Mapper

struct WeatherIconMapper {
    static func systemIcon(for apiIcon: String) -> String {
        switch apiIcon {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
}
struct CurrentWeatherAPIResponse: Codable {
    let dt: Int
    let main: MainData
    let weather: [WeatherCondition]
    let wind: WindData
    let timezone: Int
    let name: String?
}

struct MainData: Codable {
    let temp: Double
    let humidity: Int
}

struct WindData: Codable {
    let speed: Double
}

struct ForecastAPIResponse: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt: Int
    let main: MainData
    let weather: [WeatherCondition]
}
