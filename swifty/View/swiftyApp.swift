//
//  swiftyApp.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 27/02/2023.
//

import SwiftUI
import SDWebImage
import SDWebImageSVGCoder

@main
struct SwiftyApp: App {

    init() {
        setUpDependencies()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TokenAPIView()
            }
        }
    }
}

private extension SwiftyApp {
    func setUpDependencies() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }
}
