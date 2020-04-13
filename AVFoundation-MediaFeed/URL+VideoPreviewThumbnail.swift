//
//  URL+VideoPreviewThumbnail.swift
//  AVFoundation-MediaFeed
//
//  Created by Yuliia Engman on 4/13/20.
//  Copyright © 2020 Yuliia Engman. All rights reserved.
//

import UIKit
import AVFoundation

extension URL {
    
    public func videoPreviewThumbnail() -> UIImage? {
        
        // create an AVAsset instance
        // e.g. let image = mediaObject.videoURL.videoPreviewThumbnail
        let asset = AVAsset(url: self)
        
        // The AVAssetImageGenerator is an AVFoundation class that converts a given media url to an image
        let assetGenerator = AVAssetImageGenerator(asset: asset)
        
        // we want to maintain the aspect ratio of the video
        assetGenerator.appliesPreferredTrackTransform = true
        
        // create a timestamp of needed location in the video
        // we will use a CMTime to generate the given timestamp
        // CMTime is type of Core Media
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60) // retrieve the first seccond of the video
        
        var image: UIImage?
        
        do {
            let cgImage = try assetGenerator.copyCGImage(at: timestamp, actualTime: nil)
            image = UIImage(cgImage: cgImage)
           // UIView - top level API
            // Layer - lower lavel API does not know about its view
            
            //lower level API dont know about UIKit, AVKit \
            // e.g. someView.layer.borderColor = UIcolor.green.cgColor
        } catch {
            print("failed to generate image: \(error)")
        }
         
        return image
    }
}
