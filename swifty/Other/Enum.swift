//
//  Enum.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 28/02/2023.
//

import Foundation

enum BlackHoleState: Int {
    case member, blackhole, learner, novice, event
}

enum StringOuCorrector: Codable {
    case string(String)
    case corrector(Corrector)
}
