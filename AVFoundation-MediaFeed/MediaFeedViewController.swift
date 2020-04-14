//
//  ViewController.swift
//  AVFoundation-MediaFeed
//
//  Created by Yuliia Engman on 4/13/20.
//  Copyright © 2020 Yuliia Engman. All rights reserved.
//

import UIKit
import AVFoundation // video playback is done on a CALayer - all views are backed e.g. if we want to make a view rounded we can only do this using the CALayer of that view, e.g. someView
import AVKit // AVPlayerViewController lives here

class MediaFeedViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var videoButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        let pickerController = UIImagePickerController()
        pickerController.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
        pickerController.delegate = self
        return pickerController
    }()
    
    private var mediaObjects = [MediaObject]() {
        didSet { // property observer
            collectionView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            videoButton.isEnabled = false
        }
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @IBAction func videoButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    private func playRandomVideo(in view: UIView) {
        // we want all non-nil media objects from the media objects array
        // compactMap - because it returns all non-nil values
        
        let videoURLs = mediaObjects.compactMap{ $0.videoURL }
        
        if let videoURL = videoURLs.randomElement() { // randomelelment - optional - we need to do optional bindidng
            let player = AVPlayer(url: videoURL)
            
            // create a sublayer
            let playerLayer = AVPlayerLayer(player: player)
            
            // set its frame
            playerLayer.frame = view.bounds // view getting passed to the function, takes the entire headerView
            
            // set video aspect ratio
            //playerLayer.videoGravity = .resizeAspect
            playerLayer.videoGravity = .resizeAspectFill
            
            // remove all sublayers from the headerView
            view.layer.sublayers?.removeAll()
            
            // add the playerLyer to the headerView's layout
            view.layer.addSublayer(playerLayer)
            
            //play video
            player.play()
        }
    }
    
}

extension MediaFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as? MediaCell else {
            fatalError("could not dequeue a MediaCell")
        }
        let mediaObject = mediaObjects[indexPath.row]
        cell.configureCell(for: mediaObject)
        return cell
    }
    
    // for header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as? HeaderView else {
            fatalError("could not dequeue a Headerview")
        }
        playRandomVideo(in: headerView)
        return headerView // is of the UICollectionReusableView
    }
}

extension MediaFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mediaObject = mediaObjects[indexPath.row]
        guard let videoURL = mediaObject.videoURL else {
            return
        }
        
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer(url: videoURL)
        playerViewController.player = player
        
        present(playerViewController, animated: true)
        
        //play video automatically
        player.play()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width
        let itemHeight: CGFloat = maxSize.height * 0.40
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    // sixe for header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height * 0.40)
    }
}

extension MediaFeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // info dictionary keys
        // InfoKey.originalImage - UIImage
        // InfoKey.mediaType = String
        // InfoKey.mediaURL = URL
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {
            return
        }
        
        switch mediaType {
        case "public.image":
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let imageData = originalImage.jpegData(compressionQuality: 1.0){
                let mediaObject = MediaObject(imageData: imageData, videoURL: nil, caption: nil)
                mediaObjects.append(mediaObject) // 0 => 1
            }
        case "public.movie":
            if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                print("mediaURL: \(mediaURL)")
                let mediaObject = MediaObject(imageData: nil, videoURL: mediaURL, caption: nil)
                mediaObjects.append(mediaObject)
            }
        default:
            print("unsupported media type")
        }
        
       // print("mediaType: \(mediaType)") // "public.videao" or "public.image"
        
        picker.dismiss(animated: true)
    }
}

