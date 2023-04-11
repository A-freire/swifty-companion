//
//  HistoriqueUsersView.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 02/03/2023.
//

import SwiftUI
import Kingfisher

struct HistoriqueView: View {
    @Binding var histo: [[String: String]]
    @Binding var showUser: Bool
    @Binding var user: User?

    var body: some View {
        VStack {
            HStack {
                Text("Historique")
                    .padding([.leading])
                Spacer()
            }
            ScrollView(showsIndicators: false) {
                ForEach(Array(histo), id: \.self) { list in
                    HistoriqueCardView(showUser: $showUser, user: $user, list: list)
                        .onLongPressGesture {
                            withAnimation {
                                histo.removeAll(where: {$0 == list})
                                UserDefaults.standard.set(histo, forKey: "historique")
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct HistoriqueCardView: View {
    @Binding var showUser: Bool
    @Binding var user: User?
    var list: [String: String]

    var body: some View {
        ForEach(Array(list), id: \.key) { login, image in
            ZStack {
                Color.gray
                    .cornerRadius(15)
                HStack {
                    KFImage(URL(string: image))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 42, height: 42)
                        .clipShape(Circle())
                    Text(login)
                    Spacer()
                }
                .padding(10)
            }
            .onTapGesture {
                getUser(login: login)
            }
        }
    }

    func getUser(login: String) {
        UserManager.shared.getUser(login: login) { _ in
        } onSucces: { user in
            UIApplication.shared.inputViewController?.dismissKeyboard()
            self.user = user
            self.showUser = true
        } onError: { error in
            print(error)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
}
