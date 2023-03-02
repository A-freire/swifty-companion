//
//  AchievementDataModel.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 01/03/2023.
//
// swiftlint:disable identifier_name

import Foundation

class AchievementData {
    let id: Int
    let achievement_id: Int
    let user_id: Int
    let login: String

    init(data: AchievementDataResponse) {
        self.id = data.id
        self.achievement_id = data.achievement_id
        self.user_id = data.user_id
        self.login = data.login
    }
}

class AchievementDataResponse: Codable {
    let id: Int
    let achievement_id: Int
    let user_id: Int
    let login: String
}
