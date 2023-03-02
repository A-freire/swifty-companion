//
//  CoaModel.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 01/03/2023.
//
// swiftlint:disable identifier_name

import Foundation

class Coa {
    let id: Int
    let name: String
    let slug: String
    let imageUrl: String
    let coverUrl: String
    let color: String

    init(data: CoaResponse) {
        self.id = data.id
        self.name = data.name
        self.slug = data.slug
        self.imageUrl = data.image_url
        self.coverUrl = data.cover_url
        self.color = data.color
    }

    init() {
        self.id = -1
        self.name = ""
        self.slug = ""
        self.imageUrl = ""
        self.coverUrl = ""
        self.color = ""
    }
}

class CoaResponse: Codable {
    let id: Int
    let name: String
    let slug: String
    let image_url: String
    let cover_url: String
    let color: String
}
