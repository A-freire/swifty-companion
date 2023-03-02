//
//  TokenAPIView.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 27/02/2023.
//

import SwiftUI

struct TokenAPIView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var uid: String = UserDefaults.standard.string(forKey: "uid") ?? ""
    @State var secret: String = UserDefaults.standard.string(forKey: "secret") ?? ""
    @State var showSearch: Bool = false
    @State var isLoading: Bool = false

    var body: some View {
        VStack {
            VStack {
                TextField("UID", text: $uid)
                    .padding([.vertical], 5)
                TextField("Secret", text: $secret)
                    .padding([.vertical], 5)
            }
            .padding(.horizontal)
            Button(action: {
                isLoading = true
                UserDefaults.standard.set(uid, forKey: "uid")
                UserDefaults.standard.set(secret, forKey: "secret")
                CredManager.shared.connexion { _ in
                } onSucces: {
                    isLoading = false
                    showSearch = true
                    print("let's go")
                } onError: { error in
                    print(error)
                    isLoading = false
                }
            }, label: {
                Text("Connexion")
            })
            .disabled(!(uid != "" && secret != ""))
            .padding(.vertical)
            .navigationDestination(isPresented: $showSearch) {
                UserSearchView()
            }
        }
        .navigationTitle("UID/SECRET")
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if isLoading == true {
                VStack {
                    LottieView(name: colorScheme == .dark ? "loading-files-black" : "loading-files-white",
                               loopMode: .loop)
                        .scaledToFill()
                }
                .frame(height: 1000)
            }
        }
    }
}
