//
//  MediaPickerSingleView.swift
//  SwiftUIPHPickerDemo
//
//  Created by Alex Nagy on 15.02.2022.
//

import AVKit
import SwiftUI

/// View that loads items ``MediaPickerType`` ``single``
struct MediaPickerSingleView: View {
    var info: [UIImagePickerController.InfoKey: Any]?

    enum MediaType {
        case loading, error, photo, video
    }

    @State private var loaded = false
    @State private var photo: UIImage?
    @State private var url: URL?
    @State private var mediaType: MediaType = .loading
    @State private var latestErrorDescription = ""

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
            }
        }
        .onAppear {
            if !loaded {
                loadObject()
            }
        }
    }

    func loadObject() {
        guard let info = info else {
            latestErrorDescription = "Could not find info"
            mediaType = .error
            loaded = true
            return
        }

        if let editedImage = info[.editedImage] as? UIImage {
            photo = editedImage
            mediaType = .photo
            loaded = true
        } else if let originalImage = info[.originalImage] as? UIImage {
            photo = originalImage
            mediaType = .photo
            loaded = true
        } else if let videoUrl = info[.mediaURL] as? URL {
            url = videoUrl
            mediaType = .video
            loaded = true
        } else {
            latestErrorDescription = "Invalid info"
            mediaType = .error
            loaded = true
        }
    }
}
