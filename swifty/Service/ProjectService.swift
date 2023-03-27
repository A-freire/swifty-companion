//
//  ProjectService.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 27/03/2023.
//

import Foundation
import Combine

class ProjectService {
    static var shared = ProjectService()

    init() {}

    func getProject(idProject: Int) -> AnyPublisher<Project, Error> {
        let url = prepareGetProject(idProject: idProject)
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: ProjectResponse.self, decoder: JSONDecoder())
            .map({ data in
                Project(data: data)
            })
            .eraseToAnyPublisher()
    }

    private func prepareGetProject(idProject: Int) -> URLRequest {
        let url = URL(string: BASE_URL + "/v2/projects_users/\(idProject)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "access_token") ?? "")",
                         forHTTPHeaderField: "Authorization")
        return request
    }
}
