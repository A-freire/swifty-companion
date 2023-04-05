//
//  ProjectModel.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 27/03/2023.
//
// swiftlint:disable identifier_name
import Foundation

class Project: Codable {
    let id: Int
    let occurrence: Int
    let final_mark: Int?
    let status: String
    let project: ProjectName
    let created_at: String
    let marked_at: String
    let teams: [TeamProject]

    init(data: ProjectResponse) {
        self.id = data.id
        self.occurrence = data.occurrence
        self.final_mark = data.final_mark
        self.status = data.status
        self.project = data.project
        self.created_at = data.created_at
        self.marked_at = data.marked_at ?? ""
        self.teams = data.teams
    }
}

class ProjectResponse: Codable {
    let id: Int
    let occurrence: Int
    let final_mark: Int?
    let status: String
    let project: ProjectName
    let created_at: String
    let marked_at: String?
    let teams: [TeamProject]
}

class TeamProject: Codable, Hashable {
    func hash(into hasher: inout Hasher) {
       hasher.combine(id)
    }
    static func == (lhs: TeamProject, rhs: TeamProject) -> Bool {
        return lhs.id == rhs.id
    }

    let id: Int
    let name: String
    let final_mark: Int?
    let users: [TeamUser]
    let isLocked: Bool
    let isValidated: Bool?
    let isClosed: Bool
    let repo_url: String?
    let locked_at: String
    let closed_at: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case final_mark
        case users
        case isLocked = "locked?"
        case isValidated = "validated?"
        case isClosed = "closed?"
        case repo_url
        case locked_at
        case closed_at
    }
}

class TeamUser: Codable, Hashable {
    static func == (lhs: TeamUser, rhs: TeamUser) -> Bool {
        return lhs.login == rhs.login
    }
    func hash(into hasher: inout Hasher) {
       hasher.combine(login)
    }
    let login: String
    let leader: Bool
}
