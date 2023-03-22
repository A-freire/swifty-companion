//
//  MediaPickerViewModifier.swift
//  SwiftUIPHPickerDemo
//
//  Created by Alex Nagy on 15.02.2022.
//

import SwiftUI

struct MediaPickerViewModifier: ViewModifier {
    // MARK: - ObservedObjects

    @ObservedObject var mediaPickerService: MediaPickerService
    var onCancel: (() -> Void)?
    var onDismiss: (() -> Void)?

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $mediaPickerService.isPresented, onDismiss: onDismiss) {
                MediaPickerView(mediaPickerService: mediaPickerService, onCancel: onCancel)
                    .ignoresSafeArea()
            }
    }
}

extension View {
    /// Attaches a MediaPickerView to the view hierarchy
    /// - Parameters:
    ///   - service: MediaPicker Service
    ///   - onCancel: optional callback for ``cancel`` event
    ///   - onDismiss: optional callback for ``dismiss`` event
    /// - Returns: a View
    func mediaPickerSheet(service: MediaPickerService,
                          onCancel: (() -> Void)?,
                          onDismiss: (() -> Void)?) -> some View {
        modifier(MediaPickerViewModifier(mediaPickerService: service, onCancel: onCancel, onDismiss: onDismiss))
    }
}
