//
//  UserAchievementManager.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 01/03/2023.
//

import Foundation
import Combine

class UserAchievementManager {
    static var shared = UserAchievementManager()
    private var cancellables = Set<AnyCancellable>()

    init() {}

    func getAchievementsList(userId: Int,
                             onLoading: @escaping (Bool) -> Void,
                             onSucces: @escaping ([AchievementData]) -> Void,
                             onError: @escaping (String) -> Void) {
        onLoading(true)
        UserServices.shared.getUserAchievements(userId: userId)
            .sink { completion in
                switch completion {
                case .failure:
                    onLoading(false)
                    onError("Erreur dans getArchievement")
                case .finished:
                    onLoading(false)
                }
            } receiveValue: { datas in
                onSucces(datas)
            }
            .store(in: &cancellables)
    }
}
