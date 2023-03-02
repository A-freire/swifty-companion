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
        CredManager.shared.checkCred()
        UserServices.shared.getUser(login: login)
            .sink { completion in
                switch completion {
                case .failure:
                    print("Error")
                    onLoading(false)
                    onError("Erreur dans le getUser")
                case .finished:
                    onLoading(false)
                }
            } receiveValue: { user in
                onSucces(user)
            }
            .store(in: &cancellables)
    }

    func getColorCoa(login: String,
                     onLoading: @escaping (Bool) -> Void,
                     onSucces: @escaping (String) -> Void,
                     onError: @escaping (String) -> Void) {
        onLoading(true)
        CredManager.shared.checkCred()
        UserServices.shared.getUserCoalition(login: login)
            .sink { completion in
                switch completion {
                case .failure:
                    print("Error")
                    onLoading(false)
                    onError("Erreur dans le getColorCoa")
                case .finished:
                    print("Finished")
                    onLoading(false)
                }
            } receiveValue: { coa in
                coa != "" ? onSucces(coa) : onError("Erreur car le user n'a pas de coa")
            }
            .store(in: &cancellables)
    }
}
