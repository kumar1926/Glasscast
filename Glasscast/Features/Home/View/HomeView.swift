//
//  HomeView.swift
//  Glasscast
//
//  Created by BizMagnets on 03/02/26.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: AuthViewModel
    let days = [
        ("MON", "cloud.sun.fill", "68°", "54°", true), // Active
        ("TUE", "sun.max.fill", "74°", "58°", false),
        ("WED", "cloud.fill", "65°", "52°", false),
        ("THU", "wind", "60°", "48°", false)
    ]
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
                        .glassEffect(.clear)
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
                    VStack(spacing:10){
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
                        VStack{
                            HStack {
                                Text("5-DAY FORECAST")
                                    .font(.caption.bold())
                                    .tracking(1)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "calendar")
                                    .foregroundColor(.white)
                            }
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack(spacing:15){
                                    ForEach(days,id: \.0){ day in
                                        VStack(spacing: 16) {
                                            Text(day.0)
                                                .font(.system(size: 14, weight: .bold))
                                            
                                            Image(systemName: day.1)
                                                .renderingMode(.original)
                                                .font(.title2)
                                            
                                            VStack(spacing: 4) {
                                                Text(day.2)
                                                    .font(.title2.bold())
                                                Text(day.3)
                                                    .font(.subheadline)
                                                    .opacity(0.7)
                                            }
                                        }
                                        .foregroundColor(.white)
                                        .frame(width: 100, height: 160)
                                        .glassEffect(.regular,in: .rect(cornerRadius: 25))
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        HStack(spacing:20) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "wind")
                                    Text("WIND")
                                }
                                .font(.caption.bold())
                                .foregroundColor(.white.opacity(0.6))
                                
                                Spacer()
                                
                                HStack(alignment: .lastTextBaseline, spacing: 2) {
                                    Text("12")
                                        .font(.system(size: 32, weight: .semibold))
                                        .foregroundColor(.white)
                                    Text("mph")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding(.bottom, 4)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .glassEffect(.clear,in:.rect(cornerRadius: 25))
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "humidity")
                                    Text("HUMIDITY")
                                }
                                .font(.caption.bold())
                                .foregroundColor(.white.opacity(0.6))
                                
                                Spacer()
                                
                                HStack(alignment: .lastTextBaseline, spacing: 2) {
                                    Text("45")
                                        .font(.system(size: 32, weight: .semibold))
                                        .foregroundColor(.white)
                                    Text("%")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding(.bottom, 4)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .glassEffect(.clear,in:.rect(cornerRadius: 25))
                        }
                        .padding(20)
                        .frame(height: 120)
                    }
                    .padding(.horizontal,20)
                }
            }
            .padding(.top, 20)
            
        }
    }
}

#Preview {
    HomeView(viewModel: AuthViewModel())
}
