//
//  PoulainView.swift
//  swifty
//
//  Created by Adrien freire on 16/06/2023.
//

import SwiftUI
import Kingfisher

struct PoulainView: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    @State var poulain: [String: String] = [:]
    @State var showUser: Bool = false
    @State var user: User?
    @State var locations: [Location] = []
    @State var isLoading: Bool = false
    @State var isError: Bool = false
    @State var showAlert: Bool = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Array(poulain), id: \.key) { login, image in
                    ZStack {
                        Color.gray
                            .cornerRadius(15)
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
                    }
                    .onTapGesture {
                        getUser(login: login)
                    }
                    .onLongPressGesture {
                        withAnimation {
                            showAlert = true
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Confirmation"),
                              message: Text("Voulez-vous vraiment supprimer cet ami ?"),
                              primaryButton: .destructive(Text("Supprimer")) {
                                withAnimation {
                                    poulain.removeValue(forKey: login)
                                    UserDefaults.standard.set(poulain, forKey: "poulain")
                                }
                              },
                              secondaryButton: .cancel()
                        )
                    }
                }
            }
        }
        .padding(.horizontal)
        .refreshable {
            getLocation()
        }
        .onAppear {
            poulain = UserDefaults.standard.object(forKey: "poulain") as? [String: String] ?? [:]
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
