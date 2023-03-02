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
                        AllSkillsCardView(projects: projects)
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

    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(projects, id: \.self) { project in
                SkillsCardView(project: project)
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
                Text(project.level.formated2Decimal())
            }
            .padding(10)
        }
    }
}
