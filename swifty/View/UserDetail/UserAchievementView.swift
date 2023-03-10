//
//  UserAchievementView.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 01/03/2023.
//

import SwiftUI
import Kingfisher
import SDWebImage
import SDWebImageSwiftUI

struct UserAchievementView: View {
    @State var showAll: Bool = false
    let userId: Int
    let achievements: [Achievement]
    @Binding var sortedListAchievement: [AchievementData]

    var allAchievements: [Achievement] {
        var tab: [Achievement] = []

        sortedListAchievement.forEach { data in
            achievements.forEach { achi in
                if data.achievement_id == achi.id {
                    tab.append(achi)
                }
            }
        }
        return tab
    }

    var body: some View {
        VStack {
            HStack {
                Text("Achievements")
                    .bold()
                Spacer()
                if allAchievements.count > 3 {
                    Button {
                        showAll = true
                    } label: {
                        Text("See all projects")
                    }
                    .navigationDestination(isPresented: $showAll) {
                        AllAchievementsCardView(achievements: allAchievements)
                    }
                }
            }
            if !allAchievements.isEmpty {
                AchievementsCardView(achievements: allAchievements)
            }
        }
    }
}

struct AllAchievementsCardView: View {
    let achievements: [Achievement]
    @State var showAchievement: Bool = false
    @State var focus: Achievement?

    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(achievements.chunked(into: 3), id: \.self) { chunk in
                HStack(spacing: 16) {
                    ForEach(chunk, id: \.self) { achievement in
                        VStack {
                            WebImage(url: achievement.getImageURL())
                                .resizable()
                                .frame(width: 80, height: achievement.kind == "scolarity" ? 100 : 80)
                                .onTapGesture {
                                    showAchievement = true
                                    focus = achievement
                                }
                            Text(achievement.name)
                                .lineLimit(4)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: 100, maxHeight: 200)
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Achievements")
        .padding(.horizontal)
        .navigationDestination(isPresented: $showAchievement) {
            AchievememtDetailView(focus: $focus)
        }
    }
}

struct AchievementsCardView: View {
    let achievements: [Achievement]

    var body: some View {
        ZStack {
            Color.gray
                .cornerRadius(15)
            HStack {
                ForEach(achievements.prefix(3), id: \.self) { achievement in
                    VStack {
                        WebImage(url: achievement.getImageURL())
                            .resizable()
                            .frame(width: 80, height: achievement.kind == "scolarity" ? 100 : 80)
                        Text(achievement.name)
                            .lineLimit(4)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: 100, maxHeight: 200)
                    .padding(.vertical)
                }
            }
        }
    }
}

struct AchievememtDetailView: View {
    @Binding var focus: Achievement?

    var body: some View {
        if let achievement = focus {
            VStack {
                Spacer()
                WebImage(url: achievement.getImageURL())
                    .resizable()
                    .frame(width: 240, height: achievement.kind == "scolarity" ? 300 : 240)
                Rectangle()
                    .background(Color.clear)
                    .foregroundColor(.clear)
                    .frame(height: 42)
                Text(achievement.name)
                    .font(.title)
                    .padding()
                Text(achievement.description)
                Spacer()
            }
        }
    }
}
