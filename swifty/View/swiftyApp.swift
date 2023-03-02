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
        setUpDependencies() // Initialize SVGCoder
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TokenAPIView()
            }
        }
    }
}
// Initialize SVGCoder
private extension SwiftyApp {

    func setUpDependencies() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }
}
