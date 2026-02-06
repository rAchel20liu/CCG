//
//  RegistrationView.swift
//  UserLoginPage
//
//  Created by H2026215 on 2025/11/21.
//
import SwiftUI
import FirebaseAuth

struct RegistrationView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @State private var errorMessage = ""
    @State private var emailSent = false
    @State private var navigateToLogin = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer().frame(height: 60)
                // Title
                HStack{
                    Text("Create Account")
                        .font(.system(size: 22))
                        .bold()
                        .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                }
                .frame(maxWidth: 320, alignment: .leading)
                // Email
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.custom("Poppins", size: 14).weight(.medium))
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
                
                // Password
                VStack(alignment: .leading) {
                    Text("Password")
                        .font(.custom("Poppins", size: 14).weight(.medium))
                    SecureField("write here", text: $password)
                        .padding(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(red: 0.84, green: 0.84, blue: 0.84), lineWidth: 0.5)
                        )
                }
                .frame(maxWidth: 320)
                
                // Confirm Password
                VStack(alignment: .leading) {
                    Text("Re-enter Password")
                        .font(.custom("Poppins", size: 14).weight(.medium))
                    SecureField("write here", text: $confirmPassword)
                        .padding(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(red: 0.84, green: 0.84, blue: 0.84), lineWidth: 0.5)
                        )
                }
                .frame(maxWidth: 320)
                
                
                // Button only shown before email is sent
                if !emailSent {
                    Button(action: registerUser) {
                        Text("Create Account")
                            .foregroundColor(.white)
                            .frame(width: 240, height: 38)
                            .background(Color(red: 0.34, green: 0.24, blue: 0.51))
                            .cornerRadius(100)
                    }
                }
                
                // After success
                if emailSent {
                    Text("Verification email sent!\nPlease check your inbox.")
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
                }
                
                // Error text
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
                    .navigationBarBackButtonHidden(true)// your login page
            }
        }
    }
    
    
    func registerUser() {
        errorMessage = ""
        
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email"
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "The two passwords are inconsistent"
            return
        }
        
        // Create user in Firebase
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }
            
            guard let user = result?.user else { return }
            
            // Send verification email
            user.sendEmailVerification { error in
                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }
                
                // Show success UI
                withAnimation {
                    emailSent = true
                }
                
                print("Registered successfully. UID = \(user.uid)")
            }
        }
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: email)
    }
}


struct Registration_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
