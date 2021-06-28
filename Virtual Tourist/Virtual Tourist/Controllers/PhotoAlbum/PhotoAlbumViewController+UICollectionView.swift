//
//  PhotoAlbumViewController+UICollectionView.swift
//  Virtual Tourist
//
//  Created by Eduardo Ramos on 27/06/21.
//

import Foundation
import UIKit

class ImageTapGesture: UITapGestureRecognizer {
    var photo: Photo!
}

extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        guard ((fetchedResultsController.fetchedObjects?.isEmpty) != nil) else {
            print("Empty, returning empty cell")
            return photoCell
        }
        
        let photo = fetchedResultsController.object(at: indexPath)
        let mediaData = photo.media
        
        let tapGestureRecognizer = ImageTapGesture(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapGestureRecognizer.photo = photo
        photoCell.mediaImage.isUserInteractionEnabled = true
        photoCell.mediaImage.addGestureRecognizer(tapGestureRecognizer)
        
        DispatchQueue.main.async {
            if mediaData != nil {
                photoCell.mediaImage.image = UIImage(data: mediaData!)
            } else {
                photoCell.mediaImage.image = UIImage(color: .gray) // placeholder
            }
        }
        
        return photoCell
    }
    
    func setupCollectionFlowSize()
    {
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
}
