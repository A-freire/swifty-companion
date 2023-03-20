//
//  MediaPickerMultipleView.swift
//  SwiftUIPHPickerDemo
//
//  Created by Alex Nagy on 13.02.2022.
//

import AVKit
import PhotosUI
import SwiftUI

/// View that loads items ``MediaPickerType`` ``multiple``
struct MediaPickerMultipleView: View {
    @State private var loaded = false
    @State private var photo: UIImage?
    @State private var url: URL?
    @State private var livePhoto: PHLivePhoto?
    @State private var mediaType: MediaType = .loading
    @State private var latestErrorDescription = ""
    var result: PHPickerResult

    enum MediaType {
        case loading, error, photo, video, livePhoto
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
            case .livePhoto:
                if livePhoto != nil {
                    LivePhotoView(livePhoto: livePhoto!)
                } else {
                    EmptyView()
                }
            }
        }
        .onAppear {
            if !loaded {
                // load the object from the result
                loadObject()
            }
        }
    }

    func loadObject() {
        let itemProvider = result.itemProvider
        // make sure we have a valid typeIdentifier
        guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
              let utType = UTType(typeIdentifier)
        else {
            latestErrorDescription = "Could not find type identifier"
            mediaType = .error
            loaded = true
            return
        }
        // get the oject according to the specific typeIdentifier
        if utType.conforms(to: .image) {
            getPhoto(from: itemProvider, isLivePhoto: false)
        } else if utType.conforms(to: .movie) {
            getVideo(from: itemProvider, typeIdentifier: typeIdentifier)
        } else {
            getPhoto(from: itemProvider, isLivePhoto: true)
        }
    }

    private func getPhoto(from itemProvider: NSItemProvider, isLivePhoto: Bool) {
        let objectType: NSItemProviderReading.Type = !isLivePhoto ? UIImage.self : PHLivePhoto.self
        // make sure we can load the object
        if itemProvider.canLoadObject(ofClass: objectType) {
            // load the object
            itemProvider.loadObject(ofClass: objectType) { object, error in
                // handle error
                if let error = error {
                    print(error.localizedDescription)
                    latestErrorDescription = error.localizedDescription
                    mediaType = .error
                    loaded = true
                }
                if !isLivePhoto {
                    // unwrap image
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            // set photo so it appears on the view
                            self.mediaType = .photo
                            self.photo = image
                            self.loaded = true
                        }
                    }
                } else {
                    // unwrap live photo
                    if let livePhoto = object as? PHLivePhoto {
                        DispatchQueue.main.async {
                            // set live photo so it appears on the view
                            self.mediaType = .livePhoto
                            self.livePhoto = livePhoto
                            self.loaded = true
                        }
                    }
                }
            }
        }
    }

    private func getVideo(from itemProvider: NSItemProvider, typeIdentifier: String) {
        // get selected local video file url
        itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
            // handle errors
            if let error = error {
                print(error.localizedDescription)
                latestErrorDescription = error.localizedDescription
                mediaType = .error
                loaded = true
            }

            // make sure url is not nil
            guard let url = url else {
                latestErrorDescription = "Url is nil"
                mediaType = .error
                loaded = true
                return
            }

            // get the documents directory
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            // create a target url where we will save our video
            guard let targetURL = documentsDirectory?.appendingPathComponent(url.lastPathComponent) else {
                latestErrorDescription = "Failed to create target url"
                mediaType = .error
                loaded = true
                return
            }
            do {
                // if the file alreay exists there remove it
                if FileManager.default.fileExists(atPath: targetURL.path) {
                    try FileManager.default.removeItem(at: targetURL)
                }
                // try to save the file
                try FileManager.default.copyItem(at: url, to: targetURL)
                DispatchQueue.main.async {
                    // set video so it appears on the view
                    self.mediaType = .video
                    self.url = targetURL
                    self.loaded = true
                }
            } catch {
                DispatchQueue.main.async {
                    // handle errors
                    print(error.localizedDescription)
                    latestErrorDescription = error.localizedDescription
                    mediaType = .error
                    loaded = true
                }
            }
        }
    }

    // remove all media, even deleting vidoes from url
    func delete() {
        switch mediaType {
        case .photo: photo = nil
        case .livePhoto: livePhoto = nil
        case .video:
            guard let url = url else { return }
            try? FileManager.default.removeItem(at: url)
            self.url = nil
        default:
            print("Default")
        }
    }
}
