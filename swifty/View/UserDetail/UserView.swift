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
                    Button("poulain") {
                        setPoulain(login: user.login, image: user.image)
                    }
                    Button("dl photo") {
                        downloadAndSaveImage(url: user.image)
                    }
                }, label: {
                    Text("...")
                })
            })
            .refreshable {
                getUser(login: user.login)
            }
            .task {
                getColor()
            }
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
            UserManager.shared.getColorCoa(login: user?.login ?? "") { loading in
                isLoading = loading
            } onSucces: { color in
                self.color = color
//                usleep(500000) need for no error in correction else balek
                getAchievement()
            } onError: { error in
                print(error)
            }
    }

    func getAchievement() {
            UserAchievementManager.shared.getAchievementsList(userId: user?.id ?? 0) { loading in
                isLoading = loading
            } onSucces: { datas in
                self.sortedListAchievement = datas
            } onError: { error in
                print(error)
            }
    }

    func addFriend(login: String, image: String) {
        var tab: [[String: String]] = UserDefaults.standard.object(forKey: "friends") as? [[String: String]] ?? []
        guard !tab.contains([login: image]) else {return}
        tab.append([login: image])
        UserDefaults.standard.set(tab, forKey: "friends")
    }

    func setPoulain(login: String, image: String) {
        var poulain = UserDefaults.standard.object(forKey: "poulain") as? [String: String] ?? [:]
        guard poulain[login] == nil else { return }
        poulain[login] = image
        UserDefaults.standard.set(poulain, forKey: "poulain")
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    func getUser(login: String) {
        UserManager.shared.getUser(login: login) { _ in
        } onSucces: { user in
//            UINotificationFeedbackGenerator().notificationOccurred(.success)
            self.user = user
        } onError: { error in
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            print(error)
        }
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
