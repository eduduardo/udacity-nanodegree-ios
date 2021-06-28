//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Eduardo Ramos on 12/06/21.
//

import Foundation
import UIKit


class SentMemesCollectionViewController : MemesDisplayViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    // MARK: lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupCollectionFlowSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView!.reloadData()
    }
    
    func setupCollectionFlowSize()
    {
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    // MARK: collection methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell", for: indexPath) as! MemeCollectionViewCell
        cell.imageView.image = memes[indexPath.row].memedImage

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToSingleMemeView(memes[indexPath.row])
    }
    
}
