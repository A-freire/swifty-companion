//
//  FinishedProjectsView.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 28/02/2023.
//

import SwiftUI

struct UserFinishedProjectsView: View {
    @State var showAll: Bool = false
    let projects: [ProjectUsers]

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
    let projects: [ProjectUsers]

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
    let project: ProjectUsers
    @State var projectInfo: Project?
    @State var showProject: Bool = false

    var body: some View {
        ZStack {
            Color.gray
                .cornerRadius(15)
            HStack {
                Text(project.project.name + " - " + (project.marked_at?.timeAgoSinceDate() ?? ""))
                    .padding(10)
                Spacer()
                ZStack {
// swiftlint:disable:next line_length
                    LinearGradient(colors: [(project.final_mark ?? 0) >= 100 ? Color(hex: "#339966") : Color(hex: "#990000"), .clear],
                                   startPoint: .trailing, endPoint: .center)
                    .cornerRadius(15)
                    HStack {
                        Spacer()
                        Text("\(project.final_mark ?? 0)")
                    }
                    .padding(10)
//                        .foregroundColor(project.mark >= 100 ? Color(hex: "#339966") : Color(hex: "#990000"))
                }
                // true
                // 339966 = matmorva
                // 60d56b = chat gpt
                // ffff00 = yellow
                // 4BB543 = success green
                // false
                // 990000 = matmorva
                // EE4B2B = Dark Candy Apple Red
                // f93822 = pentone bright red
                // e4000f = nintendo red
            }
        }
        .onTapGesture {
            ProjectManager.shared.getProject(idProject: project.id) { _ in
            } onSucces: { project in
                self.projectInfo = project
                showProject = true
            } onError: { error in
                print(error)
            }
        }
        .navigationDestination(isPresented: $showProject) {
            if let projectInfo = projectInfo {
                ProjectView(project: projectInfo)
            }
        }
    }
}
