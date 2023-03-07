//
//  UserModel.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 28/02/2023.
//
// swiftlint:disable identifier_name

import Foundation

class User {
    let id: Int
    let login: String
    let displayName: String
    let image: String
    let location: String?
    let cursusUsers: [CursusUsers]
    let groups: [Groups]
    let titles: [Groups]
    let titlesUsers: [TitlesUsers]
    let projectsUsers: [ProjectUsers]
    let achievements: [Achievement]
    let updated_at: String

    init(data: UserResponse) {
        self.id = data.id
        self.login = data.login
        self.displayName = data.displayname
        self.image = data.image.link ?? "https://cdn.intra.42.fr/users/430b2acd1bcfedf5475654d235003086/norminet.jpeg"
        self.location = data.location
        self.cursusUsers = data.cursus_users
        self.groups = data.groups
        self.titles = data.titles
        self.titlesUsers = data.titles_users
        self.projectsUsers = data.projects_users
        self.achievements = data.achievements
        self.updated_at = data.updated_at
    }

    func getUrlPicture() -> URL {
        if image == "https://cdn.intra.42.fr/users/78999b974389f4c1370718e6c4eb0512/3b3.jpg" {
            return URL(string: "https://cdn.intra.42.fr/users/430b2acd1bcfedf5475654d235003086/norminet.jpeg")!
        }
        return URL(string: image)!
    }

    func getLevel() -> Double {
        if let last = cursusUsers.last {
            return last.level
        }
        return 0
    }

    func getSkills() -> [Skills] {
        if let last = cursusUsers.last {
            return last.skills
        }
        return []
    }

    func getBlackholeState() -> BlackHoleState {
        if let last = cursusUsers.last {
            if last.blackholed_at != nil {
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                if let blackholeTime = getBlackHoleTime() {
                    return blackholeTime > 0 ? .learner : .blackhole
                }
            }
            return .member
        }
        return .blackhole
    }

    func getBlackHoleTime() -> Int? {
        if let last = cursusUsers.last {
            if last.blackholed_at != nil {
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
// swiftlint:disable:next line_length
                return Int(((dateFormat.date(from: last.blackholed_at!)?.millisecondSince1978 ?? 0) - Date.now.millisecondSince1978) / 86400000)
            }
            return 0
        }
        return 0
    }

    func getTitle() -> String {
        var log: String = login
        titlesUsers.forEach { title in
            if title.selected == true {
                titles.forEach { tid in
                    if tid.id == title.title_id {
                        log = tid.name.replacingOccurrences(of: "%login", with: login)
                    }
                }
            }
        }
        return log
    }

    func getOnGoingProject() -> [String] {
        var projectName: [String] = []
        projectsUsers.forEach { project in
            if project.status == "in_progress" || project.status == "waiting_for_correction" {
                projectName.append(project.project.name)
            }
        }
        return projectName
    }

    func getFinishedProject() -> [FinishedProject] {
        var projectValidated: [FinishedProject] = []
        projectsUsers.forEach { project in
            if project.status == "finished" {
                if cursusUsers.last?.grade == "Learner" || cursusUsers.last?.grade == "Member" {
                    if project.cursus_ids[0] == 21 {
                        projectValidated.append(FinishedProject(name: project.project.name,
                                                                mark: project.final_mark ?? 0,
                                                                time: project.marked_at ?? ""))
                    }
                } else if cursusUsers.last?.grade == nil {
                    projectValidated.append(FinishedProject(name: project.project.name,
                                                            mark: project.final_mark ?? 0,
                                                            time: project.marked_at ?? ""))
                }
            }
        }
        return projectValidated
    }
}

struct UserResponse: Codable {
    let id: Int
    let login: String
    let displayname: String
    let image: ProfilePicture
    let location: String?
    let cursus_users: [CursusUsers]
    let groups: [Groups]
    let titles: [Groups]
    let titles_users: [TitlesUsers]
    let projects_users: [ProjectUsers]
    let achievements: [Achievement]
    let updated_at: String
}

struct ProfilePicture: Codable {
    let link: String?
}

struct CursusUsers: Codable {
    let grade: String?
    let level: Double
    let skills: [Skills]
    let blackholed_at: String?
    let id: Int
}

struct Skills: Codable, Hashable {
    let id: Int
    let name: String
    let level: Double
}

struct Groups: Codable, Hashable {
    let id: Int
    let name: String
}

struct TitlesUsers: Codable, Hashable {
    let title_id: Int
    let selected: Bool
}

struct ProjectUsers: Codable {
    let occurrence: Int
    let final_mark: Int?
    let status: String
    let project: ProjectName
    let cursus_ids: [Int]
    let marked_at: String?
}

struct ProjectName: Codable {
    let name: String
}

struct FinishedProject: Codable, Hashable {
    var name: String
    var mark: Int
    var time: String
}

struct Achievement: Codable, Hashable {
    let id: Int
    let name: String
    let description: String
    let tier: String
    let kind: String
    let visible: Bool
    let image: String
    let nbr_of_success: Int?

    func getImageURL() -> URL {
        return URL(string: BASE_URL+image)!
    }
}
