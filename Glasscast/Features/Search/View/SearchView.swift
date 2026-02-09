//
//  SearchView.swift
//  Glasscast
//
//  Created by BizMagnets on 09/02/26.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    var onCitySelected: ((City) -> Void)?

    var body: some View {
        ZStack {
            Color(UIColor(hex: "#122035"))
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                Text("Search Cities")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()

                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.6))

                    TextField("Search for a city...", text: $viewModel.searchQuery)
                        .textFieldStyle(.plain)
                        .foregroundColor(.white)
                        .autocorrectionDisabled()

                    if !viewModel.searchQuery.isEmpty {
                        Button {
                            viewModel.clearSearch()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }

                    if viewModel.isSearching {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                }
                .padding()
                .background(.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)

                // Content
                ScrollView {
                    LazyVStack(spacing: 12) {
                        // Search Results
                        if !viewModel.searchResults.isEmpty {
                            Section {
                                ForEach(viewModel.searchResults) { city in
                                    CityRow(
                                        city: city,
                                        isFavorite: viewModel.isFavorite(city),
                                        onTap: {
                                            onCitySelected?(city)
                                        },
                                        onFavorite: {
                                            Task {
                                                if viewModel.isFavorite(city) {
                                                    await viewModel.removeFavorite(city)
                                                } else {
                                                    await viewModel.addFavorite(city)
                                                }
                                            }
                                        }
                                    )
                                }
                            } header: {
                                SectionHeader(title: "SEARCH RESULTS")
                            }
                        }

                        // Favorites
                        if !viewModel.favoriteCities.isEmpty {
                            Section {
                                ForEach(viewModel.favoriteCities) { city in
                                    CityRow(
                                        city: city,
                                        isFavorite: true,
                                        onTap: {
                                            onCitySelected?(city)
                                        },
                                        onFavorite: {
                                            Task {
                                                await viewModel.removeFavorite(city)
                                            }
                                        }
                                    )
                                }
                            } header: {
                                SectionHeader(title: "FAVORITE CITIES")
                            }
                        }

                        // Empty State
                        if viewModel.searchResults.isEmpty && viewModel.favoriteCities.isEmpty
                            && !viewModel.isSearching
                        {
                            VStack(spacing: 16) {
                                Image(systemName: "map")
                                    .font(.system(size: 48))
                                    .foregroundColor(.white.opacity(0.4))
                                Text("Search for cities to add to favorites")
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.top, 60)
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            await viewModel.loadFavorites()
        }
    }
}

// MARK: - City Row

struct CityRow: View {
    let city: City
    let isFavorite: Bool
    let onTap: () -> Void
    let onFavorite: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(city.name)
                    .font(.headline)
                    .foregroundColor(.white)

                if let country = city.country {
                    Text(country)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
            }

            Spacer()

            Button {
                onFavorite()
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .white.opacity(0.6))
                    .font(.title3)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(.white.opacity(0.1))
        .cornerRadius(12)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Section Header

struct SectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.caption.bold())
                .tracking(1)
                .foregroundColor(.white.opacity(0.6))
            Spacer()
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
}

#Preview {
    SearchView()
}
