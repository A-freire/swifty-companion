//
//  PDFKitView.swift
//  SwiftUIPHPickerDemo
//
//  Created by Alex Nagy on 28.02.2022.
//

import PDFKit
import SwiftUI

struct PDFKitView: UIViewRepresentable {
    typealias UIViewType = PDFView

    let url: URL

    init(_ url: URL) {
        self.url = url
    }

    func makeUIView(context _: UIViewRepresentableContext<PDFKitView>) -> UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ pdfView: UIViewType, context _: UIViewRepresentableContext<PDFKitView>) {
        pdfView.document = PDFDocument(url: url)
    }
}
