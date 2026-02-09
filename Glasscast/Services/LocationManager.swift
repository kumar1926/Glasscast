//
//  LocationManager.swift
//  Glasscast
//
//  Created by BizMagnets on 09/02/26.
//

import CoreLocation
import Foundation
import Combine

@MainActor
class LocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation?
    @Published var locationName: String = "Loading..."
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var error: Error?

    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        locationLog("Requesting location authorization...")

        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationLog("Authorization granted, requesting location...")
            manager.requestLocation()
        case .denied, .restricted:
            locationLog("Location access denied or restricted")
            error = LocationError.accessDenied
        @unknown default:
            break
        }
    }

    private func reverseGeocode(_ location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            Task { @MainActor in
                if let error = error {
                    self?.locationLog("Geocoding error: \(error.localizedDescription)")
                    self?.locationName = "Unknown Location"
                    return
                }

                if let placemark = placemarks?.first {
                    self?.locationName =
                        placemark.locality ?? placemark.administrativeArea ?? "Unknown"
                    self?.locationLog("Location name: \(self?.locationName ?? "")")
                }
            }
        }
    }

    private func locationLog(_ message: String) {
        print("📍 LocationManager → \(message)")
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    nonisolated func locationManager(
        _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }

        Task { @MainActor in
            self.location = location
            self.locationLog(
                "Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)"
            )
            self.reverseGeocode(location)
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.locationLog("Location error: \(error.localizedDescription)")
            self.error = error
        }
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.authorizationStatus = manager.authorizationStatus
            self.locationLog(
                "Authorization status changed: \(manager.authorizationStatus.rawValue)")

            if manager.authorizationStatus == .authorizedWhenInUse
                || manager.authorizationStatus == .authorizedAlways
            {
                manager.requestLocation()
            }
        }
    }
}

// MARK: - Location Errors

enum LocationError: LocalizedError {
    case accessDenied
    case locationUnavailable

    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "Location access denied. Please enable in Settings."
        case .locationUnavailable:
            return "Unable to get current location."
        }
    }
}
