//
//  TeamService.swift
//  swifty
//
//  Created by Adrien freire on 04/04/2023.
//

import Foundation
import Combine

class TeamService {
    static var shared = TeamService()

    private init() {}

    func getTeam(idTeam: Int) -> AnyPublisher<Team, Error> {
        let url = prepareGetTeam(idTeam: idTeam)
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: TeamResponse.self, decoder: JSONDecoder())
            .map({ data in
                Team(data: data)
            })
            .eraseToAnyPublisher()
    }

    private func prepareGetTeam(idTeam: Int) -> URLRequest {
        let url = URL(string: BASE_URL + "/v2/teams/\(idTeam)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "access_token") ?? "")",
                         forHTTPHeaderField: "Authorization")
        return request
    }
}
