//
//  MainTabView.swift
//  Glasscast
//
//  Created by BizMagnets on 09/02/26.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var selectedTab: Tab = .home
    @State private var selectedCity: City?

    enum Tab {
        case home
        case search
        case settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(authViewModel: authViewModel, selectedCity: $selectedCity)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)

            SearchView { city in
                selectedCity = city
                selectedTab = .home
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(Tab.search)

            SettingsView()
                .environmentObject(authViewModel)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(Tab.settings)
        }
        .tint(.white)
        
    }
}

#Preview {
    MainTabView(authViewModel: AuthViewModel())
}
