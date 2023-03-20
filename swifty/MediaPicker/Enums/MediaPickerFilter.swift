//
//  MediaPickerFilter.swift
//  SwiftUIPHPickerDemo
//
//  Created by Alex Nagy on 15.02.2022.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

public enum MediaPickerFilter {
    case photoFromCamera(allowsEditing: Bool)
    case videoFromCamera(allowsEditing: Bool)
    case photoOrVideoFromCamera(allowsEditing: Bool)
    case photoFromPhotoLibrary(allowsEditing: Bool)
    case photoFromSavedPhotoAlbums(allowsEditing: Bool)
    case images(selectionLimit: MediaPickerSelectionLimit)
    case videos(selectionLimit: MediaPickerSelectionLimit)
    case livePhotos(selectionLimit: MediaPickerSelectionLimit)
    case imagesAndVideos(selectionLimit: MediaPickerSelectionLimit)
    case imagesAndLivePhotos(selectionLimit: MediaPickerSelectionLimit)
    case videosAndLivePhotos(selectionLimit: MediaPickerSelectionLimit)
    case imagesVideosAndLivePhotos(selectionLimit: MediaPickerSelectionLimit)
    case imageDocument
    case videoDocument
    case pdfDocument
    case document(type: UTType)
}
