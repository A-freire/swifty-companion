//
//  UserSearchView.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 27/02/2023.
//

import SwiftUI
import Lottie
import UIKit

struct UserSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var loginIsFocused: Bool
    @State var login: String = ""
    @State var isLoading: Bool = false
    @State var showUser: Bool = false
    @State var user: User?
    @State var histo: [[String: String]]? = UserDefaults.standard.object(forKey: "historique") as? [[String: String]]
    @State var isError: Bool = false
    let generator = UINotificationFeedbackGenerator()

    var cleanLogin: String {
        let allowedCharacters = CharacterSet(charactersIn: "qwertyuiopasdfghjklzxcvbnm-")
            return login.lowercased().components(separatedBy: allowedCharacters.inverted).joined(separator: "")
    }

    var body: some View {
        VStack {
            if login != "" {
                SearchUserByCampusView(showUser: $showUser, user: $user, login: $login)
                    .scrollDismissesKeyboard(.never)
                    .simultaneousGesture(
                        TapGesture().onEnded({ _ in
                            loginIsFocused = false
                        })
                    )
            } else {
                HistoriqueView(histo: $histo, showUser: $showUser, user: $user)
                    .scrollDismissesKeyboard(.immediately)
                    .simultaneousGesture(
                        TapGesture().onEnded({ _ in
                            loginIsFocused = false
                        })
                    )
            }
            HStack {
                TextField("Login", text: $login)
                    .focused($loginIsFocused)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .onChange(of: login) { _ in
                        isError = false
                    }
                if login != "" {
                    Button {
                        login = ""
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .frame(width: 21, height: 21)
                            .padding(10)
                    }
                    .foregroundColor(.gray)
                }
                Button {
                    getUser(login: cleanLogin)
                } label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 21, height: 21)
                        .padding(10)
                }
                .onChange(of: showUser) { _ in
                    guard showUser == true else {return}
                    if let user = user {
                        historique(login: user.login, image: user.image)
                    }
                }
                .foregroundColor(isError == true ? .red : .accentColor)
            }
            .padding(.bottom)
        }
        .navigationDestination(isPresented: $showUser, destination: {
            UserView(user: $user)
        })
    }

    func historique(login: String, image: String) {
        if histo == nil {
            var dic: [[String: String]] = []
            dic.append([login: image])
            histo = dic
            UserDefaults.standard.set(dic, forKey: "historique")
        } else {
            guard !histo!.contains([login: image]) else {return}
            var dic: [[String: String]] = histo!
            dic.append([login: image])
            histo = dic
            UserDefaults.standard.set(dic, forKey: "historique")
        }
    }

    func getUser(login: String) {
        UserManager.shared.getUser(login: login) { _ in
        } onSucces: { user in
            generator.notificationOccurred(.success)
            loginIsFocused = false
            self.user = user
            self.showUser = true
        } onError: { error in
            generator.notificationOccurred(.error)
            self.isError = true
            print(error)
        }
    }
}

struct SearchUserByCampusView: View {
    @Binding var showUser: Bool
    @Binding var user: User?
    @Binding var login: String
    @State var list: [[String: String]] = []

    var cleanLogin: String {
        let allowedCharacters = CharacterSet(charactersIn: "qwertyuiopasdfghjklzxcvbnm-")
            return login.lowercased().components(separatedBy: allowedCharacters.inverted).joined(separator: "")
    }

    var body: some View {
        VStack {
            HStack {
                Text("Sugestion")
                    .padding([.leading])
                Spacer()
            }
            ScrollView(showsIndicators: false) {
                ForEach(Array(list), id: \.self) { list in
                    HistoriqueCardView(showUser: $showUser, user: $user, list: list)
                }
            }
            .padding(.horizontal)
        }
        .onChange(of: login) { _ in
            UserManager.shared.searchUserByCampus(login: cleanLogin) { _ in
            } onSucces: { users in
                list = users.map({ user in
                    [user.login: user.image]
                })
            } onError: { error in
                print(error)
            }
        }
    }
}
