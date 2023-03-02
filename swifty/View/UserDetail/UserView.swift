//
//  UserView.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 28/02/2023.
//

import SwiftUI
import Kingfisher

struct UserView: View {
    @Binding var user: User?
    @State var showPicture: Bool = false
    @State var color: String = "#FFFFFF"
    @State var sortedListAchievement: [AchievementData] = []
    @State var isLoading: Bool = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        if let user = user {
            ScrollView(showsIndicators: false) {
                if let user = user {
                    UserCardView(color: $color,
                                 imageUrl: user.getUrlPicture(),
                                 groups: user.groups,
                                 title: user.getTitle(),
                                 place: user.location ?? "not available",
                                 level: user.getLevel(),
                                 state: user.getBlackholeState(),
                                 timer: user.getBlackHoleTime() ?? 0,
                                 showPicture: $showPicture,
                                 login: user.login)
                    .padding(.bottom)
                    UserOnGoingProjectView(projects: user.getOnGoingProject())
                        .padding(.bottom)
                    UserFinishedProjectsView(projects: user.getFinishedProject())
                        .padding(.bottom)
                    UserSkillsView(projects: user.getSkills())
                        .padding(.bottom)
                    UserAchievementView(userId: user.id, achievements: user.achievements, sortedListAchievement: $sortedListAchievement)
                        .padding(.bottom)
                }
            }
            .onReceive(timer, perform: { _ in
                getColor()
            })
            .onAppear(perform: {
                getAchievement()
            })
            .navigationTitle(user.login)
            .padding(.horizontal)
            .overlay {
                if showPicture == true {
                    ZStack {
                        Color.black
                            .opacity(0.8)
                            .ignoresSafeArea()
                        VStack {
                            KFImage(user.getUrlPicture())
                                .resizable()
                                .scaledToFit()
                                .onTapGesture {
                                    withAnimation {
                                        showPicture = false
                                    }
                                }
                            Text(user.displayName)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }

    func getColor() {
        if color == "#FFFFFF" && isLoading == false {
            UserManager.shared.getColorCoa(login: user?.login ?? "") { loading in
                isLoading = loading
            } onSucces: { color in
                self.color = color
//                getAchievement()
            } onError: { error in
                print(error)
            }
        }
    }

    func getAchievement() {
        if sortedListAchievement.isEmpty {
            UserAchievementManager.shared.getAchievementsList(userId: user?.id ?? 0) { _ in
            } onSucces: { datas in
                self.sortedListAchievement = datas
                getColor()
            } onError: { error in
                print(error)
            }
        }
    }
}
