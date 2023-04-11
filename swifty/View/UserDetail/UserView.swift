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
    @State var errorCount: Int = 0
    @State var achievementGood: Bool = false
    @State var colorGood: Bool = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    var body: some View {
        if let user = user {
            ScrollView(showsIndicators: false) {
                UserCardView(color: $color,
                             imageUrl: user.getUrlPicture(),
                             groups: user.groups,
                             title: user.getTitle(),
                             place: user.location,
                             lastActivity: user.updated_at,
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
                UserSkillsView(projects: user.getSkills(), color: $color)
                    .padding(.bottom)
                UserAchievementView(userId: user.id,
                                    achievements: user.achievements,
                                    sortedListAchievement: $sortedListAchievement)
            }
            .toolbar(content: {
                Menu(content: {
                    Button("intra") {
                        UIApplication.shared.open(URL(string: "https://profile.intra.42.fr/users/" + user.login)!)
                    }
                    Button("amis") {
                        addFriend(login: user.login, image: user.image)
                    }
                    Button("dl photo") {
                        downloadAndSaveImage(url: user.image)
                    }
                }, label: {
                    Text("...")
                })
            })
            .onReceive(timer, perform: { _ in
                getAchievement()
                getColor()
            })
            .onAppear(perform: {
                getAchievement()
                getColor()
            })
            .navigationTitle(user.login)
            .padding(.horizontal)
            .overlay {
                if showPicture == true {
                    FocusPictureView(user: user, showPicture: $showPicture)
                }
            }
        }
    }
    func downloadAndSaveImage(url: String) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            } else {
                DispatchQueue.main.async {
                    alertTitle = "Erreur"
                    alertMessage = "Impossible de télécharger l'image"
                    showAlert = true
                }
            }
        }.resume()
    }

    func getColor() {
        if color == "#FFFFFF" && errorCount < 5 && colorGood == false {
            UserManager.shared.getColorCoa(login: user?.login ?? "") { loading in
                isLoading = loading
            } onSucces: { color in
                self.color = color
                errorCount = 0
                colorGood = true
            } onError: { error in
                print(error)
                errorCount += 1
            }
        }
    }

    func getAchievement() {
        if sortedListAchievement.isEmpty && errorCount < 5 && achievementGood == false {
            UserAchievementManager.shared.getAchievementsList(userId: user?.id ?? 0) { loading in
                isLoading = loading
            } onSucces: { datas in
                self.sortedListAchievement = datas
                errorCount = 0
                achievementGood = true
            } onError: { error in
                print(error)
                errorCount += 1
            }
        }
    }

    func addFriend(login: String, image: String) {
        var tab: [[String: String]] = UserDefaults.standard.object(forKey: "friends") as? [[String: String]] ?? []
        guard !tab.contains([login: image]) else {return}
        tab.append([login: image])
        UserDefaults.standard.set(tab, forKey: "friends")
    }
}

struct FocusPictureView: View {
    var user: User
    @Binding var showPicture: Bool

    var body: some View {
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
