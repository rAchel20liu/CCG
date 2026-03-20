//
//  Chapter.swift
//  CCG
//
//  Created by H2026215 on 2026/1/16.
//
import SwiftUI

// MARK: - Model
struct Dish: Identifiable {
    let id = UUID()
    let number: Int
    let name: String
}

// MARK: - 单个大椭圆按钮
struct ChapterRow: View {
    let dish: Dish
    let isCompleted: Bool
    // 在 ChapterView.swift 顶部添加：
    
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

                    Text("\(dish.number)")
                        .font(.custom("Reggae One", size: 28))
                        .foregroundColor(.white)
                    
                    if isCompleted {
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.yellow)
                            .offset(y: 25)  // 向下偏移到圆圈底部
                            .shadow(color:.black.opacity(0.3), radius: 1, x: 0, y: 1)
                    }
                }

                Text(dish.name)
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

// MARK: - Chapter View
struct ChapterView: View {

    let cityName: String
    let dishes: [Dish]

    @State private var searchText = ""
    @EnvironmentObject var progressVM: ProgressViewModel

    private var filteredDishes: [Dish] {
        searchText.isEmpty
        ? dishes
        : dishes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {

            // 顶部搜索栏
            VStack(spacing: 12) {
                HStack {
                    Spacer()

                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)

                        TextField("Search", text: $searchText)
                            .font(.system(size: 16))
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(100)
                }
                .padding(.horizontal, 100)
                .padding(.top, 60)
                .padding(.bottom, 12)
                .background(Color.white)
            }

            // 内容
            ScrollView {
                VStack(spacing: 28) {
                    ForEach(filteredDishes) { dish in
                        NavigationLink {
                            if let dishInfo = dishInfoForDish(dish) {
                                DishDetailView(dish: dishInfo)
                                    
                                .environmentObject(progressVM)
                            }
                        }
                        label: {
                            ChapterRow(dish: dish,isCompleted: progressVM.badgeLevel(for: dish.name) != .none)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .top)

    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ChapterView(
            cityName: "Beijing",
            dishes: ChapterData.beijing
        )
        .environmentObject(ProgressViewModel())
    }
}

// MARK: - Dish → Ingredients mapping
func dishInfoForDish(_ dish: Dish) -> DishInfo? {
    switch dish.name {
    case "Beijing Zhajiang Mian":
        return DishData.zhajiangMian
    case "Peking Duck":
        return DishData.pekingDuck
    case "Shredded Pork with Scallions":
        return DishData.shreddedPorkWithScallions
    default:
        return nil
    }
}
