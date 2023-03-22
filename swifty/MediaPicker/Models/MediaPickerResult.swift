//
//  MediaPickerResult.swift
//  SwiftUIPHPickerDemo
//
//  Created by Alex Nagy on 15.02.2022.
//

import PhotosUI
import SwiftUI

public struct MediaPickerResult: Identifiable {
    public var id = UUID().uuidString
    /// Type of media picker has been used
    public var type: MediaPickerType
    /// Items for ``MediaPickerType`` ``multiple``
    public var results: [PHPickerResult]?
    /// Items for ``MediaPickerType`` ``single``
    public var info: [UIImagePickerController.InfoKey: Any]?
    /// Items for ``MediaPickerType`` ``document``
    public var documentUrl: DocumentURL?
    public init(type: MediaPickerType? = nil,
                results: [PHPickerResult]? = nil,
                info: [UIImagePickerController.InfoKey: Any]? = nil,
                documentUrl: DocumentURL? = nil) {
        self.type = type ?? .single
        self.results = results ?? []
        self.info = info
        self.documentUrl = documentUrl
    }

    /// Get the count of the ``MediaPickerResult`` items
    /// - Returns: Count of items
    public func count() -> Int {
        switch type {
        case .single:
            return info != nil ? 1 : 0
        case .multiple:
            return results != nil ? results!.count : 0
        case .document:
            return documentUrl != nil ? 1 : 0
        }
    }
}
