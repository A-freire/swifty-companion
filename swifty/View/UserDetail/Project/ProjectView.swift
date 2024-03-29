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
                VStack {
                    ForEach(project.teams.reversed(), id: \.self) { team in
                        ListProjectView(team: team)
                            .padding()
                    }
                }
            }
        }
        .refreshable {
            ProjectManager.shared.getProject(idProject: project.id) { _ in
            } onSucces: { project in
                self.project = project
            } onError: { error in
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                print(error)
            }
        }
    }
}
struct ListProjectView: View {
    var team: TeamProject
    @State var isOpen: Bool = false

    var body: some View {
        VStack {
            ZStack {
                Color.gray
                    .cornerRadius(15)
                HStack {
                    Text(team.name)
                    Spacer()
                    Text("\(team.final_mark ?? 0)")
                    Image(systemName: "chevron.up")
                        .rotationEffect(.degrees(isOpen == true ? 0 : 180))
                }
                .padding(10)
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
}

struct MatesView: View {
    var mates: [TeamUser]
    var id: Int
    @State var team: Team?
    @State var user: User?
    @State var showUser: Bool = false

    var body: some View {
        VStack {
            if let team = team {
                HStack {
                    ForEach(mates, id: \.self) { mate in
                        Button {
                            getUser(login: mate.login)
                        } label: {
                            Text(mate.login)
                        }
                    }
                }
                if !team.scaleTeams.isEmpty {
                    VStack {
                        ForEach(team.scaleTeams, id: \.self) { correction in
                            ZStack {
                                Color.gray
                                    .cornerRadius(15)
                                VStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Button {
                                                getUser(login: getlogin(correction: correction))
                                            } label: {
                                                Text(getlogin(correction: correction))
                                            }
                                            .disabled(realLogin(correction: correction))
                                            Spacer()
                                            Text("\(correction.finalMark ?? 0)")
                                        }
                                        .padding(.vertical, 5)
                                    }
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("Comment:")
                                            Spacer()
                                        }
                                        .padding(.vertical, 5)
                                        Text(correction.comment ?? "")
                                    }
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("Feedback:")
                                            Spacer()
                                        }
                                        .padding(.vertical, 5)
                                        Text(correction.feedback ?? "")
                                    }
                                    .padding(.bottom, 5)
                                }
                                .padding(10)
                            }
                        }
                    }
                }
            }
        }
        .task {
            TeamManager.shared.getTeam(idTeam: id) { _ in
            } onSucces: { team in
                self.team = team
            } onError: { error in
                print(error)
                UINotificationFeedbackGenerator().notificationOccurred(.error)
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
            self.showUser = true
        } onError: { error in
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            print(error)
        }
    }

    func getlogin(correction: ScaleTeam) -> String {
        switch correction.corrector {
        case .string(let string):
                return string
        case .corrector(let corrector):
                return corrector.login
        }
    }

    func realLogin(correction: ScaleTeam) -> Bool {
        if getlogin(correction: correction) == "invisible" {
            return true
        }
        return false
    }
}
