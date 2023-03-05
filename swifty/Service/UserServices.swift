//
//  UserServices.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 27/02/2023.
//

import Foundation
import Combine

class UserServices {
    static var shared = UserServices()

    init() {}

    func getCred() -> AnyPublisher<Credential, Error> {
        let request = prepareGetCred()
        return URLSession.shared.dataTaskPublisher(for: request)
                .map(\.data)
                .receive(on: DispatchQueue.main)
                .decode(type: CredentialResponse.self, decoder: JSONDecoder())
                .map({ cred in
                    Credential(data: cred)
                })
                .eraseToAnyPublisher()
    }

    private func prepareGetCred() -> URLRequest {
        let url = URL(string: BASE_URL + "/oauth/token")
        var request = URLRequest(url: url!)
        var requestBodyComponents = URLComponents()
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        requestBodyComponents.queryItems = [URLQueryItem(name: "grant_type", value: "client_credentials"),
                                            URLQueryItem(name: "client_id",
                                                         value: UserDefaults.standard.string(forKey: "uid") ?? ""),
                                            URLQueryItem(name: "client_secret",
                                                         value: UserDefaults.standard.string(forKey: "secret") ?? "")]
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        return request
    }

    func getUser(login: String) -> AnyPublisher<User, Error> {
        let request = prepareGetUser(login: login)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .map({ user in
                User(data: user)
            })
            .eraseToAnyPublisher()
    }

    private func prepareGetUser(login: String) -> URLRequest {
        let url = URL(string: BASE_URL + "/v2/users/" + login)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "access_token") ?? "")",
                          forHTTPHeaderField: "Authorization")
        return request
    }

    func getUserCoalition(login: String) -> AnyPublisher<String, Error> {
        let request = prepareGetUserCoalition(login: login)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .decode(type: [CoaResponse].self, decoder: JSONDecoder())
            .map({ coas in
                var color = ""
                coas.forEach { coa in
                    if coa.id == 45 {
                        color = "#4180DB"
                    } else if coa.id == 46 {
                        color = "#33C47F"
                    } else if coa.id == 47 {
                        color = "#FF6950"
                    } else if coa.id == 48 {
                        color = "#A061D1"
                    } else if coa.id == 107 && color == "" {
                        color = "#00B333"
                    } else if coa.id == 108 && color == "" {
                        color = "#FF1919"
                    }
                }
                return color
            })
            .eraseToAnyPublisher()
    }

    private func prepareGetUserCoalition(login: String) -> URLRequest {
        let url = URL(string: BASE_URL + "/v2/users/" + login + "/coalitions")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "access_token") ?? "")",
                         forHTTPHeaderField: "Authorization")
        return request
    }

    func getUserAchievements(userId: Int) -> AnyPublisher<[AchievementData], Error> {
        let request = prepareGetUserAchievements(userId: userId)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .decode(type: [AchievementDataResponse].self, decoder: JSONDecoder())
            .map({ achi in
                achi.map { data in
                    AchievementData(data: data)
                }
            })
            .eraseToAnyPublisher()
    }

    private func prepareGetUserAchievements(userId: Int) -> URLRequest {
// swiftlint:disable:next line_length
        let url = URL(string: BASE_URL + "/v2/achievements_users?filter%5Buser_id%5D=\(userId)&sort=-updated_at&page%5Bsize%5D=100")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "access_token") ?? "")",
                         forHTTPHeaderField: "Authorization")
        return request
    }

    func searchUserbyCampus(login: String) -> AnyPublisher<[CampusUser], Error> {
        let url = prepareSearchUserByCampus(login: login)
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: [CampusUserResponse].self, decoder: JSONDecoder())
            .map({ users in
                users.map { user in
                    return CampusUser(data: user)
                }
            })
            .eraseToAnyPublisher()
    }

    private func prepareSearchUserByCampus(login: String) -> URLRequest {
        let url = URL(string: BASE_URL + "/v2/campus/1/users?range%5Blogin%5D=\(login),\(login)z")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "access_token") ?? "")",
                         forHTTPHeaderField: "Authorization")
        return request
    }

    func checkerror(userId: Int) -> AnyPublisher<Int, URLSession.DataTaskPublisher.Failure> {
        let url = prepareGetUserAchievements(userId: userId)
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map { _, response in
                print(response.description)
                return response.getStatusCode() ?? 0
            }
            .eraseToAnyPublisher()
    }
}
