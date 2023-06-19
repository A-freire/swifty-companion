//
//  PiscineView.swift
//  swifty
//
//  Created by Adrien freire on 14/06/2023.
//

import SwiftUI
import Kingfisher

struct PiscineView: View {
    @State var showUser: Bool = false
    @State var user: User?
    @State var pisciner: [PiscinerModel] = []
    @State var poulain: [String: String] = UserDefaults.standard.object(forKey: "poulain") as? [String: String] ?? [:]

    var sortedPisciner: [PiscinerModel] {
        return pisciner.sorted(by: { $0.level > $1.level })
    }
    var body: some View {
        ScrollView {
            ForEach(Array(sortedPisciner.enumerated()), id: \.element.id) { index, model in
                ZStack {
                    Color.gray
                        .cornerRadius(15)
                    HStack {
                        Text("\(index+1)") // Ajout du classement ici.
                            .padding(.trailing, 10)
                        KFImage(URL(string: model.image_link ?? NORMINET))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 42, height: 42)
                            .clipShape(Circle())
                        Text(model.id)
                        Spacer()
                        Text(String(format: "%.2f", model.level))
                    }
                    .padding(10)
                }
                .onTapGesture {
                    getUser(login: model.id)
                }
                .onLongPressGesture {
                    setPoulain(login: model.id, image: model.image_link ?? NORMINET)
                }
            }
        }
        .padding(.horizontal)
        .refreshable {
            setPisciner()
        }
        .onAppear {
            setPisciner()
        }
        .navigationDestination(isPresented: $showUser, destination: {
            UserView(user: $user)
        })
    }

    func setPisciner() {
        if let savedPisciners = UserDefaults.standard.object(forKey: "pisciner") as? Data {
            let decoder = JSONDecoder()
            if let loadedPisciners = try? decoder.decode([PiscinerModel].self, from: savedPisciners) {
                pisciner = loadedPisciners
            }
        }
    }

    func getUser(login: String) {
        UserManager.shared.getUser(login: login) { _ in
        } onSucces: { user in
            self.user = user
            self.showUser = true
        } onError: { error in
            print(error)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }

    func setPoulain(login: String, image: String) {
        if poulain.isEmpty {
            poulain[login] = image
            UserDefaults.standard.set(poulain, forKey: "poulain")
        } else {
            guard poulain[login] == nil else { return }
            poulain[login] = image
            UserDefaults.standard.set(poulain, forKey: "poulain")
        }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}

//struct PiscineCardView: View {
//    @State var showUser: Bool
//    @State var user: User?
//    var list: [String: String]
//
//    var body: some View {
//        ForEach(Array(list), id: \.key) { login, image in
//            ZStack {
//                Color.gray
//                    .cornerRadius(15)
//                HStack {
//                    KFImage(URL(string: image))
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 42, height: 42)
//                        .clipShape(Circle())
//                    Text(login)
//                    Spacer()
//                }
//                .padding(10)
//            }
//            .onTapGesture {
//                getUser(login: login)
//            }
//        }
//        .navigationDestination(isPresented: $showUser, destination: {
//            UserView(user: $user)
//        })
//    }
//
//    func getUser(login: String) {
//        UserManager.shared.getUser(login: login) { _ in
//        } onSucces: { user in
//            UIApplication.shared.inputViewController?.dismissKeyboard()
//            self.user = user
//            self.showUser = true
//        } onError: { error in
//            print(error)
//            UINotificationFeedbackGenerator().notificationOccurred(.error)
//        }
//    }
//}
