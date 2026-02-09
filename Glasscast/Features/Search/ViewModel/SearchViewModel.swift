//
//  SearchViewModel.swift
//  Glasscast
//
//  Created by BizMagnets on 09/02/26.
//

import Combine
import Foundation
import Supabase

@MainActor
class SearchViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var searchQuery: String = ""
    @Published var searchResults: [City] = []
    @Published var favoriteCities: [City] = []
    @Published var isSearching: Bool = false
    @Published var isLoadingFavorites: Bool = false
    @Published var error: String?

    // MARK: - Private Properties

    private let apiKey = "24ba8ea1b25cd53a7c5fcbf4f806a845"
    private let geocodingURL = "https://api.openweathermap.org/geo/1.0/direct"
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init() {
        setupSearchDebounce()
    }

    // MARK: - Public Methods

    func loadFavorites() async {
        searchLog("Loading favorites...")
        isLoadingFavorites = true

        do {
            guard let userId = try await supabase.auth.session.user.id as UUID? else {
                searchLog("No user logged in")
                isLoadingFavorites = false
                return
            }

            let favorites: [FavoriteCity] =
                try await supabase
                .from("favorite_cities")
                .select()
                .eq("user_id", value: userId)
                .execute()
                .value

            self.favoriteCities = favorites.map { $0.toCity }
            searchLog("Loaded \(favorites.count) favorites")
        } catch {
            searchLog("Failed to load favorites: \(error.localizedDescription)")
            self.error = error.localizedDescription
        }

        isLoadingFavorites = false
    }

    func    addFavorite(_ city: City) async {
        searchLog("Adding favorite: \(city.name)")

        do {
            guard let userId = try await supabase.auth.session.user.id as UUID? else {
                return
            }

            let favorite = FavoriteCity(city: city, userId: userId)

            try await supabase
                .from("favorite_cities")
                .insert(favorite)
                .execute()

            favoriteCities.append(city)
            searchLog("Favorite added successfully")
        } catch {
            searchLog("Failed to add favorite: \(error.localizedDescription)")
            self.error = error.localizedDescription
        }
    }

    func removeFavorite(_ city: City) async {
        searchLog("Removing favorite: \(city.name)")

        do {
            guard let userId = try await supabase.auth.session.user.id as UUID? else {
                return
            }

            try await supabase
                .from("favorite_cities")
                .delete()
                .eq("user_id", value: userId)
                .eq("lat", value: city.lat)
                .eq("lon", value: city.lon)
                .execute()

            favoriteCities.removeAll { $0.id == city.id }
            searchLog("Favorite removed successfully")
        } catch {
            searchLog("Failed to remove favorite: \(error.localizedDescription)")
            self.error = error.localizedDescription
        }
    }

    func isFavorite(_ city: City) -> Bool {
        favoriteCities.contains { $0.id == city.id }
    }

    func clearSearch() {
        searchQuery = ""
        searchResults = []
    }

    // MARK: - Private Methods

    private func setupSearchDebounce() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                Task {
                    await self.searchCities(query: query)
                }
            }
            .store(in: &cancellables)
    }

    private func searchCities(query: String) async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            return
        }

        searchLog("Searching for: \(query)")
        isSearching = true

        var components = URLComponents(string: geocodingURL)!
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "appid", value: apiKey),
        ]

        guard let url = components.url else {
            isSearching = false
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let results = try JSONDecoder().decode([GeocodingResult].self, from: data)
            self.searchResults = results.map { $0.toCity }
            searchLog("Found \(results.count) results")
        } catch {
            searchLog("Search failed: \(error.localizedDescription)")
            self.error = error.localizedDescription
        }

        isSearching = false
    }

    private func searchLog(_ message: String) {
        print("🔍 SearchViewModel → \(message)")
    }
}
