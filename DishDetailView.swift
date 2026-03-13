//
//  DishDetailView.swift
//  CCG
//
//  Created by H2026215 on 2026/1/19.
//
import SwiftUI

struct DishDetailView: View {
    @EnvironmentObject var badgeVM: BadgeViewModel
    let dish: DishInfo
    @State private var peopleCount = 1
    @State private var showRecipe = false   // 控制导航到 RecipeFlowView

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {

                    Text(dish.description)
                        .font(.body)

                    Divider()

                    // Ingredients Header
                    VStack(alignment: .center, spacing: 20) {
                        Text("Ingredients")
                            .font(.title2)
                            .fontWeight(.semibold)

                        HStack(spacing: 12) {
                            Button {
                                if peopleCount > 1 { peopleCount -= 1 }
                            } label: {
                                Image(systemName: "minus")
                                    .frame(width: 28, height: 28)
                                    .background(Color(red: 0.34, green: 0.24, blue: 0.51))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }

                            Text("\(peopleCount)")
                                .font(.headline)

                            Button {
                                peopleCount += 1
                            } label: {
                                Image(systemName: "plus")
                                    .frame(width: 28, height: 28)
                                    .background(Color(red: 0.34, green: 0.24, blue: 0.51))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }

                    // Ingredients List
                    VStack(spacing: 16) {
                        ForEach(dish.ingredients) { item in
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text("\(Int(item.amountPerPerson * Double(peopleCount))) \(item.unit)")
                                    .fontWeight(.semibold)
                            }
                            Divider()
                        }
                    }

                    // 🔹 Start Button
                    Button {
                        showRecipe = true
                    } label: {
                        Text("I'm Ready, Start!")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .background(Color(red: 0.34, green: 0.24, blue: 0.51))
                            .cornerRadius(28)
                    }
                    .padding(.top, 24)

                }
                .padding()
            }

            // 🔹 NavigationDestination 跳转 RecipeFlowView
            .navigationDestination(isPresented: $showRecipe) {
                RecipeFlowView(dish: dish)
                    .environmentObject(badgeVM)
            }

        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(dish.dishname)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    NavigationStack {
        DishDetailView(dish: DishData.zhajiangMian)
    }
}
