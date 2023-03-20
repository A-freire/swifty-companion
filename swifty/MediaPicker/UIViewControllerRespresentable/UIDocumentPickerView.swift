//
//  UIDocumentPickerView.swift
//  SwiftUIPHPickerDemo
//
//  Created by Alex Nagy on 28.02.2022.
// swiftlint:disable line_length

import Foundation
import SwiftUI
import UIKit
import UniformTypeIdentifiers

public struct UIDocumentPickerView: UIViewControllerRepresentable {
    @ObservedObject public var service: MediaPickerService
    public var onCancel: (() -> Void)?
    public func makeUIViewController(context: UIViewControllerRepresentableContext<UIDocumentPickerView>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [service.documentSupportedType], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(_: UIDocumentPickerView.UIViewControllerType, context _: UIViewControllerRepresentableContext<UIDocumentPickerView>) {}

    public func makeCoordinator() -> UIDocumentPickerView.Coordinator {
        Coordinator(parent: self, onCancel: onCancel)
    }

    public class Coordinator: NSObject, UIDocumentPickerDelegate {
        public let parent: UIDocumentPickerView
        public let onCancel: (() -> Void)?
        public init(parent: UIDocumentPickerView, onCancel: (() -> Void)?) {
            self.parent = parent
            self.onCancel = onCancel
        }

        public func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            let documentUrl = DocumentURL(url: url, supportedType: parent.service.documentSupportedType)
            let mediaPickerResult = MediaPickerResult(type: .document, documentUrl: documentUrl)
            parent.service.mediaPickerResult = mediaPickerResult
            parent.service.isPresented = false
        }

        public func documentPickerWasCancelled(_: UIDocumentPickerViewController) {
            onCancel?()
            parent.service.isPresented = false
        }
    }
}
