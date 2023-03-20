//
//  LivePhotoView.swift
//  SwiftUIPHPickerDemo
//
//  Created by Alex Nagy on 13.02.2022.
//

import PhotosUI
import SwiftUI

// SwiftUI view for PHLivePhotoView
struct LivePhotoView: UIViewRepresentable {
    typealias UIViewType = PHLivePhotoView
    var livePhoto: PHLivePhoto

    func makeUIView(context _: Context) -> PHLivePhotoView {
        let livePhotoView = PHLivePhotoView()
        livePhotoView.livePhoto = livePhoto
        return livePhotoView
    }

    func updateUIView(_: PHLivePhotoView, context _: Context) {}
}
