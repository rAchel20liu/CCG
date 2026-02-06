//
//  ContentView.swift
//  UserLoginPage
//
//  Created by H2026215 on 2025/11/10.
//
import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Spacer().frame(height: 60)

                Image("loginIcon")
                    .resizable()
                    .frame(width: 100, height: 80)

                Text("Cue Cook")
                    .font(.system(size: 22))
                    .bold()
                    .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))

                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.custom("Poppins", size: 14).weight(.medium))
                    TextField("write here", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .padding(12)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.5)))
                }
                .frame(maxWidth: 320)

                VStack(alignment: .leading) {
                    Text("Password")
                        .font(.custom("Poppins", size: 14).weight(.medium))
                    SecureField("write here", text: $password)
                        .padding(12)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.5)))
                }
                .frame(maxWidth: 320)

                HStack {
                    NavigationLink("Create Account") { RegistrationView() }
                        .font(.custom("Inter", size: 10))
                        .underline()
                        .foregroundColor(.black)

                    Spacer()

                    NavigationLink("Forget Password") { ForgetPasswordView() }
                        .font(.custom("Inter", size: 10))
                        .underline()
                        .foregroundColor(.black)
                }
                .frame(maxWidth: 320)

                Button(action: login) {
                    Text("Log in")
                        .font(.custom("Poppins", size: 15).weight(.bold))
                        .foregroundColor(.white)
                        .frame(width: 320, height: 38)
                        .background(Color(red: 0.34, green: 0.24, blue: 0.51))
                        .cornerRadius(1000)
                }
                .padding(.top, 4)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 13))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
                    .environmentObject(authVM)
            }
        }
    }

    func login() {
        errorMessage = ""
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please input your email and password"
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                errorMessage = "Wrong email or password"
                return
            }
            guard let user = result?.user else { return }

            if !user.isEmailVerified {
                errorMessage = "Email verification is required"
                return
            }

            print("Login successful uid: \(user.uid)")
            navigateToHome = true
        }
    }
}

#Preview {
    ContentView()
}
