//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Eduardo Ramos on 26/06/21.
//

import Foundation
import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var newCollectionButton: UIButton!
    
    var loadingIndicator: UIActivityIndicatorView!
    var loadingView: UIView!
    
    var annotationPin: Pin?
    
    var dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupLoading()
        setupMap()
        
        addMapAnnotation(annotationPin!)
        setupFetchedResultsController()
        
        setupCollectionFlowSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getFlickImages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    func setupPin(_ pin: Pin) {
        annotationPin = pin
    }
    
    func setupLoading(){
        loadingView = UIView()
        loadingView.frame = view.frame
        loadingView.center = view.center
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        loadingView.bringSubviewToFront(view)
        loadingView.isHidden = true
        
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .white
        loadingIndicator.bringSubviewToFront(loadingView)
        loadingIndicator.center = view.center
        view.addSubview(loadingView)
        view.addSubview(loadingIndicator)
    }
    
    func toggleLoading(_ loading: Bool){
        DispatchQueue.main.async {
            if loading {
                self.loadingView.isHidden = false
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingView.isHidden = true
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: ImageTapGesture)
    {
        guard let photo = tapGestureRecognizer.photo else { return }
        
        self.dataController.viewContext.delete(photo)
        self.dataController.save()
    }
    
    func getFlickImages(){
        guard (fetchedResultsController.fetchedObjects?.isEmpty)! else {
            toggleLoading(false)
            print("Images already downloaded, skipping!")
            return
        }
        
        toggleLoading(true)
        
        FlickrClient.shared.getPhotos(latitude: annotationPin!.latitude, longitude: annotationPin!.longitude, totalPages: annotationPin!.totalPages) { (photos, pages, error) in
            guard error == nil else {
                self.showAlertModal("Flickr Photos", "Error while loading photos")
                return
            }
            
            // update max pages of the pin!
            self.annotationPin!.totalPages = Int16(pages)
            self.dataController.save()
            
            if photos.count <= 0 {
                self.showAlertModal("No images founded", "None images founded")
                self.toggleLoading(false)
                return
            }
            
            for flickrPhoto in photos {
                let photo = Photo(context: self.dataController.viewContext)
                photo.mediaUrl = flickrPhoto.url_m
                photo.title = flickrPhoto.title
                photo.pin = self.annotationPin
                photo.createdAt = Date()
                
                self.dataController.save()
                
                DispatchQueue.global(qos: .background).async {
                    FlickrClient.donwloadImage(mediaUrl: photo.mediaUrl!) { (data, error) in
                        guard error == nil else {
                            self.showAlertModal("Image Donwload", "Error while donwload image")
                            return
                        }

                        photo.media = data
                        self.dataController.save()
                    }
                }
            }
            
            self.toggleLoading(false)
            DispatchQueue.main.async {
                self.newCollectionButton.isEnabled = true
            }
        }
    }
    
    @IBAction func newCollectionAction(_ sender: Any) {
        guard let photos = fetchedResultsController.fetchedObjects else {
            return
        }
        
        newCollectionButton.isEnabled = false
        
        for photo in photos {
            self.dataController.viewContext.delete(photo)
            self.dataController.save()
        }
        
        self.getFlickImages()
    }
}
