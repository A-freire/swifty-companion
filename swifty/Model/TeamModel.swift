//
//  TeamModel.swift
//  swifty
//
//  Created by Adrien freire on 04/04/2023.
//

import Foundation

class Team {
    let id: Int
    let name: String
    let finalMark: Int
    let projectId: Int
    let createdAt, updatedAt, lockedAt, closedAt: String
    let status: String
    let locked, validated, closed: Bool
    let projectSessionId: Int
    let scaleTeams: [ScaleTeam]

    init(data: TeamResponse) {
        self.id = data.id
        self.name = data.name
        self.finalMark = data.finalMark ?? 0
        self.projectId = data.projectId
        self.createdAt = data.createdAt ?? ""
        self.updatedAt = data.updatedAt ?? ""
        self.lockedAt = data.lockedAt ?? ""
        self.closedAt = data.closedAt ?? ""
        self.status = data.status
        self.locked = data.locked ?? false
        self.validated = data.validated ?? false
        self.closed = data.closed ?? false
        self.projectSessionId = data.projectSessionId
        self.scaleTeams = data.scaleTeams
    }
}

struct TeamResponse: Codable {
    let id: Int
    let name: String
    let finalMark: Int?
    let projectId: Int
    let createdAt, updatedAt, lockedAt, closedAt: String?
    let status: String
    let locked, validated, closed: Bool?
    let projectSessionId: Int
    let scaleTeams: [ScaleTeam]

    enum CodingKeys: String, CodingKey {
        case id, name
        case finalMark = "final_mark"
        case projectId = "project_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case status
        case locked = "locked?"
        case validated = "validated?"
        case closed = "closed?"
        case lockedAt = "locked_at"
        case closedAt = "closed_at"
        case projectSessionId = "project_session_id"
        case scaleTeams = "scale_teams"
    }
}

struct ScaleTeam: Codable, Hashable {
    static func == (lhs: ScaleTeam, rhs: ScaleTeam) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
       hasher.combine(id)
    }
    let id: Int
    let scaleId: Int
    let comment, feedback: String?
    let finalMark: Int?
    let flag: Flag
    let corrector: StringOuCorrector

    enum CodingKeys: String, CodingKey {
        case id
        case scaleId = "scale_id"
        case comment, feedback
        case finalMark = "final_mark"
        case flag
        case corrector
    }
}

struct Flag: Codable {
    let id: Int
    let name: String
    let positive: Bool
    let icon: String
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, positive, icon
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct Corrector: Codable {
    let id: Int
    let login: String
    let url: String
}
