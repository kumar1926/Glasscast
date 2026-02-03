//
//  SignupView.swift
//  Glasscast
//
//  Created by BizMagnets on 02/02/26.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    @State private var hasAttemptedSubmit: Bool = false

    var loginAction: (() -> Void) = {}
    var body: some View {
        ZStack {
            Color(UIColor(hex: "#122035"))
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    VStack(spacing: 20) {
                        VStack(spacing: 30) {
                            VStack {
                                Image(systemName: "cloud.fill")
                                    .resizable()
                                    .foregroundStyle(.white)
                                    .frame(width: 50, height: 50)
                                    .padding(20)
                            }
                            .glassEffect(.clear, in: .rect(cornerRadius: 20))
                            Text("Glasscast")
                                .font(.system(size: 36, weight: .bold, design: .monospaced))
                                .foregroundStyle(.white)
                            Text("Join the atmospere")
                                .font(.system(size: 14, weight: .ultraLight, design: .monospaced))
                                .foregroundStyle(.white)

                        }
                        .padding(.vertical, 20)
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Email")
                                    .foregroundStyle(.white)
                                Spacer()
                            }

                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(
                                        emailError != nil
                                            ? Color.red.opacity(0.8) : Color.gray.opacity(1.0)
                                    )
                                    .padding(.leading)
                                TextField(
                                    "", text: $email,
                                    prompt: Text("Email").foregroundColor(.gray.opacity(0.6))
                                )
                                .foregroundStyle(.white)
                                .padding(10)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .onChange(of: email) { _, _ in
                                    if hasAttemptedSubmit {
                                        emailError = ValidationHelper.validateEmail(email)
                                    }
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8).stroke(
                                    emailError != nil
                                        ? Color.red.opacity(0.8) : Color.gray.opacity(0.25),
                                    lineWidth: 1))

                            if let error = emailError {
                                Text(error)
                                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                                    .foregroundStyle(Color.red.opacity(0.9))
                                    .padding(.top, 4)
                            }
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading) {
                            HStack {
                                Text("Password")
                                    .foregroundStyle(.white)
                                Spacer()
                            }

                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(
                                        passwordError != nil
                                            ? Color.red.opacity(0.8) : Color.gray.opacity(1.0)
                                    )
                                    .padding(.leading)
                                if showPassword {
                                    TextField(
                                        "", text: $password,
                                        prompt: Text("Password").foregroundColor(.gray.opacity(0.6))
                                    )
                                    .foregroundStyle(.white)
                                    .padding(10)
                                } else {
                                    SecureField(
                                        "", text: $password,
                                        prompt: Text("Password").foregroundColor(.gray.opacity(0.6))
                                    )
                                    .foregroundStyle(.white)
                                    .padding(10)
                                }
                                Spacer()
                                Button {
                                    showPassword.toggle()
                                } label: {
                                    Image(systemName: showPassword ? "eye" : "eye.slash")
                                        .foregroundColor(Color.gray.opacity(1.0))
                                        .padding(.leading)
                                }
                                .padding(.trailing)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8).stroke(
                                    passwordError != nil
                                        ? Color.red.opacity(0.8) : Color.gray.opacity(0.25),
                                    lineWidth: 1))

                            if let error = passwordError {
                                Text(error)
                                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                                    .foregroundStyle(Color.red.opacity(0.9))
                                    .padding(.top, 4)
                            }
                        }
                        .padding(.horizontal)
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Confirm Password")
                                    .foregroundStyle(.white)
                                Spacer()
                            }

                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(
                                        confirmPasswordError != nil
                                            ? Color.red.opacity(0.8) : Color.gray.opacity(1.0)
                                    )
                                    .padding(.leading)
                                if showConfirmPassword {
                                    TextField(
                                        "", text: $confirmPassword,
                                        prompt: Text("Confirm Password").foregroundColor(
                                            .gray.opacity(0.6))
                                    )
                                    .foregroundStyle(.white)
                                    .padding(10)
                                } else {
                                    SecureField(
                                        "", text: $confirmPassword,
                                        prompt: Text("Confirm Password").foregroundColor(
                                            .gray.opacity(0.6))
                                    )
                                    .foregroundStyle(.white)
                                    .padding(10)
                                }
                                Spacer()
                                Button {
                                    showConfirmPassword.toggle()
                                } label: {
                                    Image(systemName: showConfirmPassword ? "eye" : "eye.slash")
                                        .foregroundColor(Color.gray.opacity(1.0))
                                        .padding(.leading)
                                }
                                .padding(.trailing)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8).stroke(
                                    confirmPasswordError != nil
                                        ? Color.red.opacity(0.8) : Color.gray.opacity(0.25),
                                    lineWidth: 1))

                            if let error = confirmPasswordError {
                                Text(error)
                                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                                    .foregroundStyle(Color.red.opacity(0.9))
                                    .padding(.top, 4)
                            }
                        }
                        .padding(.horizontal)
                        .onChange(of: password) { _, _ in
                            if hasAttemptedSubmit {
                                passwordError = ValidationHelper.validatePassword(password)
                                confirmPasswordError = ValidationHelper.validateConfirmPassword(
                                    password, confirmPassword)
                            }
                        }
                        .onChange(of: confirmPassword) { _, _ in
                            if hasAttemptedSubmit {
                                confirmPasswordError = ValidationHelper.validateConfirmPassword(
                                    password, confirmPassword)
                            }
                        }
                        Button {
                            hasAttemptedSubmit = true
                            let validation = ValidationHelper.validateSignupForm(
                                email: email, password: password, confirmPassword: confirmPassword)
                            emailError = validation.errors["email"]
                            passwordError = validation.errors["password"]
                            confirmPasswordError = validation.errors["confirmPassword"]

                            guard validation.isValid else { return }

                            Task {
                                await viewModel.signUp(email: email, password: password)
                            }
                        } label: {
                            HStack {
                                Text("Create Account")
                                    .foregroundStyle(.white)
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor(hex: "#276CB4")))
                            .cornerRadius(8)
                            .glassEffect(.clear, in: .rect(cornerRadius: 8))
                        }
                        .padding(.horizontal)
                        HStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.25))
                                .frame(height: 2)
                                .frame(maxWidth: .infinity)
                                .padding(.leading)
                            Text("OR")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundStyle(Color.gray.opacity(0.25))
                                .padding(.horizontal, 5)
                            Rectangle()
                                .fill(Color.gray.opacity(0.25))
                                .frame(height: 2)
                                .frame(maxWidth: .infinity)
                                .padding(.trailing)
                        }
                        HStack {
                            Text("Already have an account?")
                                .font(.system(size: 10, weight: .ultraLight, design: .monospaced))
                                .foregroundStyle(.white)
                            Button {
                                loginAction()
                            } label: {
                                Text("Log In")
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundStyle(.white)

                            }
                        }
                        .padding(10)
                    }
                    .padding()
                    .glassEffect(.clear, in: .rect(cornerRadius: 20))
                    .padding(.bottom, 20)
                }
                .padding()

            }
        }
    }
}

#Preview {
    SignupView()
}
