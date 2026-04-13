//
//  RecipeCompleteView.swift
//  CCG
//
//  Created by H2026215 on 2026/1/30.
//
//
//  RecipeCompleteView.swift
//  CCG
//
//  Created by H2026215 on 2026/1/30.
//
import SwiftUI
import PhotosUI


struct FinishView: View {
    let onSkip: () -> Void
    let dishName: String
    @EnvironmentObject var progressVM: ProgressViewModel
    @EnvironmentObject var photoVM: PhotoViewModel
    
    @State private var showCamera = false
    @State private var showPhotoPicker = false
    @State private var selectedImage: UIImage?
    @State private var showingPhotoOptions = false
    @State private var isUploading = false
    @State private var uploadSuccess = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                Text("Congratulations！\n\nYou’ve finished the\n dish of this level!")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                    .multilineTextAlignment(.center)
                
                Text("🎉")
                    .font(.system(size: 100))
                    .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
                
                Spacer()
                
                // 拍照按钮
                Button(action: {
                    showingPhotoOptions = true
                }) {
                    HStack {
                        Image(systemName: "camera.fill")
                        Text("Share Your Dish")
                    }
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(red: 0.34, green: 0.24, blue: 0.51))
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
                }
                .disabled(isUploading)
                
                // 上传中状态
                if isUploading {
                    HStack {
                        ProgressView()
                            .tint(Color(red: 0.34, green: 0.24, blue: 0.51))
                        Text("Uploading...")
                            .foregroundColor(.gray)
                    }
                }
                
                // 上传成功提示
                if uploadSuccess {
                    Text("Photo uploaded! ✅")
                        .foregroundColor(.green)
                        .font(.caption)
                }
                
                Button(action: {
                    onSkip()
                }) {
                    Text("Skip")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color(red: 0.34, green: 0.24, blue: 0.51).opacity(0.8))
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                }
                
                Spacer().frame(height: 50)
            }
        }
        .onAppear {
            progressVM.incrementCompletion(for: dishName)
        }
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
        .onChange(of: selectedImage) { newImage in
            if let image = newImage {
                isUploading = true
                photoVM.uploadPhoto(image: image, dishName: dishName)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isUploading = false
                    uploadSuccess = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        uploadSuccess = false
                    }
                    selectedImage = nil
                }
            }
        }
    }
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
