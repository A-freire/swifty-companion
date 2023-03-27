//
//  ProjectManager.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 27/03/2023.
//

import Foundation
import Combine

class ProjectManager {
    static var shared = ProjectManager()
    private var cancellables = Set<AnyCancellable>()

    init() {}

    public func getProject(idProject: Int,
                           onLoading: @escaping (Bool) -> Void,
                           onSucces: @escaping (Project) -> Void,
                           onError: @escaping (String) -> Void ) {
        onLoading(true)
        ProjectService.shared.getProject(idProject: idProject)
            .sink { completion in
                switch completion {
                case .failure:
                    onLoading(false)
                    onError("Erreur in getProject")
                case .finished:
                    onLoading(false)
                }
            } receiveValue: { project in
                onSucces(project)
            }
            .store(in: &cancellables)
    }
}
