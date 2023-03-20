//
//  FriendsManager.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 20/03/2023.
//

import Foundation
import Combine

class FriendsManager {
    static var shared = FriendsManager()
    private var cancellables = Set<AnyCancellable>()

    init() {}

    public func getFriendsList(fileurl: String,
                               onLoading: @escaping (Bool) -> Void,
                               onSucces: @escaping ([String]) -> Void,
                               onError: @escaping (String) -> Void ) {
        onLoading(true)
        FriendsService.shared.getFriendsList(fileurl: fileurl)
            .sink { completion in
                switch completion {
                case .failure:
                    onLoading(false)
                    onError("Erreur in getfriendsList")
                case .finished:
                    onLoading(false)
                }
            } receiveValue: { friends in
                onSucces(friends)
            }
            .store(in: &cancellables)
    }
}
