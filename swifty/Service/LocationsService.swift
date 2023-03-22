//
//  LocationsService.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 21/03/2023.
//

import Foundation
import Combine

class LocationsService {
    static var shared = LocationsService()

    init() {}

    func getLocations(page: Int) -> AnyPublisher<[Location], Error> {
        let url = prepareGetLocations(page: page)
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: [Location].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    private func prepareGetLocations(page: Int) -> URLRequest {
// swiftlint:disable:next line_length
        let url = URL(string: BASE_URL + "/v2/campus/1/locations?page%5Bsize%5D=100&page%5Bnumber%5D=\(page)&filter%5Bactive%5D=true")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "access_token") ?? "")",
                         forHTTPHeaderField: "Authorization")
        return request
    }
}
