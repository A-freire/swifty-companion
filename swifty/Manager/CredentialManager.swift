//
//  CredentialManager.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 27/02/2023.
//

import Foundation
import Combine

class CredManager {
    static var shared = CredManager()
    private var cancellables = Set<AnyCancellable>()

    init() {}

    func connexion(onLoading: @escaping (Bool) -> Void,
                   onSucces: @escaping () -> Void,
                   onError: @escaping (String) -> Void) {
        onLoading(true)
        UserServices.shared.getCred()
            .sink { completion in
                switch completion {
                case .failure:
                    onLoading(false)
                    onError("Error in connexion")
                case .finished:
                    onLoading(false)
                }
            } receiveValue: { cred in
                UserDefaults.standard.set(cred.access_token, forKey: "access_token")
                UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(cred.expires_in)), forKey: "expiration")
                onSucces()
            }
            .store(in: &cancellables)
    }

    func checkCred() {
        if Date() > UserDefaults.standard.object(forKey: "expiration") as! Date {
            UserServices.shared.getCred()
                .sink { completion in
                    switch completion {
                    case .failure:
                        print("error dans checkCred")
//                        onLoading(false)
//                        onError("Error in connexion")
                    case .finished:
                        print("finish")
//                        onLoading(false)
                    }
                } receiveValue: { cred in
                    print("change cred")
                    UserDefaults.standard.set(cred.access_token, forKey: "access_token")
                    UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(cred.expires_in)), forKey: "expiration")
//                    onSucces()
                }
                .store(in: &cancellables)
        }
    }

}
