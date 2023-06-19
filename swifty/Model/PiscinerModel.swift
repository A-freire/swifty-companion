//
//  PiscinerModel.swift
//  swifty
//
//  Created by Adrien freire on 15/06/2023.
//
// swiftlint:disable identifier_name
import Foundation

struct PiscinerModel: Codable, Identifiable {
    let id: String
    let level: Double
    let image_link: String?

    enum CodingKeys: String, CodingKey {
        case id = "login"
        case level
        case image_link
    }
}
