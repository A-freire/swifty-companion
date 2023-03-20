//
//  MediaPickerObjectLoader.swift
//  SwiftUIPHPickerDemo
//
//  Created by Alex Nagy on 16.02.2022.
//

import AVKit
import Foundation
import PhotosUI

struct MediaPickerImageOrVideo {
    let image: UIImage?
    let video: URL?
}

enum MediaPickerObjectLoader {
    static func loadImage(_ info: [UIImagePickerController.InfoKey: Any]?,
                          completion: @escaping (Result<UIImage, Error>) -> Void)
    {
        guard let info = info else {
            completion(.failure(NSError(domain: "Could not find info", code: -1)))
            return
        }

        if let editedImage = info[.editedImage] as? UIImage {
            completion(.success(editedImage))
        } else if let originalImage = info[.originalImage] as? UIImage {
            completion(.success(originalImage))
        } else {
            completion(.failure(NSError(domain: "Invalid info", code: -1)))
        }
    }

    static func loadVideo(_ info: [UIImagePickerController.InfoKey: Any]?,
                          completion: @escaping (Result<URL, Error>) -> Void)
    {
        guard let info = info else {
            completion(.failure(NSError(domain: "Could not find info", code: -1)))
            return
        }

        if let url = info[.mediaURL] as? URL {
            completion(.success(url))
        } else {
            completion(.failure(NSError(domain: "Invalid info", code: -1)))
        }
    }

    static func loadImageOrVideo(_ info: [UIImagePickerController.InfoKey: Any]?,
                                 completion: @escaping (Result<MediaPickerImageOrVideo, Error>) -> Void)
    {
        guard let info = info else {
            completion(.failure(NSError(domain: "Could not find info", code: -1)))
            return
        }

        if let editedImage = info[.editedImage] as? UIImage {
            completion(.success(MediaPickerImageOrVideo(image: editedImage, video: nil)))
        } else if let originalImage = info[.originalImage] as? UIImage {
            completion(.success(MediaPickerImageOrVideo(image: originalImage, video: nil)))
        } else if let url = info[.mediaURL] as? URL {
            completion(.success(MediaPickerImageOrVideo(image: nil, video: url)))
        } else {
            completion(.failure(NSError(domain: "Invalid info", code: -1)))
        }
    }

    static func loadPhoto(_ result: PHPickerResult, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let itemProvider = result.itemProvider

        guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
              let utType = UTType(typeIdentifier)
        else {
            completion(.failure(NSError(domain: "Could not find type identifier", code: -1)))
            return
        }
        if utType.conforms(to: .image) {
            getPhoto(from: itemProvider, completion: completion)
        } else {
            completion(.failure(NSError(domain: "Does not conform to type identifier: image", code: -1)))
        }
    }

    static func loadLivePhoto(_ result: PHPickerResult,
                              completion: @escaping (Result<PHLivePhoto, Error>) -> Void)
    {
        let itemProvider = result.itemProvider
        getLivePhoto(from: itemProvider, completion: completion)
    }

    static func loadMovie(_ result: PHPickerResult, completion: @escaping (Result<URL, Error>) -> Void) {
        let itemProvider = result.itemProvider
        guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
              let utType = UTType(typeIdentifier)
        else {
            completion(.failure(NSError(domain: "Could not find type identifier", code: -1)))
            return
        }
        if utType.conforms(to: .movie) {
            getMovie(from: itemProvider, typeIdentifier: typeIdentifier, completion: completion)
        } else {
            completion(.failure(NSError(domain: "Does not conform to type identifier: movie", code: -1)))
        }
    }

    private static func getPhoto(from itemProvider: NSItemProvider,
                                 completion: @escaping (Result<UIImage, Error>) -> Void)
    {
        let objectType: NSItemProviderReading.Type = UIImage.self
        if itemProvider.canLoadObject(ofClass: objectType) {
            itemProvider.loadObject(ofClass: objectType) { object, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if let object = object as? UIImage {
                        completion(.success(object))
                    } else {
                        completion(.failure(NSError(domain: "Failed to cast UIImage", code: -1)))
                    }
                }
            }
        }
    }

    private static func getLivePhoto(from itemProvider: NSItemProvider,
                                     completion: @escaping (Result<PHLivePhoto, Error>) -> Void)
    {
        let objectType: NSItemProviderReading.Type = PHLivePhoto.self
        if itemProvider.canLoadObject(ofClass: objectType) {
            itemProvider.loadObject(ofClass: objectType) { object, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if let object = object as? PHLivePhoto {
                        completion(.success(object))
                    } else {
                        completion(.failure(NSError(domain: "Failed to cast PHLivePhoto", code: -1)))
                    }
                }
            }
        }
    }

    private static func getMovie(from itemProvider: NSItemProvider,
                                 typeIdentifier: String,
                                 completion: @escaping (Result<URL, Error>) -> Void)
    {
        itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let url = url else {
                completion(.failure(NSError(domain: "Failed to cast URL", code: -1)))
                return
            }
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            guard let targetURL = documentsDirectory?.appendingPathComponent(url.lastPathComponent) else {
                completion(.failure(NSError(domain: "Failed to create target URL", code: -1)))
                return
            }
            do {
                if FileManager.default.fileExists(atPath: targetURL.path) {
                    try FileManager.default.removeItem(at: targetURL)
                }
                try FileManager.default.copyItem(at: url, to: targetURL)
                DispatchQueue.main.async {
                    completion(.success(targetURL))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    private static func loadFileRepresentation(itemProvider: NSItemProvider,
                                               typeIdentifier: String) async throws -> URL
    {
        try await withCheckedThrowingContinuation { continuation in
            itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let url = url else {
                    continuation.resume(throwing: NSError(domain: "Failed to cast URL", code: -1))
                    return
                }
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                guard let targetURL = documentsDirectory?.appendingPathComponent(url.lastPathComponent) else {
                    continuation.resume(throwing: NSError(domain: "Failed to create target URL", code: -1))
                    return
                }
                do {
                    if FileManager.default.fileExists(atPath: targetURL.path) {
                        try FileManager.default.removeItem(at: targetURL)
                    }
                    try FileManager.default.copyItem(at: url, to: targetURL)
                    continuation.resume(returning: targetURL)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private static func loadObject<T>(itemProvider: NSItemProvider,
                                      objectType: NSItemProviderReading.Type) async throws -> T
    {
        try await withCheckedThrowingContinuation { continuation in
            if itemProvider.canLoadObject(ofClass: objectType) {
                itemProvider.loadObject(ofClass: objectType) { object, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    if let object = object as? T {
                        continuation.resume(returning: object)
                    } else {
                        continuation.resume(throwing: NSError(domain: "Failed to cast Object", code: -1))
                    }
                }
            } else {
                continuation.resume(throwing: NSError(domain: "Cannot load Object", code: -1))
            }
        }
    }
}
