//
//  CampusUserModel.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 05/03/2023.
//

import Foundation

class CampusUser {
    let login: String
    let image: String

    init(data: CampusUserResponse) {
        self.login = data.login
        self.image = data.image.link ?? "https://cdn.intra.42.fr/users/430b2acd1bcfedf5475654d235003086/norminet.jpeg"
    }

    func getImageURL() -> URL {
        if image == "https://cdn.intra.42.fr/users/78999b974389f4c1370718e6c4eb0512/3b3.jpg" {
            return URL(string: "https://cdn.intra.42.fr/users/430b2acd1bcfedf5475654d235003086/norminet.jpeg")!
        }
        return URL(string: image)!
    }
}

class CampusUserResponse: Codable {
    let login: String
    let image: ProfilePicture
}
