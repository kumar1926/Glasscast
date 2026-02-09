//
//  CityModels.swift
//  Glasscast
//
//  Created by BizMagnets on 09/02/26.
//

import Foundation

// MARK: - City Model

struct City: Codable, Identifiable, Hashable {
    let name: String
    let country: String?
    let lat: Double
    let lon: Double

    var id: String { "\(lat),\(lon)" }

    var displayName: String {
        if let country = country {
            return "\(name), \(country)"
        }
        return name
    }
}

// MARK: - Supabase Favorite City Model

struct FavoriteCity: Codable, Identifiable {
    let id: UUID?
    let userId: UUID?
    let cityName: String
    let country: String?
    let lat: Double
    let lon: Double
    let createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case cityName = "city_name"
        case country
        case lat
        case lon
        case createdAt = "created_at"
    }

    var toCity: City {
        City(name: cityName, country: country, lat: lat, lon: lon)
    }

    init(city: City, userId: UUID) {
        self.id = nil
        self.userId = userId
        self.cityName = city.name
        self.country = city.country
        self.lat = city.lat
        self.lon = city.lon
        self.createdAt = nil
    }

    init(
        id: UUID?, userId: UUID?, cityName: String, country: String?, lat: Double, lon: Double,
        createdAt: Date?
    ) {
        self.id = id
        self.userId = userId
        self.cityName = cityName
        self.country = country
        self.lat = lat
        self.lon = lon
        self.createdAt = createdAt
    }
}

// MARK: - Geocoding API Response

struct GeocodingResult: Codable {
    let name: String
    let country: String?
    let lat: Double
    let lon: Double
    let state: String?

    var toCity: City {
        let displayCountry = [state, country].compactMap { $0 }.joined(separator: ", ")
        return City(
            name: name, country: displayCountry.isEmpty ? nil : displayCountry, lat: lat, lon: lon)
    }
}
