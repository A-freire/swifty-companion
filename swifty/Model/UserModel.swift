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
        if let cursus = cursusUsers.first(where: {$0.grade == "Learner" || $0.grade == "Member"}) {
            return cursus.level
        }
        if let cursus = cursusUsers.first(where: {$0.cursus.id == 9}) {
            return cursus.level
        }
        return 0
    }

    func getSkills() -> [Skills] {
        if let cursus = cursusUsers.first(where: {$0.grade == "Learner" || $0.grade == "Member"}) {
            return cursus.skills
        }
        return []
    }

    func getBlackholeState() -> BlackHoleState {
        let status = cursusUsers.map { cursus in
            if cursus.cursus.id == 21 {
                if cursus.blackholed_at != nil {
                    if let blackholeTime = getBlackHoleTime() {
                        return blackholeTime > 0 ? BlackHoleState.learner : .blackhole
                    }
                }
                return .member
            }
            if cursus.cursus.id == 9 {
                return .novice
            }
            if cursus.cursus.id == 67 {
                return .event
            }
            return .blackhole
        }
        let tmp = status.filter({ $0 != BlackHoleState.event })
        if tmp.contains(where: { $0 == BlackHoleState.member }) {
            return .member
        } else if tmp.contains(where: { $0 == BlackHoleState.learner }) {
            return .learner
        } else if tmp.contains(where: { $0 == BlackHoleState.blackhole }) {
            return .blackhole
        } else {
            return .novice
        }
    }

//    func getBlackHoleTime() -> Int? {
//        return cursusUsers.map { cursus in
//            if cursus.cursus.id == 21 {
//                if cursus.blackholed_at != nil {
//                    let dateFormat = DateFormatter()
//                    dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//    // swiftlint:disable:next line_length
//                    return Int(((dateFormat.date(from: cursus.blackholed_at!)?.millisecondSince1978 ?? 0) - Date.now.millisecondSince1978) / 86400000)
//                }
//            }
//            return 0
//        }.filter { $0 != 0 }.first
//    }
    
    func getBlackHoleTime() -> Int? {
        // Définir le format de date une seule fois pour éviter la redondance.
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // Utiliser compactMap pour filtrer et transformer en une seule opération.
        // La fonction cherche le premier cursus correspondant avec un 'blackholed_at' non nil et calcule la différence en jours.
        let timeDifferences = cursusUsers.compactMap { cursus -> Int? in
            print("hallo",cursus.cursus.id)
            guard cursus.cursus.id == 21, let blackholedAt = cursus.blackholed_at,
                  let blackholeDate = dateFormat.date(from: blackholedAt) else {
                return nil
            }
            let timeDifference = Int((blackholeDate.timeIntervalSince1970 - Date().timeIntervalSince1970) / 86400)
            return timeDifference > 0 ? timeDifference : nil
        }
        
        // Retourner le premier élément du tableau filtré, s'il existe.
        return timeDifferences.first
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

    func getOnGoingProject() -> [ProjectUsers] {
        var projectName: [ProjectUsers] = []
        projectsUsers.forEach { project in
            if project.status == "in_progress" || project.status == "waiting_for_correction" {
                projectName.append(project)
            }
        }
        return projectName
    }

    func getFinishedProject() -> [ProjectUsers] {
        var projectValidated: [ProjectUsers] = []
        projectsUsers.forEach { project in
            if project.status == "finished" {
// swiftlint:disable:next line_length
                if cursusUsers.last?.grade != nil && (cursusUsers.last?.grade == "Learner" || cursusUsers.last?.grade == "Member") {
                    if !project.cursus_ids.isEmpty && project.cursus_ids[0] == 21 {
                        projectValidated.append(project)
                    }
                } else if cursusUsers.last?.grade == nil {
                    projectValidated.append(project)
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
    let cursus: CursusInfo
}

struct CursusInfo: Codable {
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

struct ProjectUsers: Codable, Hashable {
    static func == (lhs: ProjectUsers, rhs: ProjectUsers) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
       hasher.combine(id)
    }

    let id: Int
    let occurrence: Int
    let final_mark: Int?
    let status: String
    let current_team_id: Int?
    let project: ProjectName
    let cursus_ids: [Int]
    let marked_at: String?
}

struct ProjectName: Codable {
    let name: String
}

struct Achievement: Codable, Hashable {
    let id: Int
    let name: String
    let description: String
    let tier: String
    let kind: String
    let visible: Bool
    let image: String?
    let nbr_of_success: Int?

    func getImageURL() -> URL {
        return URL(string: BASE_URL + (image ?? ""))!
    }
}
