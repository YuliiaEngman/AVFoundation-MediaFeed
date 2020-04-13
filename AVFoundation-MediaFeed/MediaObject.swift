//
//  MediaObject.swift
//  AVFoundation-MediaFeed
//
//  Created by Yuliia Engman on 4/13/20.
//  Copyright © 2020 Yuliia Engman. All rights reserved.
//

import Foundation

// actual data for the cell: video or image

struct MediaObject {
    let imageData: Data?
    let videoURL: URL?
    let caption: String? // UI so user can enter text
    let id = UUID().uuidString // unigue id that will be stored as string
    let createDate = Date()
}
