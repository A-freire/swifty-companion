//
//  FinishedProjectsView.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 28/02/2023.
//

import SwiftUI

struct UserFinishedProjectsView: View {
    let projects: [FinishedProject]
    @State var showAll: Bool = false
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
                Text(project.name + " - " + timeAgoSinceDate(dateBrut: project.time))
                Spacer()
                Text("\(project.mark)")
            }
            .padding(10)
        }
    }

    func timeAgoSinceDate(dateBrut: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: dateBrut) {
            let calendar = Calendar.current
            let flags: Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
            let now = Date()
            let components = calendar.dateComponents(flags, from: date, to: now)
            
            if let year = components.year, year >= 1 {
                return year == 1 ? "a year ago" : "\(year) years ago"
            } else if let month = components.month, month >= 1 {
                return month == 1 ? "a month ago" : "\(month) months ago"
            } else if let week = components.weekOfYear, week >= 1 {
                return week == 1 ? "a week ago" : "\(week) weeks ago"
            } else if let day = components.day, day >= 1 {
                return day == 1 ? "a day ago" : "\(day) days ago"
            } else if let hour = components.hour, hour >= 1 {
                return hour == 1 ? "an hour ago" : "\(hour) hours ago"
            } else if let minute = components.minute, minute >= 1 {
                return minute == 1 ? "a minute ago" : "\(minute) minutes ago"
            } else if let second = components.second, second >= 1 {
                return second == 1 ? "a seconde ago" : "\(second) secondes ago"
            } else {
                return "maintenant"
            }
        } else {
            return ""
        }
    }

}
