//
//  LocationModel.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 21/03/2023.
//

import Foundation

class Location: Codable {
    let host: String
    let user: MiniUser
}

class MiniUser: Codable {
    let login: String
    let image: ProfilePicture
}
