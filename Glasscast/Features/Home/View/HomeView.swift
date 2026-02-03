//
//  HomeView.swift
//  Glasscast
//
//  Created by BizMagnets on 03/02/26.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        ZStack {
            Color(UIColor(hex: "#122035"))
                .ignoresSafeArea()

            VStack(spacing: 30) {
                VStack {
                    Image(systemName: "cloud.fill")
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 60, height: 60)
                        .padding(30)
                }
                .glassEffect(.clear, in: .rect(cornerRadius: 20))

                Text("Welcome to Glasscast")
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)

                Text("Forecast your world with clarity")
                    .font(.system(size: 14, weight: .ultraLight, design: .monospaced))
                    .foregroundStyle(.white)

                Spacer()

                // Sign Out Button
                Button {
                    Task {
                        await viewModel.signOut()
                    }
                } label: {
                    HStack {
                        Text("Sign Out")
                            .foregroundStyle(.white)
                        Image(systemName: "arrow.right.circle")
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.6))
                    .cornerRadius(8)
                    .glassEffect(.clear, in: .rect(cornerRadius: 8))
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
            .padding()
        }
    }
}

#Preview {
    HomeView(viewModel: AuthViewModel())
}
