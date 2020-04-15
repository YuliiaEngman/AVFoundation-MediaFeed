//
//  MediaCell.swift
//  AVFoundation-MediaFeed
//
//  Created by Yuliia Engman on 4/13/20.
//  Copyright © 2020 Yuliia Engman. All rights reserved.
//

import UIKit

class MediaCell: UICollectionViewCell {
    
    @IBOutlet weak var mediaImageView: UIImageView!
    
    public func configureCell(for mediaObject: CDMediaObject) {
        // image or video
        if let imageData = mediaObject.imageData {
            // vonvert a Data object 
            mediaImageView.image = UIImage(data: imageData)
        }
        
        //TODO:  create video preview
        if let videoData = mediaObject.videoData?.convertToURL() {
            
            // or this ", let videoURL = videoData.convertToURL() {"
            let image = videoData.videoPreviewThumbnail() ?? UIImage(systemName: "heart")
            mediaImageView.image = image
            
        }
    }
}
