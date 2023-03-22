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
    @State var friends: [[String: String]] = []
    @State var count: Int = 0
    @State var locations: [Location] = []
    @State var isLoading: Bool = false

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(friends, id: \.self) { friend in
                        FriendCardView(friend: friend, locations: $locations, isLoading: $isLoading)
                            .onLongPressGesture {
                                withAnimation {
                                    friends.removeAll(where: {$0 == friend})
                                    UserDefaults.standard.set(friends, forKey: "friends")
                                }
                            }
                    }
                }
            }
            .refreshable {
                getLocation()
            }
            .padding(.horizontal)
        }
        .task {
            friends = UserDefaults.standard.object(forKey: "friends") as? [[String: String]] ?? []
            getLocation()
        }
    }

    func getLocation() {
        isLoading = true
        LocationsManager.shared.getLocations { _ in
        } onSucces: { locations in
        print("j'ai les locations")
            self.locations = locations
            isLoading = false
        } onError: { error in
            print(error)
        }
    }
}

struct FriendCardView: View {
    var friend: [String: String]
    @Binding var locations: [Location]
    @Binding var isLoading: Bool
    @State var user: User?
    @State var showUser: Bool = false

    var body: some View {
        VStack {
            ZStack {
                Color.gray
                    .cornerRadius(15)
                ForEach(Array(friend), id: \.key) { login, image in
                    VStack {
                        KFImage(URL(string: image))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 84, height: 84)
                            .clipShape(Circle())
                        Text(login)
                        Text(locations.first(where: { $0.user.login == login })?.host ?? "unavailable")
                            .redacted(reason: isLoading == true ? .placeholder : [])
                    }
                    .padding(10)
                    .onTapGesture {
                        getUser(login: login)
                    }
                }
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
            showUser = true
        } onError: { error in
            print(error)
        }
    }
}
