//
//  UserSkillsView.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 28/02/2023.
//

import SwiftUI

struct UserSkillsView: View {
    @State var showAll: Bool = false
    let projects: [Skills]
    @Binding var color: String

    var body: some View {
        VStack {
            HStack {
                Text("Skills")
                    .bold()
                Spacer()
                if projects.count > 3 {
                    Button {
                        showAll = true
                    } label: {
                        Text("See all projects")
                    }
                    .navigationDestination(isPresented: $showAll) {
                        AllSkillsCardView(projects: projects, color: $color)
                    }
                }
            }
            ForEach(projects.prefix(3), id: \.self) { project in
                SkillsCardView(project: project)
            }
        }
    }
}

struct AllSkillsCardView: View {
    let projects: [Skills]
    @Binding var color: String

    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(projects, id: \.self) { project in
                SkillsCardLevelView(project: project, color: $color)
            }
        }
        .navigationTitle("Skills")
        .padding(.horizontal)
    }
}

struct SkillsCardView: View {
    let project: Skills

    var body: some View {
        ZStack {
            Color.gray
                .cornerRadius(15)
            HStack {
                Text(project.name)
                Spacer()
                Text("lvl \(Int(project.level))")
            }
            .padding(10)
        }
    }
}

struct SkillsCardLevelView: View {
    let project: Skills
    @Binding var color: String

    var body: some View {
        ZStack {
            Color.gray
                .cornerRadius(15)
            VStack {
                Text(project.name)
                LevelBar(level: project.level, color: $color)
            }
            .padding(10)
        }
    }
}
