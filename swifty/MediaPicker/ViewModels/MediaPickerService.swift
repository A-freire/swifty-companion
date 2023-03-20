//
//  MediaPickerService.swift
//  SwiftUIPHPickerDemo
//
//  Created by Alex Nagy on 15.02.2022.
//
// swiftlint:disable cyclomatic_complexity
import Combine
import PDFKit
import PhotosUI
import SwiftUI
import UniformTypeIdentifiers

public class MediaPickerService: ObservableObject {
    @Published public var isPresented = false
    @Published public var pickerType: MediaPickerType = .single
    @Published public var mediaPickerResult = MediaPickerResult()
    @Published public var filters: [PHPickerFilter] = []
    @Published public var selectionLimit: MediaPickerSelectionLimit = 1
    @Published public var filterType: UIImagePickerFilter = .photoLibrary
    @Published public var allowsEditing: Bool = false
    @Published public var documentSupportedType: UTType = .pdf
    @Published public var images = [UIImage]()
    @Published public var videoUrls = [URL]()
    @Published public var livePhotos = [PHLivePhoto]()
    @Published public var pdfDocuments = [PDFDocument]()
    @Published public var documentUrls = [URL]()

    public var cancellables: Set<AnyCancellable> = []

    public init() {
        $isPresented.sink { isPresented in
            if isPresented {
                self.mediaPickerResult = MediaPickerResult()
            } else {
                self.reset()
            }
        }.store(in: &cancellables)

        $mediaPickerResult.sink { result in
            self.handle(result)
        }.store(in: &cancellables)
    }

    // swiftlint:disable function_body_length
    private func handle(_ result: MediaPickerResult) {
        images.removeAll()
        videoUrls.removeAll()
        livePhotos.removeAll()
        pdfDocuments.removeAll()
        documentUrls.removeAll()

        switch pickerType {
        case .single:
            guard let info = result.info else { return }
            switch filterType {
            case .photoCamera, .photoLibrary, .savedPhotosAlbum:
                MediaPickerObjectLoader.loadImage(info) { result in
                    switch result {
                    case let .success(image):
                        self.images = [image]
                    case let .failure(err):
                        print(err.localizedDescription)
                    }
                }
            case .videoCamera:
                MediaPickerObjectLoader.loadVideo(info) { result in
                    switch result {
                    case let .success(url):
                        self.videoUrls = [url]
                    case let .failure(err):
                        print(err.localizedDescription)
                    }
                }
            case .photoAndVideoCamera:
                MediaPickerObjectLoader.loadImageOrVideo(info) { result in
                    switch result {
                    case let .success(imageOrVideo):
                        if let image = imageOrVideo.image {
                            self.images = [image]
                        } else if let url = imageOrVideo.video {
                            self.videoUrls = [url]
                        }
                    case let .failure(err):
                        print(err.localizedDescription)
                    }
                }
            }
        case .multiple:
            guard let results = result.results else { return }
            for result in results {
                filters.forEach { filter in
                    switch filter {
                    case .images:
                        MediaPickerObjectLoader.loadPhoto(result) { result in
                            switch result {
                            case let .success(image):
                                self.images.append(image)
                            case let .failure(err):
                                print(err.localizedDescription)
                            }
                        }
                    case .livePhotos:
                        MediaPickerObjectLoader.loadLivePhoto(result) { result in
                            switch result {
                            case let .success(livePhoto):
                                self.livePhotos.append(livePhoto)
                            case let .failure(err):
                                print(err.localizedDescription)
                            }
                        }
                    case .videos:
                        MediaPickerObjectLoader.loadMovie(result) { result in
                            switch result {
                            case let .success(movie):
                                self.videoUrls.append(movie)
                            case let .failure(err):
                                print(err.localizedDescription)
                            }
                        }
                    default:
                        print("Default filter: \(filter)")
                    }
                }
            }
        case .document:
            guard let documentUrl = result.documentUrl else { return }
            let url = documentUrl.url
            documentSupportedType = documentUrl.supportedType
            switch documentSupportedType {
            case .image:
                do {
                    let data = try Data(contentsOf: url)
                    if let uiImage = UIImage(data: data) {
                        images.append(uiImage)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .video:
                videoUrls.append(url)
            case .pdf:
                if let pdfDocument = PDFDocument(url: url) {
                    pdfDocuments.append(pdfDocument)
                }
            default:
                documentUrls.append(url)
            }
        }
    }

    /// Presents a ``MediaPickerView``
    /// - Parameter filter: type of MediaPicker
    public func present(_ filter: MediaPickerFilter) {
        switch filter {
        case let .photoFromCamera(allowsEditing):
            show(filterType: .photoCamera, allowsEditing: allowsEditing)
        case let .videoFromCamera(allowsEditing):
            show(filterType: .videoCamera, allowsEditing: allowsEditing)
        case let .photoOrVideoFromCamera(allowsEditing):
            show(filterType: .photoAndVideoCamera, allowsEditing: allowsEditing)
        case let .photoFromPhotoLibrary(allowsEditing):
            show(filterType: .photoLibrary, allowsEditing: allowsEditing)
        case let .photoFromSavedPhotoAlbums(allowsEditing):
            show(filterType: .savedPhotosAlbum, allowsEditing: allowsEditing)
        case let .images(selectionLimit):
            show(filters: [.images], selectionLimit: selectionLimit)
        case let .videos(selectionLimit):
            show(filters: [.videos], selectionLimit: selectionLimit)
        case let .livePhotos(selectionLimit):
            show(filters: [.livePhotos], selectionLimit: selectionLimit)
        case let .imagesAndVideos(selectionLimit):
            show(filters: [.images, .videos], selectionLimit: selectionLimit)
        case let .imagesAndLivePhotos(selectionLimit):
            show(filters: [.images, .livePhotos], selectionLimit: selectionLimit)
        case let .videosAndLivePhotos(selectionLimit):
            show(filters: [.videos, .livePhotos], selectionLimit: selectionLimit)
        case let .imagesVideosAndLivePhotos(selectionLimit):
            show(filters: [.images, .videos, .livePhotos], selectionLimit: selectionLimit)
        case .imageDocument:
            show(documentSupportedType: .image)
        case .videoDocument:
            show(documentSupportedType: .video)
        case .pdfDocument:
            show(documentSupportedType: .pdf)
        case let .document(type):
            show(documentSupportedType: type)
        }
    }

    private func show(filterType: UIImagePickerFilter, allowsEditing: Bool) {
        pickerType = .single
        self.filterType = filterType
        self.allowsEditing = allowsEditing
        isPresented = true
    }

    private func show(filters: [PHPickerFilter], selectionLimit: MediaPickerSelectionLimit) {
        pickerType = .multiple
        self.filters = filters
        self.selectionLimit = selectionLimit
        isPresented = true
    }

    private func show(documentSupportedType: UTType) {
        pickerType = .document
        self.documentSupportedType = documentSupportedType
        isPresented = true
    }

    public func reset() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.filters.removeAll()
            self.selectionLimit = .exactly(1)
            self.filterType = .photoLibrary
            self.allowsEditing = false
        }
    }

    /// Removes all items from ``MediaPickerResult``
    public func removeAll() {
        mediaPickerResult.results = nil
        mediaPickerResult.info = nil
        mediaPickerResult.documentUrl = nil
    }
}
