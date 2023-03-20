//
//  MediaPickerView.swift
//  SwiftUIPHPickerDemo
//
//  Created by Alex Nagy on 15.02.2022.
//

import PhotosUI
import SwiftUI

public struct MediaPickerView: View {
    @ObservedObject public var mediaPickerService: MediaPickerService
    public var onCancel: (() -> Void)?

    public var body: some View {
        switch mediaPickerService.pickerType {
        case .single:
            UIImagePickerView(service: mediaPickerService, onCancel: onCancel)
        case .multiple:
            PHPickerView(service: mediaPickerService, onCancel: onCancel)
        case .document:
            UIDocumentPickerView(service: mediaPickerService, onCancel: onCancel)
        }
    }
}
