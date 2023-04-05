//
//  ProjectView.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 28/03/2023.
//

import SwiftUI
import Kingfisher

struct ProjectView: View {
    @State var project: Project

    var body: some View {
        ScrollView {
            VStack {
                Text(project.project.name)
                    .font(.title)
                Text("\(project.final_mark ?? 0)")
                Text(project.status)
                ForEach(project.teams.reversed(), id: \.self) { team in
                    ListProjectView(team: team)
                        .padding()
                }
            }
        }
        .refreshable {
            ProjectManager.shared.getProject(idProject: project.id) { _ in
            } onSucces: { project in
                self.project = project
            } onError: { error in
                print(error)
            }
        }
    }
}
struct ListProjectView: View {
    var team: TeamProject
    @State var isOpen: Bool = false

    var body: some View {
        HStack {
            Text(team.name)
            Spacer()
            Text("\(team.final_mark ?? 0)")
            Image(systemName: "chevron.up")
                .rotationEffect(.degrees(isOpen == true ? 0 : 180))
        }
        .onTapGesture {
            withAnimation {
                isOpen.toggle()
            }
        }
        if isOpen == true {
            MatesView(mates: team.users, id: team.id)
        }
    }
}

struct MatesView: View {
    var mates: [TeamUser]
    var id: Int
    @State var team: Team?
    var body: some View {
        VStack {
            if let team = team {
                Text(team.name)
                HStack {
                    ForEach(mates, id: \.self) { mate in
                        Text(mate.login)
                    }
                }
            }
        }
        .task {
            TeamManager.shared.getTeam(idTeam: id) { _ in
            } onSucces: { team in
                self.team = team
                print("j'ai la team")
            } onError: { error in
                print(error)
            }
        }
    }
}
