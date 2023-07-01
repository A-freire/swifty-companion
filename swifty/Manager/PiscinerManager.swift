//
//  PiscinerManager.swift
//  swifty
//
//  Created by Adrien freire on 15/06/2023.
//

import Foundation
import Combine

class PiscinerManager {
    static var shared = PiscinerManager()
    private var cancellables = Set<AnyCancellable>()

    init() {}

    public func getPiscinerList(fileurl: String,
                                onLoading: @escaping (Bool) -> Void,
                                onSucces: @escaping ([PiscinerModel]) -> Void,
                                onError: @escaping (String) -> Void ) {
        onLoading(true)
        PiscinerService.shared.getPiscinerList(fileurl: fileurl)
            .sink { completion in
                switch completion {
                case .failure:
                    onLoading(false)
                    onError("Erreur in getPiscinerList")
                case .finished:
                    onLoading(false)
                }
            } receiveValue: { friends in
                onSucces(friends)
            }
            .store(in: &cancellables)
    }
}
