//
//  Credential.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 27/02/2023.
//

import Foundation

class Credential {
    let access_token: String
    let token_type: String
    let expires_in: Int
    let scope: String
    let created_at: Int

    init(data: CredentialResponse) {
        self.access_token = data.access_token
        self.token_type = data.token_type
        self.expires_in = data.expires_in
        self.scope = data.scope
        self.created_at = data.created_at
    }
}

struct CredentialResponse: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
    let scope: String
    let created_at: Int
}
