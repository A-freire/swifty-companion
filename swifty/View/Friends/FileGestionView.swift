//
//  FileGestionView.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 20/03/2023.
//

import SwiftUI
import MobileCoreServices

struct DocumentPicker: UIViewControllerRepresentable {
    let jsonURL: URL

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forExporting: [jsonURL])
        documentPicker.delegate = context.coordinator
        return documentPicker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
    }
}
