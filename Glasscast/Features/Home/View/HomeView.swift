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
            VStack(){
                HStack{
                    Image(systemName: "location.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                        .padding()
                        .glassEffect()
                    Spacer()
                    VStack(spacing: 4) {
                        Text("San Francisco")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        
                        Text("UPDATED JUST NOW",)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                Spacer()
                ScrollView{
                    VStack{
                        VStack{
                            Image(systemName: "cloud.fill")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 120, height: 120)
                                .foregroundStyle(.white)
                            
                            Text("68°")
                                .font(.system(size: 96, weight: .ultraLight))
                                .foregroundColor(.white)
                            
                            Text("Partly Cloudy")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.9))
                            
                            HStack(spacing: 12) {
                                Text("H: 72°")
                                Text("L: 54°")
                            }
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.top, 8)
                        }
                    }
                }
            }
            .padding(.top, 20)
            
        }
    }
}

#Preview {
    HomeView(viewModel: AuthViewModel())
}
