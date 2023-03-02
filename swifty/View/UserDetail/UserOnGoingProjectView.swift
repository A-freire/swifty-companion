//
//  UserOnGoingProjectView.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 28/02/2023.
//

import SwiftUI

struct UserOnGoingProjectView: View {
    @State var showAll: Bool = false
    let projects: [String]

    var body: some View {
        VStack {
            HStack {
                Text("Ongoing projects")
                    .bold()
                Spacer()
                if projects.count > 3 {
                    Button {
                        showAll = true
                    } label: {
                        Text("See all projects")
                    }
                    .navigationDestination(isPresented: $showAll) {
                        AllOnGoingProjectCardView(projects: projects)
                    }
                }
            }
            ForEach(projects.prefix(3), id: \.self) { name in
                OnGoingProjectCardView(name: name)
            }
        }
    }
}

struct AllOnGoingProjectCardView: View {
    let projects: [String]

    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(projects, id: \.self) { name in
                OnGoingProjectCardView(name: name)
            }
        }
        .navigationTitle("Ongoing projects")
        .padding(.horizontal)
    }
}

struct OnGoingProjectCardView: View {
    let name: String

    var body: some View {
        ZStack {
            Color.gray
                .cornerRadius(15)
            HStack {
                Text(name)
                    .padding(10)
                Spacer()
            }
        }
    }
}
