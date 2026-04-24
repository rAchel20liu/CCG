//
//  RecipeCompleteView.swift
//  CCG
//
//  Created by H2026215 on 2026/1/30.
//

import SwiftUI
import PhotosUI
import GoogleGenerativeAI

struct FinishView: View {
    let onSkip: () -> Void
    let dishName: String
    @EnvironmentObject var progressVM: ProgressViewModel
    @EnvironmentObject var photoVM: PhotoViewModel
    
    private let model = GenerativeModel(name: "gemini-2.5-flash", apiKey: APIKey.default)
    
    @State private var showCamera = false
    @State private var showPhotoPicker = false
    @State private var selectedImage: UIImage?
    @State private var showingPhotoOptions = false
    @State private var isUploading = false
    @State private var uploadSuccess = false
    @State private var isVerifying = false
    @State private var verificationMessage: String?
    @State private var verificationSuccess = false
    @State private var hasCompleted = false  // 防止重复计数
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // 没有选照片时：显示 Congratulations 和 🎉
                if selectedImage == nil {
                    VStack(spacing: 20) {
                        Text("Congratulations！\nYou’ve finished the\ndish of this level!")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                            .multilineTextAlignment(.center)
                        
                        Text("🎉")
                            .font(.system(size: 80))
                            .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                    }
                    .padding(.bottom, 20)
                }
                
                // 已选图片预览
                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        .shadow(radius: 4)
                }
                
                // 拍照按钮
                Button(action: {
                    showingPhotoOptions = true
                }) {
                    HStack {
                        Image(systemName: "camera.fill")
                        Text(selectedImage == nil ? "Take Photo" : "Change Photo")
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color(red: 0.34, green: 0.24, blue: 0.51))
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
                }
                .disabled(isUploading || isVerifying)
                
                // AI 验证并完成按钮
                if selectedImage != nil {
                    Button(action: {
                        Task {
                            await verifyAndComplete()
                        }
                    }) {
                        HStack {
                            if isVerifying {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "checkmark.seal.fill")
                                Text("Verify & Complete")
                            }
                        }
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.green)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                    }
                    .disabled(isUploading || isVerifying)
                }
                
                // 验证状态消息
                if let message = verificationMessage {
                    Text(message)
                        .font(.caption)
                        .foregroundColor(verificationSuccess ? .green : .red)
                        .multilineTextAlignment(.center)
                }
                
                // Skip 按钮
                Button(action: {
                    onSkip()
                }) {
                    Text("Skip")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51).opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                }
                
                Spacer().frame(height: 30)
            }
        }
        // ❌ 删除这个 onAppear，不再自动计数
        // .onAppear {
        //     progressVM.incrementCompletion(for: dishName)
        // }
        .confirmationDialog("Share your creation", isPresented: $showingPhotoOptions, titleVisibility: .visible) {
            Button("Take Photo") {
                showCamera = true
            }
            Button("Choose from Library") {
                showPhotoPicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
        }
        .sheet(isPresented: $showPhotoPicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
        }
    }
    
    // MARK: - AI Verification
    @MainActor
    func verifyAndComplete() async {
        guard let image = selectedImage else { return }
        
        isVerifying = true
        verificationMessage = nil
        
        let prompt = """
        You are a judge for a cooking game. The user claims they made: "\(dishName)".
        Look at the photo and decide if it shows this dish.
        
        Respond with ONLY a JSON object in this exact format:
        {"match": true/false, "reason": "short explanation"}
        
        Be strict: only return true if the photo clearly matches the dish name.
        """
        
        do {
            let response = try await model.generateContent(prompt, image)
            
            if let text = response.text,
               let jsonData = text.data(using: .utf8),
               let result = try? JSONDecoder().decode(VerificationResult.self, from: jsonData) {
                
                if result.match {
                    verificationSuccess = true
                    verificationMessage = "✅ Verified! \(result.reason)"
                    
                    // ✅ 只在验证通过时才计数
                    if !hasCompleted {
                        hasCompleted = true
                        progressVM.incrementCompletion(for: dishName)
                    }
                    
                    // 上传照片
                    isUploading = true
                    photoVM.uploadPhoto(image: image, dishName: dishName)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isUploading = false
                        onSkip()
                    }
                } else {
                    verificationSuccess = false
                    verificationMessage = "❌ Not verified: \(result.reason)"
                    isVerifying = false
                }
            } else {
                verificationMessage = "AI analysis failed. Please try again."
                isVerifying = false
            }
        } catch {
            print("Gemini error: \(error)")
            verificationMessage = "Verification error: \(error.localizedDescription)"
            isVerifying = false
        }
    }
}

// JSON 解析结构
struct VerificationResult: Codable {
    let match: Bool
    let reason: String
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    FinishView(
        onSkip: {},
        dishName: "Beijing Zhajiang Mian"
    )
    .environmentObject(ProgressViewModel())
    .environmentObject(PhotoViewModel())
}
