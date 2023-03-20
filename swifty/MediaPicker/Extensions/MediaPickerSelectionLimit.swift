//
//  MediaPickerSelectionLimit.swift
//  SwiftUIPHPickerDemo
//
//  Created by Alex Nagy on 13.02.2022.
//

import Foundation

public typealias MediaPickerSelectionLimit = Int

// convinince extension on Int to represent selection limit in a more readable way
public extension MediaPickerSelectionLimit {
    static func unlimited() -> Int {
        0
    }

    static func exactly(_ value: Int) -> Int {
        value
    }
}
