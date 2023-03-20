//
//  FriendsService.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 20/03/2023.
//

import Foundation
import Combine

class FriendsService {
    static var shared = FriendsService()
    
    init() {}

    func getFriendsList(fileurl: String) -> AnyPublisher<[String], Error> {
        let url = prepareGetFriendsList(fileurl: fileurl)
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: [String].self, decoder: JSONDecoder())
//            .map(\.data)
            .eraseToAnyPublisher()
    }

    private func prepareGetFriendsList(fileurl: String) -> URLRequest {
        let url = URL(string: fileurl)!
        var request = URLRequest(url: url)
        //    let json: [String: Any] = ["post": postId]
        //    let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpMethod = "GET"
        //    request.httpBody = jsonData
        //    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
