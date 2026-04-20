//
//  Home.swift
//  UserLoginPage
//
//  Created by H2026215 on 2025/11/14.
// testing git
//
//
//  Home.swift
//  UserLoginPage
//
//  Created by H2026215 on 2025/11/14.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var progressVM: ProgressViewModel
    @State private var searchText = ""
    @State private var selectedTab = 0
    
    // 地区数据
    private let regions = [
        ("Beijing", "beijing", ChapterData.beijing),
        ("Sichuan", "sichuan", ChapterData.sichuan),
        ("Jiangsu", "jiangsu", ChapterData.jiangsu),
        ("Fujian", "fujian", ChapterData.fujian),
        ("Cantonese", "cantonese", ChapterData.cantonese),
        ("Anhui", "anhui", ChapterData.anhui),
        ("Shandong","shandong",ChapterData.shandong),
        ("Zhejiang","zhejiang",ChapterData.zhejiang),
        ("Hunan","hunan",ChapterData.hunan),
        ("Shanghai","shanghai",ChapterData.shanghai),
        ("Northeast","northeast",ChapterData.northeast),
        ("Northwest","northwest",ChapterData.northwest),
        ("Jiangxi","jiangxi",ChapterData.jiangxi),
        ("Guizhou","guizhou",ChapterData.guizhou),
        ("Yunnan","yunnan",ChapterData.yunnan)
    ]
    
    // 搜索过滤后的地区
    private var filteredRegions: [(title: String, imageName: String, dishes: [Dish])] {
        if searchText.isEmpty {
            return regions
        } else {
            return regions.filter { region in
                region.0.localizedCaseInsensitiveContains(searchText) ||
                region.2.contains { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                if selectedTab == 0 {
                    VStack(spacing: 0) {
                        topSearchBar
                            .padding(.bottom, 12)
                            .background(Color.white)
                            .zIndex(1)
                        
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 30) {
                                ForEach(filteredRegions, id: \.title) { region in
                                    NavigationLink {
                                        ChapterView(cityName: region.title, dishes: region.dishes)
                                            .environmentObject(progressVM)
                                    } label: {
                                        RegionCard(
                                            title: region.title,
                                            imageName: region.imageName,
                                            dishes: region.dishes
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                                
                                Spacer().frame(height: 70)
                            }
                            .padding(.top)
                            .padding(.bottom, 9)
                            .background(Color.white)
                        }
                    }
                } else if selectedTab == 1 {
                    ShowcaseView()
                } else {
                    ProfileView()
                }
                
                BottomTabBar(selectedTab: $selectedTab)
            }
            .background(Color.white)
            .navigationBarHidden(true)
        }
    }
    
    private var topSearchBar: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search by region or dish...", text: $searchText)
                    .font(.system(size: 16))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(11)
            .background(Color.white)
            .cornerRadius(100)
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            
            if !searchText.isEmpty {
                Button("Cancel") {
                    searchText = ""
                }
                .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
            }
            
            Spacer()
            
            NavigationLink {
                SettingsView()
                    .environmentObject(authVM)
            } label: {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(Color(red: 0.34, green: 0.24, blue: 0.51))
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
        .environmentObject(ProgressViewModel())
}
