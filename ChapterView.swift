//
//  Chapter.swift
//  CCG
//
//  Created by H2026215 on 2026/1/16.
//

import SwiftUI



struct ChapterView: View {
    let region: Region
    
    @EnvironmentObject var progressVM: ProgressViewModel
    @StateObject private var dataService = DataService.shared
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    
    private var dishes: [FirestoreDish] {
        dataService.getDishes(for: region)
    }
    
    private var filteredDishes: [FirestoreDish] {
        if searchText.isEmpty {
            return dishes
        } else {
            return dishes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 28) {
                    if filteredDishes.isEmpty && !searchText.isEmpty {
                        VStack(spacing: 20) {
                            Spacer().frame(height: 100)
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("No matching dishes")
                                .font(.title3)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        ForEach(filteredDishes) { dish in
                            NavigationLink {
                                let dishInfo = DishInfo.from(dish)
                                DishDetailView(dish: dishInfo)
                                    .environmentObject(progressVM)
                            } label: {
                                ChapterRow(
                                    dishName: dish.name,
                                    dishNumber: dish.number,
                                    isCompleted: progressVM.badgeLevel(for: dish.name) != .none
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
        .background(Color.white)
        .navigationTitle(region.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search", text: $searchText)
                        .font(.system(size: 16))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .frame(width: 180)
                }
                .padding(8)
                .background(Color.white)
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.3), lineWidth: 1))
            }
        }
    }
}

// 单独的行组件
struct ChapterRow: View {
    let dishName: String
    let dishNumber: Int
    let isCompleted: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 999)
                .fill(.ultraThinMaterial)
                .frame(height: 55)
            
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.34, green: 0.24, blue: 0.51))
                        .frame(width: 64, height: 64)
                    Text("\(dishNumber)")
                        .font(.custom("Reggae One", size: 28))
                        .foregroundColor(.white)
                    if isCompleted {
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.yellow)
                            .offset(y: 25)
                    }
                }
                Text(dishName)
                    .font(.custom("Roboto", size: 18))
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 24)
        }
    }
}


#Preview {
    NavigationStack {
        // 需要传入一个真实的 Region 对象用于预览
        let sampleRegion = Region(
            id: "beijing",
            name: "Beijing",
            coverImage: "beijing",
            order: 1,
            dishId: ["beijingSoyBeanPasteNoodles"]
        )
        ChapterView(region: sampleRegion)
            .environmentObject(ProgressViewModel())
    }
}
