//
//  MediaPickerDocumentView.swift
//  SwiftUIPHPickerDemo
//
//  Created by Alex Nagy on 28.02.2022.
//

import AVKit
import SwiftUI

struct MediaPickerDocumentView: View {
    var documentUrl: DocumentURL?
    @State private var loaded = false
    @State private var photo: UIImage?
    @State private var url: URL?
    @State private var mediaType: MediaType = .loading
    @State private var latestErrorDescription = ""

    enum MediaType {
        case loading, error, photo, video, pdf, document
    }

    var body: some View {
        Group {
            switch mediaType {
            case .loading:
                ProgressView()
            case .error:
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text(latestErrorDescription).font(.caption)
                }
                .foregroundColor(.gray)
            case .photo:
                if photo != nil {
                    Image(uiImage: photo!)
                        .resizable()
                } else {
                    EmptyView()
                }
            case .video:
                if url != nil {
                    VideoPlayer(player: AVPlayer(url: url!))
                } else {
                    EmptyView()
                }
            case .pdf:
                if url != nil {
                    PDFKitView(url!)
                } else {
                    EmptyView()
                }
            case .document:
                if url != nil {
                    Text("""
                    Media type of 'document' is \nnot supported by MediaPickerView.
                    \n\nPlease use \n'mediaPickerService.documentUrls' instead.
                    """)
                    .bold()
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                } else {
                    EmptyView()
                }
            }
        }
        .onAppear {
            if !loaded {
                loadObject()
            }
        }
    }

    func loadObject() {
        guard let documentUrl = documentUrl else {
            latestErrorDescription = "Could not find documentUrl"
            mediaType = .error
            loaded = true
            return
        }

        let url = documentUrl.url
        let supportedType = documentUrl.supportedType

        switch supportedType {
        case .image:
            do {
                let data = try Data(contentsOf: url)
                photo = UIImage(data: data)
                mediaType = .photo
                loaded = true
            } catch {
                latestErrorDescription = error.localizedDescription
                mediaType = .error
                loaded = true
            }
        case .video:
            self.url = url
            mediaType = .video
            loaded = true
        case .pdf:
            self.url = url
            mediaType = .pdf
            loaded = true
        default:
            self.url = url
            mediaType = .document
            loaded = true
        }
    }
}
