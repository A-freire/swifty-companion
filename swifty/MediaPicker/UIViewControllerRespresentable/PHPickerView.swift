//
//  PHPickerView.swift
//  SwiftUIPHPickerDemo
//
//  Created by Alex Nagy on 13.02.2022.
//

import PhotosUI
import SwiftUI

// SwiftUI view for PHPickerViewController
struct PHPickerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = PHPickerViewController
    @ObservedObject public var service: MediaPickerService
    public var onCancel: (() -> Void)?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .any(of: service.filters)
        config.selectionLimit = service.selectionLimit
        config.preferredAssetRepresentationMode = .current
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_: PHPickerViewController, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self, onCancel: onCancel)
    }

    class Coordinator: PHPickerViewControllerDelegate {
        let parent: PHPickerView
        let onCancel: (() -> Void)?

        init(_ parent: PHPickerView, onCancel: (() -> Void)?) {
            self.parent = parent
            self.onCancel = onCancel
        }

        func picker(_: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.service.isPresented = false

            guard !results.isEmpty else {
                onCancel?()
                return
            }

            let mediaPickerResult = MediaPickerResult(type: .multiple, results: results)
            parent.service.mediaPickerResult = mediaPickerResult
        }
    }
}
