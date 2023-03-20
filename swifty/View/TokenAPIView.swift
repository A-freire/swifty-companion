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
    @State var selection: Int = 0
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
                CredManager.shared.connexion { loading in
                    isLoading = loading
                } onSucces: {
                    showSearch = true
                } onError: { error in
                    print(error)
                }
            }, label: {
                Text("Connexion")
            })
            .disabled(!(uid != "" && secret != ""))
            .padding(.vertical)
            .navigationDestination(isPresented: $showSearch) {
                TopBarNavigation()
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

struct TopBarNavigation: View {
    @State var showSearch: Bool = false
    @State var selection: Int = 0
    @State private var isDocumentPickerVisible = false

    var body: some View {
        TabView(selection: $selection) {
            UserSearchView()
                .tabItem({
                    Image(systemName: "person.fill.questionmark")
                        .resizable()
                })
                .tag(0)
            FriendsView()
                .tabItem({
                    Image(systemName: "person.3.fill")
                        .resizable()
                })
                .tag(1)
        }
        .navigationTitle(selection == 0 ? "Search" : "Friends")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            if selection == 1 {
                Menu(content: {
                    Button("upload friends list") {
                    }
                    Button("download friends list") {
                        self.isDocumentPickerVisible.toggle()
                    }
                }, label: {
                    Text("...")
                })
            }
        })
        .sheet(isPresented: $isDocumentPickerVisible) {
            if let jsonURL = saveStringArrayAsJSON(UserDefaults.standard.object(forKey: "friends") as? [String] ?? []) {
                DocumentPicker(jsonURL: jsonURL)
            }
        }
    }

    func saveStringArrayAsJSON(_ stringArray: [String]) -> URL? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: stringArray, options: .prettyPrinted)
            let tempDirectory = FileManager.default.temporaryDirectory
            let tempFileURL = tempDirectory.appendingPathComponent("output.json")
            try jsonData.write(to: tempFileURL)
            return tempFileURL
        } catch {
            print("Erreur: \(error.localizedDescription)")
            return nil
        }
    }
}
