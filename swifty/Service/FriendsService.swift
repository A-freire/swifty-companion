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

    func getFriendsList(fileurl: String) -> AnyPublisher<[[String: String]], Error> {
        let url = prepareGetFriendsList(fileurl: fileurl)
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: [[String: String]].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    private func prepareGetFriendsList(fileurl: String) -> URLRequest {
        let url = URL(string: fileurl)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
