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
    @State var isError: Bool = false
    @State var showAlert: Bool = false
    @State var selectedFriend: [String: String]?

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(friends, id: \.self) { friend in
                        FriendCardView(friend: friend, locations: $locations, isLoading: $isLoading, isError: $isError)
                            .onLongPressGesture {
                                withAnimation {
                                    selectedFriend = friend
                                    showAlert = true
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
//            getLocation()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Confirmation"),
                  message: Text("Voulez-vous vraiment supprimer cet ami ?"),
                  primaryButton: .destructive(Text("Supprimer")) {
                    withAnimation {
                        friends.removeAll(where: { $0 == selectedFriend })
                        UserDefaults.standard.set(friends, forKey: "friends")
                    }
                  },
                  secondaryButton: .cancel()
            )
        }
    }

    func getLocation() {
        isLoading = true
        isError = false
        LocationsManager.shared.getLocations { _ in
        } onSucces: { locations in
            self.locations = locations
            isLoading = false
        } onError: { error in
            print(error)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            isLoading = true
            isError = true
        }
    }
}

struct FriendCardView: View {
    var friend: [String: String]
    @Binding var locations: [Location]
    @Binding var isLoading: Bool
    @Binding var isError: Bool
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
                            .foregroundColor(isError == true ? .red : .primary )
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
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
}
