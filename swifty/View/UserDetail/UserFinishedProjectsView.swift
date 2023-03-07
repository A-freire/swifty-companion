//
//  FinishedProjectsView.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 28/02/2023.
//

import SwiftUI

struct UserFinishedProjectsView: View {
    @State var showAll: Bool = false
    let projects: [FinishedProject]

    var body: some View {
        VStack {
            HStack {
                Text("Finished projects")
                    .bold()
                Spacer()
                if projects.count > 3 {
                    Button {
                        showAll = true
                    } label: {
                        Text("See all projects")
                    }
                    .navigationDestination(isPresented: $showAll) {
                        AllFinishedProjectCardView(projects: projects)
                    }
                }
            }
            ForEach(projects.prefix(3), id: \.self) { project in
                FinishedProjectCardView(project: project)
            }
        }
    }
}

struct AllFinishedProjectCardView: View {
    let projects: [FinishedProject]

    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(projects, id: \.self) { project in
                FinishedProjectCardView(project: project)
            }
        }
        .navigationTitle("Finished projects")
        .padding(.horizontal)
    }
}

struct FinishedProjectCardView: View {
    let project: FinishedProject

    var body: some View {
        ZStack {
            Color.gray
                .cornerRadius(15)
            HStack {
                Text(project.name + " - " + project.time.timeAgoSinceDate())
                Spacer()
                Text("\(project.mark)")
                    .foregroundColor(project.mark >= 100 ? Color(hex: "#60d56b") : Color(hex: "#e4000f"))
                // true
                // 60d56b = chat gpt
                // ffff00 = yellow
                // 4BB543 = success green
                // false
                // EE4B2B = Dark Candy Apple Red
                // f93822 = pentone bright red
                // e4000f = nintendo red
            }
            .padding(10)
        }
    }
}
