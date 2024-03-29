//
//  UserManager.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 28/02/2023.
//

import Foundation
import Combine

class UserManager {
    static var shared = UserManager()
    private var cancellables = Set<AnyCancellable>()

    init() {}

    func getUser(login: String,
                 onLoading: @escaping (Bool) -> Void,
                 onSucces: @escaping (User) -> Void,
                 onError: @escaping (String) -> Void) {
        onLoading(true)
        CredManager.shared.checkCred {
            UserServices.shared.getUser(login: login)
                .sink { completion in
                    switch completion {
                    case .failure:
                        onLoading(false)
                        onError("Erreur dans le getUser")
                    case .finished:
                        onLoading(false)
                    }
                } receiveValue: { user in
                    onSucces(user)
                }
                .store(in: &self.cancellables)
        } onError: { error in
            onError(error)
        }
    }

    func getColorCoa(login: String,
                     onLoading: @escaping (Bool) -> Void,
                     onSucces: @escaping (String) -> Void,
                     onError: @escaping (String) -> Void) {
        onLoading(true)
        UserServices.shared.getUserCoalition(login: login)
            .sink { completion in
                switch completion {
                case .failure:
                    onLoading(false)
                    onError("Erreur dans le getColorCoa")
                case .finished:
                    onLoading(false)
                }
            } receiveValue: { coa in
                coa != "" ? onSucces(coa) : onError("Erreur car le user n'a pas de coa")
            }
            .store(in: &cancellables)
    }

    public func searchUserByCampus(login: String,
                                   onLoading: @escaping (Bool) -> Void,
                                   onSucces: @escaping ([CampusUser]) -> Void,
                                   onError: @escaping (String) -> Void ) {
        onLoading(true)
        CredManager.shared.checkCred {
            UserServices.shared.searchUserbyCampus(login: login)
                .sink { completion in
                    switch completion {
                    case .failure:
                        onLoading(false)
                        onError("Erreur in searchUserByCampus")
                    case .finished:
                        onLoading(false)
                    }
                } receiveValue: { users in
                    onSucces(users)
                }
                .store(in: &self.cancellables)
        } onError: { error in
            onError(error)
        }
    }
}
