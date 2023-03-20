//
//  PDFDocumentView.swift
//  SwiftUIPHPickerDemo
//
//  Created by Alex Nagy on 28.02.2022.
//

import PDFKit
import SwiftUI

struct PDFDocumentView: UIViewRepresentable {
    typealias UIViewType = PDFView

    let pdfDocument: PDFDocument

    init(_ pdfDocument: PDFDocument) {
        self.pdfDocument = pdfDocument
    }

    func makeUIView(context _: UIViewRepresentableContext<PDFDocumentView>) -> UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ pdfView: UIViewType, context _: UIViewRepresentableContext<PDFDocumentView>) {
        pdfView.document = pdfDocument
    }
}
