//
//  PoulainView.swift
//  swifty
//
//  Created by Adrien freire on 16/06/2023.
//

import SwiftUI
import Kingfisher

struct PoulainView: View {
    @State var poulain: [String: String] = [:]
    @State var showUser: Bool = false
    @State var user: User?

    var body: some View {
        ScrollView {
            ForEach(Array(poulain), id: \.key) { login, image in
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
                .onLongPressGesture {
                    withAnimation {
                        poulain.removeValue(forKey: login)
                        UserDefaults.standard.set(poulain, forKey: "poulain")
                    }
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            if poulain.isEmpty {
                poulain = UserDefaults.standard.object(forKey: "poulain") as? [String: String] ?? [:]
            }
        }
        .navigationDestination(isPresented: $showUser, destination: {
            UserView(user: $user)
        })
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

}
