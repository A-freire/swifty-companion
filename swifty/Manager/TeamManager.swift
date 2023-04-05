//
//  TeamManager.swift
//  swifty
//
//  Created by Adrien freire on 04/04/2023.
//

import Foundation
import Combine

class TeamManager {
    static var shared = TeamManager()
    private var cancellables = Set<AnyCancellable>()

    init() {}

    func getTeam(idTeam: Int,
                 onLoading: @escaping (Bool) -> Void,
                 onSucces: @escaping (Team) -> Void,
                 onError: @escaping (String) -> Void ) {
        onLoading(true)
        TeamService.shared.getTeam(idTeam: idTeam)
            .sink { completion in
                switch completion {
                case .failure:
                    onLoading(false)
                    onError("Erreur in getTeam")
                case .finished:
                    onLoading(false)
                }
            } receiveValue: { team in
                onSucces(team)
            }
            .store(in: &cancellables)
    }
}
