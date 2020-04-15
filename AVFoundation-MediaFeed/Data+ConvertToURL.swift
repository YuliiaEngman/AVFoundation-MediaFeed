//
//  Data+ConvertToURL.swift
//  AVFoundation-MediaFeed
//
//  Created by Yuliia Engman on 4/15/20.
//  Copyright © 2020 Yuliia Engman. All rights reserved.
//

import Foundation

extension Data {
    
    // user case example:
    //let url = mediaObject.videoData.convertToURL()
    // let url = mediaObject.self.convertURL()
    
    public func convertToURL() -> URL? {
        
        //create a temporary url
        // NSTemporaryDirectory() - stores temporary files, those file get deleted as needed is for permanent storege
        // documents directory is for permanent storage
        // cashes directory is temporary storage
        
        // in Core Data the video is saved as Data
        // when playing back the video we need to have a URL pointing to the video location on disk
        // AVPlayer need a URL pointing to a location on disk
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video").appendingPathExtension("mp4")
        
        do {
            try self.write(to: tempURL, options: [.atomic]) // atomic means write everything at once
        } catch {
            print("failed to write (save) video data to temporary file with error: \(error)")
        }
        return nil
    }
    
    
}
