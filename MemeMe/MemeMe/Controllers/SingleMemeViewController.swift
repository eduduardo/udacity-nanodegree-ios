//
//  SingleMemeViewController.swift
//  MemeMe
//
//  Created by Eduardo Ramos on 13/06/21.
//

import Foundation
import UIKit

class SingleMemeViewController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = meme.memedImage
    }
    
}
