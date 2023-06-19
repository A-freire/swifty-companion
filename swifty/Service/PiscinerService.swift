//
//  PiscinerService.swift
//  swifty
//
//  Created by Adrien freire on 15/06/2023.
//

import Foundation
import Combine

class PiscinerService {
    static var shared = PiscinerService()

    init() {}

    func getPiscinerList(fileurl: String) -> AnyPublisher<[PiscinerModel], Error> {
        let url = prepareGetFriendsList(fileurl: fileurl)
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: [PiscinerModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    private func prepareGetFriendsList(fileurl: String) -> URLRequest {
        let url = URL(string: fileurl)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
