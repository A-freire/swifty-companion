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
    @State var login: String = ""
    @State var isLoading: Bool = false
    @State var showUser: Bool = false
    @State var user: User?
    @State var histo: [[String: String]]? = UserDefaults.standard.object(forKey: "historique") as? [[String: String]]
    @State var isError: Bool = false
    let generator = UINotificationFeedbackGenerator()

    var cleanLogin: String {
        return login.lowercased().replacingOccurrences(of: " ", with: "")
    }

    var body: some View {
        VStack {
            HistoriqueView(histo: $histo, showUser: $showUser, user: $user)
            HStack {
                TextField("Login", text: $login)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .onChange(of: login) { _ in
                        isError = false
                    }
                Button {
                    searchUser(login: cleanLogin)
                } label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 21, height: 21)
                        .padding(10)
                }
                .foregroundColor(isError == true ? .red : .accentColor)
            }
            .padding(.bottom)
        }
        .navigationDestination(isPresented: $showUser, destination: {
            UserView(user: $user)
        })
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
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

    func searchUser(login: String) {
        UserManager.shared.getUser(login: login) { _ in
        } onSucces: { user in
            generator.notificationOccurred(.success)
            self.user = user
            self.showUser = true
            historique(login: user.login, image: user.image)
        } onError: { error in
            generator.notificationOccurred(.error)
            self.isError = true
            print("Error")
        }
    }
}
