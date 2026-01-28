//
//  LoginView.swift
//  Glasscast
//
//  Created by BizMagnets on 28/01/26.
//

import SwiftUI

struct LoginView: View {
    @State private var showPassword: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    var body: some View {
        ZStack{
            Color(UIColor(hex: "#122035"))
                .ignoresSafeArea()
            VStack{
                VStack(spacing:20){
                    VStack(spacing:30){
                        VStack{
                            Image(systemName: "cloud.fill")
                                .resizable()
                                .foregroundStyle(.white)
                                .frame(width: 50, height: 50)
                                .padding(30)
                        }
                        .glassEffect(.clear,in: .rect(cornerRadius: 20))
                        Text("Glasscast")
                            .font(.system(size: 36, weight: .bold, design: .monospaced))
                            .foregroundStyle(.white)
                        Text("Forecast your world with clarity")
                            .font(.system(size: 14, weight: .ultraLight, design: .monospaced))
                            .foregroundStyle(.white)
                        
                    }
                    .padding(.vertical,20)
                    
                    VStack{
                        HStack{
                            Text("Email")
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        
                        HStack{
                            Image(systemName: "envelope.fill")
                                .foregroundColor(Color.gray.opacity(1.0))
                                .padding(.leading)
                            Spacer()
                            TextField("", text: $email, prompt: Text("Email").foregroundColor(.gray.opacity(0.6)))
                                .foregroundStyle(.white)
                                .padding()
                        }
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.25), lineWidth: 1))
                        
                    }
                    .padding(.horizontal)
                    VStack{
                        HStack{
                            Text("Password")
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        
                        HStack{
                            Image(systemName: "lock.fill")
                                .foregroundColor(Color.gray.opacity(1.0))
                                .padding(.leading)
                            Spacer()
                            if showPassword{
                                TextField("", text: $password, prompt: Text("Password").foregroundColor(.gray.opacity(0.6)))
                                    .foregroundStyle(.white)
                                    .padding()
                            }else{
                                SecureField("", text: $password, prompt: Text("Password").foregroundColor(.gray.opacity(0.6)))
                                    .foregroundStyle(.white)
                                    .padding()
                            }
                            Spacer()
                            Button{
                                showPassword.toggle()
                            }label: {
                                Image(systemName: showPassword ? "eye" : "eye.slash")
                                    .foregroundColor(Color.gray.opacity(1.0))
                                    .padding(.leading)
                            }
                            .padding(.trailing)
                        }
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.25), lineWidth: 1))
                        
                    }
                    .padding(.horizontal)
                    Button {
                        // TODO: Handle sign-in action
                    } label: {
                        HStack {
                            Text("Sign In")
                                .foregroundStyle(.white)
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor(hex: "#276CB4")))
                        .cornerRadius(8)
                        .glassEffect(.clear,in: .rect(cornerRadius: 8))
                    }
                    .padding(.horizontal)
                    
                }
                .padding()
                .glassEffect(.clear,in:.rect(cornerRadius: 20))
            }
            .padding()
            
        }
    }
}

#Preview {
    LoginView()
}
