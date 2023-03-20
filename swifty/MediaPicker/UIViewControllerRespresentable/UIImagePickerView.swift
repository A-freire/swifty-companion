//
//  UIImagePickerView.swift
//  SwiftUIPHPickerDemo
//
//  Created by Alex Nagy on 15.02.2022.
//

import SwiftUI
import UIKit

public struct UIImagePickerView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = UIImagePickerController
    @ObservedObject public var service: MediaPickerService
    public var onCancel: (() -> Void)?

    public func makeUIViewController(context:
        UIViewControllerRepresentableContext<UIImagePickerView>) ->
        UIImagePickerController
    {
        let picker = UIImagePickerController()
        picker.allowsEditing = service.allowsEditing

        switch service.filterType {
        case .photoCamera:
            picker.sourceType = .camera
            picker.mediaTypes = ["public.image"]
        case .videoCamera:
            picker.sourceType = .camera
            picker.mediaTypes = ["public.movie"]
        case .photoAndVideoCamera:
            picker.sourceType = .camera
            picker.mediaTypes = ["public.movie", "public.image"]
        case .photoLibrary:
            picker.sourceType = .photoLibrary
        case .savedPhotosAlbum:
            picker.sourceType = .savedPhotosAlbum
        }

        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(_: UIImagePickerController,
                                       context _: UIViewControllerRepresentableContext<UIImagePickerView>) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(self, onCancel: onCancel)
    }

    public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: UIImagePickerView
        let onCancel: (() -> Void)?

        init(_ parent: UIImagePickerView, onCancel: (() -> Void)?) {
            self.parent = parent
            self.onCancel = onCancel
        }

        public func imagePickerController(_: UIImagePickerController,
                                          didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
        {
            let mediaPickerResult = MediaPickerResult(type: .single, info: info)
            parent.service.mediaPickerResult = mediaPickerResult
            parent.service.isPresented = false
        }

        public func imagePickerControllerDidCancel(_: UIImagePickerController) {
            onCancel?()
            parent.service.isPresented = false
        }
    }
}
