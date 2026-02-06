//
//  ForgetPasswordView.swift
//  UserLoginPage
//
//  Created by H2026215 on 2025/12/1.
//

import SwiftUI
import FirebaseAuth

struct ForgetPasswordView: View {

    @State private var email = ""
    @State private var errorMessage = ""
    @State private var emailSent = false
    @State private var navigateToLogin = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                Spacer().frame(height: 60) 
                // Title
                HStack {
                    Text("Forget Password")
                        .font(.custom("Poppins", size: 22).weight(.bold))
                        .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                }
                .frame(maxWidth: 320, alignment: .leading)
                // Email field
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.custom("Poppins", size: 14).weight(.medium))
                        .foregroundColor(Color(red: 0.02, green: 0.06, blue: 0.06))

                    TextField("write here", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .padding(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(red: 0.84, green: 0.84, blue: 0.84), lineWidth: 0.5)
                        )
                }
                .frame(maxWidth: 320)

                // Send Email button (only before sending)
                if !emailSent {
                    Button(action: sendResetPasswordEmail) {
                        Text("Send Email")
                            .foregroundColor(.white)
                            .frame(width: 240, height: 38)
                            .background(Color(red: 0.34, green: 0.24, blue: 0.51))
                            .cornerRadius(100)
                    }
                }

                // After success
                if emailSent {
                    Text("Password reset email sent!\nPlease check your inbox.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.green)
                        .padding(.top, 10)

                    Button {
                        navigateToLogin = true
                    } label: {
                        Text("Return to Login Page")
                            .foregroundColor(.white)
                            .frame(width: 240, height: 38)
                            .background(Color(red: 0.34, green: 0.24, blue: 0.51))
                            .cornerRadius(100)
                    }
                    .padding(.top, 10)
                }

                // Error message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $navigateToLogin) {
                ContentView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }

    private func sendResetPasswordEmail() {
        errorMessage = ""

        guard !email.isEmpty else {
            errorMessage = "Please enter your email"
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }

            withAnimation {
                emailSent = true
            }
        }
    }
}

struct ForgetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPasswordView()
    }
}
