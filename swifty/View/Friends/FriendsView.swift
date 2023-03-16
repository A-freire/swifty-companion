//
//  FriendsView.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 15/03/2023.
//

import SwiftUI
import Kingfisher

struct FriendsView: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    @State var friends: [String] = []
    @State var count: Int = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(friends, id: \.self) { login in
                        FriendCardView(login: login)
                            .onLongPressGesture {
                                withAnimation {
                                    friends.removeAll(where: {$0 == login})
                                    UserDefaults.standard.set(friends, forKey: "friends")
                                }
                            }
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Friends")
        .onAppear {
            friends = UserDefaults.standard.object(forKey: "friends") as? [String] ?? []
        }
    }
}

struct FriendCardView: View {
    var login: String
    @State var user: User?
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var isGood: Bool = false
    @State var showUser: Bool = false

    var body: some View {
        VStack {
            ZStack {
                Color.gray
                    .cornerRadius(15)
                if let friend = user {
                    VStack {
                        KFImage(friend.getUrlPicture())
                            .resizable()
                            .scaledToFill()
                            .frame(width: 84, height: 84)
                            .clipShape(Circle())
                        Text(friend.login)
                        Text(friend.location == nil ? "unavailable" : friend.location ?? "")
                    }
                    .padding(10)
                    .onTapGesture {
                        showUser = true
                    }
                }
            }
        }
        .navigationDestination(isPresented: $showUser, destination: {
            UserView(user: $user)
        })
//        .redacted(reason: isGood == false ? .placeholder : [])
        .onReceive(timer, perform: { _ in
            getUser()
        })
        .onAppear {
            isGood = false
            getUser()
        }
    }

    func getUser() {
        if isGood == false {
            UserManager.shared.getUser(login: login) { _ in
                isGood = true
            } onSucces: { user in
                self.user = user
                isGood = true
            } onError: { error in
                print(error)
                isGood = false
            }
        }
    }
}
