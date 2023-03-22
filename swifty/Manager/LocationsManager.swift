//
//  LocationsManager.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 21/03/2023.
//

import Foundation
import Combine

class LocationsManager {
    static var shared = LocationsManager()
    private var cancellables = Set<AnyCancellable>()

    init() {}

    public func getLocations(onLoading: @escaping (Bool) -> Void,
                             onSucces: @escaping ([Location]) -> Void,
                             onError: @escaping (String) -> Void,
                             page: Int = 1,
                             allLocations: [Location] = []) {
        onLoading(true)
        LocationsService.shared.getLocations(page: page)
            .sink { completion in
                switch completion {
                case .failure:
                    onLoading(false)
                    onError("Erreur in getLocations")
                case .finished:
                    onLoading(false)
                }
            } receiveValue: { locations in
                let updatedLocations = allLocations + locations
                if locations.count < 100 { // La dernière page a été atteinte
                    onSucces(updatedLocations)
                } else {
                    let delayInSeconds: TimeInterval = 0.5 // Ajoutez un délai de 0,5 seconde (2 fois par seconde)
                    DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                        self.getLocations(onLoading: onLoading,
                                          onSucces: onSucces,
                                          onError: onError,
                                          page: page + 1,
                                          allLocations: updatedLocations)
                    }
                }
            }
            .store(in: &cancellables)
    }
}
