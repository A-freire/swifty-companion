//
//  UserOnGoingProjectView.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 28/02/2023.
//

import SwiftUI

struct UserOnGoingProjectView: View {
    @State var showAll: Bool = false
    let projects: [ProjectUsers]

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
            ForEach(projects.prefix(3), id: \.self) { project in
                OnGoingProjectCardView(name: project.project.name, idProject: project.id)
            }
        }
    }
}

struct AllOnGoingProjectCardView: View {
    let projects: [ProjectUsers]

    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(projects, id: \.self) { project in
                OnGoingProjectCardView(name: project.project.name, idProject: project.id)
            }
        }
        .navigationTitle("Ongoing projects")
        .padding(.horizontal)
    }
}

struct OnGoingProjectCardView: View {
    let name: String
    let idProject: Int
    @State var project: Project?
    @State var showProject: Bool = false

    var body: some View {
        ZStack {
            Color.gray
                .cornerRadius(15)
            HStack {
                Text(name)
                    .padding(10)
                Spacer()
            }
            .onTapGesture {
                ProjectManager.shared.getProject(idProject: idProject) { _ in
                } onSucces: { project in
                    self.project = project
                    showProject = true
                } onError: { error in
                    print(error)
                }
            }
        }
        .navigationDestination(isPresented: $showProject) {
            if let project = project {
                ProjectView(project: project)
            }
        }
    }
}
