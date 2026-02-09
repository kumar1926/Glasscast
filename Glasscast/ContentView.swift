//
//  ContentView.swift
//  Glasscast
//
//  Created by BizMagnets on 28/01/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel: AuthViewModel = AuthViewModel()
    @State private var isLogin: Bool = true

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                // Show MainTabView when authenticated
                MainTabView(authViewModel: authViewModel)
            } else if isLogin {
                // Show Login screen
                LoginView(
                    signupAction: {
                        isLogin = false
                    }
                )
                .environmentObject(authViewModel)
            } else {
                // Show Signup screen
                SignupView(
                    loginAction: {
                        isLogin = true
                    }
                )
                .environmentObject(authViewModel)
            }
        }
        .task {
            await authViewModel.getInitialSession()
        }
    }
}

#Preview {
    ContentView()
}
